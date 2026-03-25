class BinModel {
  final String id;
  final int wardId;
  final double lat;
  final double lng;
  final String status; // "Empty" | "Filling" | "Full"
  final String category;
  final int capacity; // percentage 0-100
  final String address;
  final DateTime lastUpdated;

  const BinModel({
    required this.id,
    required this.wardId,
    required this.lat,
    required this.lng,
    required this.status,
    required this.category,
    required this.capacity,
    required this.address,
    required this.lastUpdated,
  });

  BinModel copyWith({
    String? status,
    int? capacity,
    DateTime? lastUpdated,
  }) {
    return BinModel(
      id: id,
      wardId: wardId,
      lat: lat,
      lng: lng,
      status: status ?? this.status,
      category: category,
      capacity: capacity ?? this.capacity,
      address: address,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  /// (Future use) Convert from JSON
  factory BinModel.fromJson(Map<String, dynamic> json) {
    return BinModel(
      id: json['id'].toString(),
      wardId: json['wardId'],
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      status: json['status'],
      category: json['category'],
      capacity: json['capacity'] ?? 0,
      address: json['address'] ?? '',
      lastUpdated: DateTime.parse(json['lastUpdated']),
    );
  }

  /// (Future use) Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'wardId': wardId,
      'lat': lat,
      'lng': lng,
      'status': status,
      'category': category,
      'capacity': capacity,
      'address': address,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }
}