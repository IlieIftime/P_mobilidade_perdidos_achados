import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as ll;
import '../utils/map_config.dart';
import '../models/item_model.dart';

class MapPickerScreen extends StatefulWidget {
  final LocationModel? initialLocation;

  const MapPickerScreen({super.key, this.initialLocation});

  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  late final MapController _controller = MapController();
  ll.LatLng? _picked;

  @override
  void initState() {
    super.initState();
    if (widget.initialLocation != null) {
      _picked = ll.LatLng(widget.initialLocation!.latitude, widget.initialLocation!.longitude);
    }
  }

  void _onTap(ll.LatLng p) {
    setState(() => _picked = p);
  }

  void _confirm() {
    if (_picked == null) return;
    Navigator.of(context).pop(LocationModel(latitude: _picked!.latitude, longitude: _picked!.longitude));
  }

  @override
  Widget build(BuildContext context) {
    if (!MapConfig.hasMapTilerKey) {
      return Scaffold(
        appBar: AppBar(title: const Text('Escolher localização')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Nenhuma chave de tiles configurada. Configure MAPTILER_KEY e tente novamente.'),
                const SizedBox(height: 12),
                ElevatedButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Fechar')),
              ],
            ),
          ),
        ),
      );
    }

    final center = _picked ?? ll.LatLng(38.736946, -9.142685);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Escolher localização'),
        actions: [
          TextButton(
            onPressed: _confirm,
            child: const Text('Confirmar', style: TextStyle(color: Colors.white)),
          )
        ],
      ),
      body: FlutterMap(
        mapController: _controller,
        options: MapOptions(
          center: center,
          zoom: 13.0,
          onTap: (tapPos, latlng) => _onTap(latlng),
        ),
        children: [
          TileLayer(
            urlTemplate: MapConfig.tileUrlTemplate,
            userAgentPackageName: 'com.example.app',
          ),
          if (_picked != null)
            MarkerLayer(
              markers: [
                Marker(
                  point: _picked!,
                  width: 40,
                  height: 40,
                  builder: (ctx) => const Icon(Icons.location_on, color: Colors.red, size: 40),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

