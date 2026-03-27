import 'package:ecosyncai/features/scanner/domain/entities/scanner_result_entity.dart';

class ScannerResultModel {
  final String label;
  final double? confidence;
  final String? category;
  final String? disposalAdvice;
  final Map<String, dynamic> rawResponse;

  const ScannerResultModel({
    required this.label,
    this.confidence,
    this.category,
    this.disposalAdvice,
    required this.rawResponse,
  });

  factory ScannerResultModel.fromJson(Map<String, dynamic> json) {
    final nested = _extractNested(json);

    final label = _readString(
          sources: [json, nested],
          keys: const ['label', 'class', 'prediction', 'predicted_class', 'type'],
        ) ??
        'Unknown';

    return ScannerResultModel(
      label: label,
      confidence: _readDouble(
        sources: [json, nested],
        keys: const ['confidence', 'score', 'probability'],
      ),
      category: _readString(
        sources: [json, nested],
        keys: const ['category', 'waste_type'],
      ),
      disposalAdvice: _readString(
        sources: [json, nested],
        keys: const ['disposal_advice', 'advice', 'instruction', 'recommendation'],
      ),
      rawResponse: json,
    );
  }

  ScannerResultEntity toEntity() {
    return ScannerResultEntity(
      label: label,
      confidence: confidence,
      category: category,
      disposalAdvice: disposalAdvice,
      rawResponse: rawResponse,
    );
  }

  static Map<String, dynamic> _extractNested(Map<String, dynamic> json) {
    for (final key in const ['result', 'prediction', 'data']) {
      final value = json[key];
      if (value is Map<String, dynamic>) return value;
    }
    return <String, dynamic>{};
  }

  static String? _readString({
    required List<Map<String, dynamic>> sources,
    required List<String> keys,
  }) {
    for (final source in sources) {
      for (final key in keys) {
        final value = source[key];
        if (value is String && value.trim().isNotEmpty) return value.trim();
      }
    }
    return null;
  }

  static double? _readDouble({
    required List<Map<String, dynamic>> sources,
    required List<String> keys,
  }) {
    for (final source in sources) {
      for (final key in keys) {
        final value = source[key];
        if (value is num) return value.toDouble();
        if (value is String) {
          final parsed = double.tryParse(value);
          if (parsed != null) return parsed;
        }
      }
    }
    return null;
  }
}
