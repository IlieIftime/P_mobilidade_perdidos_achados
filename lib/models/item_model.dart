class ItemModel {
  final int? id;
  final String description;
  final String category;
  final String status; // 'pendente' ou 'aprovado'
  final String? imageUrl;
  final LocationModel location;

  ItemModel({
    this.id,
    required this.description,
    required this.category,
    this.status = 'pendente',
    this.imageUrl,
    required this.location,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      id: json['id'],
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      status: json['status'] ?? 'pendente',
      imageUrl: json['imageUrl'],
      location: LocationModel.fromJson(json['location'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'description': description,
      'category': category,
      'status': status,
      'imageUrl': imageUrl,
      'location': location.toJson(),
    };
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
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}

