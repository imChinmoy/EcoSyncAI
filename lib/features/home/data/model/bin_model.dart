
import 'package:ecosyncai/features/home/domain/entities/bin_entity.dart';

class BinModel extends BinEntity {
  const BinModel({
    required super.id,
    required super.wardId,
    required super.lat,
    required super.lng,
    required super.status,
    required super.category,
    required super.capacity,
    required super.address,
    required super.lastUpdated,
  });

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

  factory BinModel.fromEntity(BinEntity bin) {
    return BinModel(
      id: bin.id,
      wardId: bin.wardId,
      lat: bin.lat,
      lng: bin.lng,
      status: bin.status,
      category: bin.category,
      capacity: bin.capacity,
      address: bin.address,
      lastUpdated: bin.lastUpdated,
    );
  }

  BinEntity toEntity() {
    return BinEntity(
      id: id,
      wardId: wardId,
      lat: lat,
      lng: lng,
      status: status,
      category: category,
      capacity: capacity,
      address: address,
      lastUpdated: lastUpdated,
    );
  }
}