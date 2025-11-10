import '../models/item_model.dart';

class ItemService {
  static final ItemService _instance = ItemService._internal();
  factory ItemService() => _instance;
  ItemService._internal();

  // Simulação de dados (em produção, seria uma API real)
  final List<ItemModel> _items = [
    ItemModel(
      id: 1,
      description: 'Mochila preta com um livro dentro.',
      category: 'Acessórios',
      status: 'aprovado',
      imageUrl: 'https://via.placeholder.com/300x200?text=Mochila',
      location: LocationModel(latitude: 38.736946, longitude: -9.142685),
    ),
    ItemModel(
      id: 2,
      description: 'Chaves de casa com um porta-chaves do Star Wars.',
      category: 'Chaves',
      status: 'pendente',
      imageUrl: 'https://via.placeholder.com/300x200?text=Chaves',
      location: LocationModel(latitude: 38.71667, longitude: -9.13333),
    ),
    ItemModel(
      id: 3,
      description: 'Carteira marrom de couro.',
      category: 'Documentos',
      status: 'aprovado',
      imageUrl: 'https://via.placeholder.com/300x200?text=Carteira',
      location: LocationModel(latitude: 38.7223, longitude: -9.1393),
    ),
  ];

  int _nextId = 4;

  Future<List<ItemModel>> getItems({String? status}) async {
    // Simular delay de rede
    await Future.delayed(const Duration(milliseconds: 500));

    if (status != null) {
      return _items.where((item) => item.status == status).toList();
    }
    return List.from(_items);
  }

  Future<List<ItemModel>> getApprovedItems() async {
    return getItems(status: 'aprovado');
  }

  Future<List<ItemModel>> getPendingItems() async {
    return getItems(status: 'pendente');
  }

  Future<ItemModel> reportItem(ItemModel item) async {
    // Simular delay de rede
    await Future.delayed(const Duration(seconds: 1));

    final newItem = ItemModel(
      id: _nextId++,
      description: item.description,
      category: item.category,
      status: 'pendente',
      imageUrl: item.imageUrl,
      location: item.location,
    );

    _items.add(newItem);
    return newItem;
  }

  Future<void> validateItem(int itemId) async {
    // Simular delay de rede
    await Future.delayed(const Duration(milliseconds: 500));

    final index = _items.indexWhere((item) => item.id == itemId);
    if (index != -1) {
      final item = _items[index];
      _items[index] = ItemModel(
        id: item.id,
        description: item.description,
        category: item.category,
        status: 'aprovado',
        imageUrl: item.imageUrl,
        location: item.location,
      );
    }
  }

  Future<void> deleteItem(int itemId) async {
    // Simular delay de rede
    await Future.delayed(const Duration(milliseconds: 500));

    _items.removeWhere((item) => item.id == itemId);
  }
}

