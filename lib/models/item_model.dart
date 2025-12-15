import 'package:cloud_firestore/cloud_firestore.dart';


class ItemModel {
  final String? id;
  final String description;
  final String category;
  final String status; // 'pendente' ou 'aprovado'
  final String? imageUrl;
  final LocationModel location;
  final String? phone;

  ItemModel({
    this.id,
    required this.description,
    required this.category,
    this.status = 'pendente',
    this.imageUrl,
    required this.location,
    this.phone,
  });

  factory ItemModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return ItemModel(
      id: doc.id,
      description: data['description'] ?? '',
      category: data['category'] ?? '',
      status: data['status'] ?? 'pendente',
      imageUrl: data['imageUrl'],
      phone: data['phone'],
      location: LocationModel.fromJson(
        Map<String, dynamic>.from(data['location']),
      ),
    );
  }
}

class LocationModel {
  final double latitude;
  final double longitude;

  LocationModel({
    required this.latitude,
    required this.longitude,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }
}

