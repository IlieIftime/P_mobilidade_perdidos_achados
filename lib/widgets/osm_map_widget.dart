import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart' as ll;
import '../models/item_model.dart';
import '../utils/map_config.dart';

class OsmMapWidget extends StatefulWidget {
  final List<ItemModel> items;
  final dynamic initialCenter; // accept our small LatLng or null
  final double initialZoom;
  final void Function(dynamic controller)? onMapCreated;
  final void Function(ItemModel)? onMarkerTap;

  const OsmMapWidget({
    super.key,
    required this.items,
    this.initialCenter,
    this.initialZoom = 13.0,
    this.onMapCreated,
    this.onMarkerTap,
  });

  @override
  State<OsmMapWidget> createState() => _OsmMapWidgetState();
}

class _OsmMapWidgetState extends State<OsmMapWidget> {
  late final MapController _mapController;
  String? _activeTileTemplate;
  bool _probing = false;
  String? _probeError;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.onMapCreated != null) widget.onMapCreated!(_mapController);
      // attempt to fit bounds if there are multiple points
      _fitToPoints();
      // If we have a MapTiler key, probe candidates to pick a working tile URL
      if (MapConfig.hasMapTilerKey) {
        _probeTileTemplates();
      }
    });
  }

  Future<void> _probeTileTemplates() async {
    setState(() {
      _probing = true;
      _probeError = null;
    });

    final candidates = MapConfig.tileUrlCandidates;
    for (final template in candidates) {
      try {
        // Replace z/x/y with a small tile (0/0/0) to test availability
        final testUrl = template
            .replaceAll('{z}', '0')
            .replaceAll('{x}', '0')
            .replaceAll('{y}', '0');

        final uri = Uri.parse(testUrl);
        final resp = await http.get(uri).timeout(const Duration(seconds: 5));
        if (resp.statusCode == 200 && resp.headers['content-type']?.startsWith('image/') == true) {
          setState(() {
            _activeTileTemplate = template;
            _probing = false;
          });
          return;
        }
      } catch (e) {
        // ignore and try next candidate
      }
    }

    setState(() {
      _probing = false;
      _probeError = 'Nenhum template de tiles respondeu com sucesso. Verifica a chave MapTiler.';
    });
  }

  void _fitToPoints() {
    final points = widget.items
        .map((i) => ll.LatLng(i.location.latitude, i.location.longitude))
        .where((p) => !(p.latitude.abs() < 0.000001 && p.longitude.abs() < 0.000001))
        .toList();
    if (points.isEmpty) return;
    if (points.length == 1) {
      _mapController.move(points.first, widget.initialZoom);
      return;
    }
    final latitudes = points.map((p) => p.latitude);
    final longitudes = points.map((p) => p.longitude);
    final north = latitudes.reduce((a, b) => a > b ? a : b);
    final south = latitudes.reduce((a, b) => a < b ? a : b);
    final east = longitudes.reduce((a, b) => a > b ? a : b);
    final west = longitudes.reduce((a, b) => a < b ? a : b);

    final bounds = LatLngBounds(ll.LatLng(south, west), ll.LatLng(north, east));
    try {
      _mapController.fitBounds(bounds, options: FitBoundsOptions(padding: EdgeInsets.all(48)));
    } catch (_) {
      // ignore fit errors
    }
  }

  @override
  void didUpdateWidget(covariant OsmMapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // refit when items change
    if (oldWidget.items != widget.items) {
      _fitToPoints();
    }
  }

  @override
  Widget build(BuildContext context) {
    final pointsWithItems = widget.items
        .map((i) => MapEntry(ll.LatLng(i.location.latitude, i.location.longitude), i))
        .where((e) => !(e.key.latitude.abs() < 0.000001 && e.key.longitude.abs() < 0.000001))
        .toList();

    if (pointsWithItems.isEmpty) {
      return SizedBox(
        height: 240,
        child: Container(
          color: Colors.brown[50],
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.map_outlined, size: 48, color: Colors.black45),
                SizedBox(height: 12),
                Text('Sem coordenadas válidas para mostrar no mapa', style: TextStyle(color: Colors.black54)),
              ],
            ),
          ),
        ),
      );
    }

    final center = widget.initialCenter != null
        ? ll.LatLng(widget.initialCenter!.latitude, widget.initialCenter!.longitude)
        : pointsWithItems.first.key;

    // If we don't have a configured tile provider key, avoid using volunteer-run OSM tile servers.
    if (!MapConfig.hasMapTilerKey) {
      return SizedBox(
        height: 240,
        child: Container(
          color: Colors.brown[50],
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.block, size: 48, color: Colors.black45),
                const SizedBox(height: 12),
                const Text('Tiles públicos do OpenStreetMap não devem ser usados por aplicações de produção.'),
                const SizedBox(height: 8),
                const Text('Por favor, configure uma chave de tiles (ex: MapTiler) em lib/utils/map_config.dart'),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Configurar tile provider'),
                        content: const Text(
                          'Para não usar os tiles públicos do OpenStreetMap (servidores voluntários), crie uma conta gratuita em https://www.maptiler.com/ e cole a sua API key em lib/utils/map_config.dart (mapTilerKey).',
                        ),
                        actions: [
                          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Fechar')),
                        ],
                      ),
                    );
                  },
                  child: const Text('Entendi'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // If we're probing for a working tile template, show a loader.
    if (_probing) {
      return SizedBox(
        height: 240,
        child: Center(child: Column(mainAxisSize: MainAxisSize.min, children: const [CircularProgressIndicator(), SizedBox(height:8), Text('A carregar tiles...')])),
      );
    }

    // If probing finished but no active template was found, show an error with retry.
    if (_activeTileTemplate == null) {
      return SizedBox(
        height: 240,
        child: Container(
          color: Colors.brown[50],
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.black45),
                const SizedBox(height: 12),
                Text(_probeError ?? 'Erro ao carregar tiles.'),
                const SizedBox(height: 8),
                ElevatedButton(onPressed: _probeTileTemplates, child: const Text('Tentar novamente')),
                const SizedBox(height: 8),
                const Text('Se o problema persistir, verifica a tua chave MapTiler.'),
              ],
            ),
          ),
        ),
      );
    }

    return SizedBox(
      height: 240,
      child: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          center: center,
          zoom: widget.initialZoom,
          onTap: (_, __) {},
        ),
        children: [
          TileLayer(
            urlTemplate: _activeTileTemplate!,
            userAgentPackageName: 'com.example.app',
            tileProvider: NetworkTileProvider(),
          ),
          MarkerLayer(
            markers: pointsWithItems
                .map((e) => Marker(
                      point: e.key,
                      width: 40,
                      height: 40,
                      builder: (ctx) => GestureDetector(
                        onTap: () => widget.onMarkerTap?.call(e.value),
                        child: const Icon(Icons.location_on, color: Colors.red, size: 36),
                      ),
                    ))
                .toList(),
          ),
          // Attribution overlay
          Positioned(
            right: 8,
            bottom: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              color: Colors.white70,
              child: Text(
                MapConfig.attributionText,
                style: const TextStyle(fontSize: 10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
