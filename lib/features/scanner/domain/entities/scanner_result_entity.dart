class ScannerResultEntity {
  final String label;
  final double? confidence;
  final String? category;
  final String? disposalAdvice;
  final Map<String, dynamic> rawResponse;

  const ScannerResultEntity({
    required this.label,
    this.confidence,
    this.category,
    this.disposalAdvice,
    required this.rawResponse,
  });
}
