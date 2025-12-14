import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/item_model.dart';
import 'auth_service.dart';

class ItemService {
  static final ItemService _instance = ItemService._internal();
  factory ItemService() => _instance;
  ItemService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _authService = AuthService();

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

  // Exemplo, adapta ao que já tens dentro do ItemService
  Future<List<ItemModel>> getAllItems() async {
    // Se já tiveres um método que devolve a lista, por exemplo getItems(),
    // podes simplesmente delegar:
    return getItems();
  }


  Future<List<ItemModel>> getApprovedItems() async {
    return getItems(status: 'aprovado');
  }

  Future<List<ItemModel>> getPendingItems() async {
    return getItems(status: 'pendente');
  }

  Future<ItemModel> reportItem(ItemModel item) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final user = _authService.currentUser;

    final newItem = ItemModel(
      id: _nextId++,
      description: item.description,
      category: item.category,
      status: 'pendente',
      imageUrl: item.imageUrl,
      location: item.location,
    );

    _items.add(newItem);

    try {
      final Map<String, dynamic> data = {
        'id': newItem.id,
        'description': newItem.description,
        'category': newItem.category,
        'status': newItem.status,
        'imageUrl': newItem.imageUrl,
        'location': newItem.location == null
            ? null
            : {
          'latitude': newItem.location!.latitude,
          'longitude': newItem.location!.longitude,
        },
        'userId': user?.id,
        'emailUser': user?.email,
        'createdAt': FieldValue.serverTimestamp(),
      };

      await _firestore
          .collection('produtos_desaparecidos')
          .add(data)
          .timeout(const Duration(seconds: 15));

    } catch (e, st) {
      print("⚠️ Erro ao gravar no Firestore: $e\n$st");
    }

    return newItem;
  }

  Future<void> validateItem(int itemId) async {
    // Simular delay de rede
    await Future.delayed(const Duration(milliseconds: 500));

    // 1) Atualizar na Firestore: procurar doc(s) com o campo id == itemId
    try {
      final query = await _firestore
          .collection('produtos_desaparecidos')
          .where('id', isEqualTo: itemId)
          .limit(1)
          .get();

      if (query.docs.isNotEmpty) {
        final doc = query.docs.first;
        await doc.reference.update({'status': 'aprovado', 'updatedAt': DateTime.now()});
      } else {
        // fallback por description+category, usando index para evitar null
        final indexLocal = _items.indexWhere((it) => it.id == itemId);
        if (indexLocal != -1) {
          final local = _items[indexLocal];
          final q2 = await _firestore
              .collection('produtos_desaparecidos')
              .where('description', isEqualTo: local.description)
              .where('category', isEqualTo: local.category)
              .limit(1)
              .get();
          if (q2.docs.isNotEmpty) {
            await q2.docs.first.reference.update({'status': 'aprovado', 'updatedAt': DateTime.now()});
          }
        }
      }
    } catch (e) {
      // print('Erro ao aprovar no Firestore: $e');
    }

    // 2) Atualizar a lista local
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

    // 1) Apagar do Firestore (se existir)
    try {
      final query = await _firestore
          .collection('produtos_desaparecidos')
          .where('id', isEqualTo: itemId)
          .limit(1)
          .get();

      if (query.docs.isNotEmpty) {
        await query.docs.first.reference.delete();
      } else {
        // fallback por description+category, usando index para evitar null
        final indexLocal = _items.indexWhere((it) => it.id == itemId);
        if (indexLocal != -1) {
          final local = _items[indexLocal];
          final q2 = await _firestore
              .collection('produtos_desaparecidos')
              .where('description', isEqualTo: local.description)
              .where('category', isEqualTo: local.category)
              .limit(1)
              .get();
          if (q2.docs.isNotEmpty) {
            await q2.docs.first.reference.delete();
          }
        }
      }
    } catch (e) {
      // print('Erro ao apagar no Firestore: $e');
    }

    // 2) Apagar da lista local
    _items.removeWhere((item) => item.id == itemId);
  }

  /// MIGRAR ITENS LOCAIS PARA O FIRESTORE (executar UMA vez)
  Future<int> migrateLocalItemsToFirestore() async {
    int migrated = 0;
    final collection = _firestore.collection('produtos_desaparecidos');

    for (final item in _items) {
      try {
        // 1) Cheque simples para evitar duplicados: mesma description + category
        final query = await collection
            .where('description', isEqualTo: item.description)
            .where('category', isEqualTo: item.category)
            .limit(1)
            .get();

        if (query.docs.isNotEmpty) {
          // já existe -> pular
          continue;
        }

        // 2) Preparar dados para gravar
        Map<String, dynamic> data;
        try {
          // tenta usar toJson() do modelo se existir
          data = {...item.toJson()};
        } catch (_) {
          // fallback se não existir toJson()
          data = {
            'description': item.description,
            'category': item.category,
            'status': item.status,
            'imageUrl': item.imageUrl,
            'location': item.location == null
                ? null
                : {
              'latitude': item.location!.latitude,
              'longitude': item.location!.longitude,
            },
          };
        }

        // Campos extra adicionados para a migração
        data['migrated'] = true;
        data['createdAt'] = DateTime.now();
        data['userId'] = null;
        data['emailUser'] = null;

        await collection.add(data);
        migrated++;
      } catch (e) {
        // não travar toda a migração por um erro num item
        // se quiseres debugar, descomenta a linha abaixo
        // print('Erro ao migrar item "${item.description}": $e');
        continue;
      }
    }

    return migrated;
  }

  /// Sincronizar estados locais com Firestore (executar UMA vez)
  Future<int> syncLocalStatusesToFirestore() async {
    int updated = 0;
    final collection = _firestore.collection('produtos_desaparecidos');

    for (final item in _items) {
      try {
        final query = await collection.where('id', isEqualTo: item.id).limit(1).get();
        if (query.docs.isNotEmpty) {
          final doc = query.docs.first;
          final serverStatus = doc.data()['status'] as String?;
          if (serverStatus != item.status) {
            await doc.reference.update({
              'status': item.status,
              'updatedAt': DateTime.now(),
            });
            updated++;
          }
        }
      } catch (_) {
        // ignorar erros individuais
        continue;
      }
    }
    return updated;
  }

}


