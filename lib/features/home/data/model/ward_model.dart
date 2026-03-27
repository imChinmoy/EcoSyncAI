import 'package:ecosyncai/features/home/domain/entities/ward_entity.dart';

class WardModel extends WardEntity {
  const WardModel({
    required super.id,
    required super.name,
    required super.binCount,
    required super.fullCount,
  });

  factory WardModel.fromJson(Map<String, dynamic> json) {
    return WardModel(
      id: (json['id'] as num).toInt(),
      name: (json['name'] ?? 'Ward ${json['id']}').toString(),
      binCount: (json['binCount'] as num?)?.toInt() ?? 0,
      fullCount: (json['fullCount'] as num?)?.toInt() ?? 0,
    );
  }

  WardEntity toEntity() {
    return WardEntity(id: id, name: name, binCount: binCount, fullCount: fullCount);
  }
}

