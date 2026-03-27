import 'dart:math';

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

  /// When the API omits capacity or sends 0, derive a plausible % from [status]
  /// so UI stays consistent (stable per bin id until real data exists).
  static int _mockCapacityFromStatus(String status, String binId) {
    final s = status.toString().toLowerCase();
    final r = Random(binId.hashCode);
    switch (s) {
      case 'full':
        return 90 + r.nextInt(11); // 90–100
      case 'filling':
        return 20 + r.nextInt(61); // 20–80
      case 'empty':
      default:
        return r.nextInt(21); // 0–20
    }
  }

  factory BinModel.fromJson(Map<String, dynamic> json) {
    final raw = json['capacity'];
    final int capacity;
    if (raw != null && raw is num && raw > 0) {
      capacity = raw.round();
    } else {
      capacity = _mockCapacityFromStatus(
        json['status'] ?? '',
        json['id'].toString(),
      );
    }

    return BinModel(
      id: json['id'].toString(),
      wardId: json['wardId'],
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      status: json['status'],
      category: json['category'],
      capacity: capacity,
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