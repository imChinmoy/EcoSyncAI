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
      binCount: _readInt(json, const [
            'binCount',
            'bin_count',
            'bins',
            'binsCount',
            'bins_count',
            'totalBins',
            'total_bins',
          ]) ??
          0,
      fullCount: _readInt(json, const [
            'fullCount',
            'full_count',
            'fullBins',
            'full_bins',
            'full',
            'binsFull',
            'bins_full',
          ]) ??
          0,
    );
  }

  static int? _readInt(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final v = json[key];
      if (v is num) return v.toInt();
      if (v is String) return int.tryParse(v);
    }
    return null;
  }

  WardEntity toEntity() {
    return WardEntity(id: id, name: name, binCount: binCount, fullCount: fullCount);
  }
}

