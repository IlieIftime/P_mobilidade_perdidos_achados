import 'package:flutter/material.dart';

import '../models/item_model.dart';
import '../services/item_service.dart';
import '../services/auth_service.dart';
import 'report_form_screen.dart';
import 'simple_map_screen.dart';

class HomepageScreen extends StatefulWidget {
  /// Se for true, o utilizador entra em modo “visitante”
  final bool isGuest;

  const HomepageScreen({
    super.key,
    this.isGuest = false,
  });

  @override
  State<HomepageScreen> createState() => _HomepageScreenState();
}

class _HomepageScreenState extends State<HomepageScreen> {
  final ItemService _itemService = ItemService();
  final TextEditingController _searchController = TextEditingController();

  bool _isLoading = false;
  List<ItemModel> _items = [];
  List<ItemModel> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadItems() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final items = await _itemService.getAllItems();
      setState(() {
        _items = items;
        _filteredItems = items;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao carregar itens: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _applySearch(String query) {
    final q = query.trim().toLowerCase();
    setState(() {
      if (q.isEmpty) {
        _filteredItems = _items;
      } else {
        _filteredItems = _items.where((item) {
          return item.description.toLowerCase().contains(q) ||
              item.category.toLowerCase().contains(q);
        }).toList();
      }
    });
  }

  Future<void> _openMap() async {
    if (_filteredItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não há itens para mostrar no mapa.'),
        ),
      );
      return;
    }

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SimpleMapScreen(
          items: _filteredItems,
        ),
      ),
    );
  }

  Future<void> _logout() async {
    // ✅ Se não for visitante, faz logout real
    if (!widget.isGuest) {
      await AuthService().logout();
    }

    if (!mounted) return;

    // ✅ Volta ao login (rota existe no main.dart)
    Navigator.of(context).pushNamedAndRemoveUntil(
      '/login',
          (route) => false,
    );
  }

  /// Remover item na Homepage (user/admin, excepto visitante)
  Future<void> _deleteItem(ItemModel item) async {
    if (item.id == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar remoção'),
        content: const Text('Tens a certeza que queres remover este item?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(
              'Remover',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await _itemService.deleteItem(item.id!);
      await _loadItems();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Item removido com sucesso')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao remover item: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _openReportForm() async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => const ReportFormScreen(),
      ),
    );

    if (result == true) {
      _loadItems();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isGuest = widget.isGuest;

    return Scaffold(
      appBar: AppBar(
        title: const Text('SOS Perdidos e Achados'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.map),
            onPressed: _openMap,
            tooltip: 'Ver mapa',
          ),

          // ✅ Agora aparece SEMPRE, inclusive visitante
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Sair',
          ),
        ],
      ),
      floatingActionButton: isGuest
          ? null
          : FloatingActionButton.extended(
        onPressed: _openReportForm,
        backgroundColor: Colors.orange,
        icon: const Icon(Icons.add),
        label: const Text('Reportar'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Pesquisar por descrição ou categoria...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 0,
                ),
              ),
              onChanged: _applySearch,
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredItems.isEmpty
                ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.search_off, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'Nenhum item encontrado',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ],
            )
                : RefreshIndicator(
              onRefresh: _loadItems,
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                itemCount: _filteredItems.length,
                itemBuilder: (context, index) {
                  final item = _filteredItems[index];
                  return _ItemCard(
                    item: item,
                    canDelete: !isGuest,
                    onDelete: () => _deleteItem(item),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ItemCard extends StatelessWidget {
  final ItemModel item;
  final bool canDelete;
  final VoidCallback? onDelete;

  const _ItemCard({
    required this.item,
    this.canDelete = false,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // Detalhes (se tiveres) aqui
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (item.imageUrl != null && item.imageUrl!.isNotEmpty)
              ClipRRect(
                borderRadius:
                const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  item.imageUrl!,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 120,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(16),
                    child: const Icon(Icons.broken_image),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          item.category,
                          style: const TextStyle(
                            color: Colors.blue,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.location_on, size: 16),
                      const SizedBox(width: 4),
                      const Text('Ver no mapa', style: TextStyle(fontSize: 12)),
                      if (canDelete) ...[
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.delete_outline),
                          color: Colors.red,
                          tooltip: 'Remover item',
                          onPressed: onDelete,
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.description,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Lat: ${item.location.latitude.toStringAsFixed(5)}, '
                        'Long: ${item.location.longitude.toStringAsFixed(5)}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
