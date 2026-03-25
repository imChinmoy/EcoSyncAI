class ComplaintModel {
  final String binId;
  final String description;
  final String? imagePath; // null = no image (mock)
  final String aiLabel;
  final DateTime submittedAt;

  const ComplaintModel({
    required this.binId,
    required this.description,
    this.imagePath,
    required this.aiLabel,
    required this.submittedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'binId': binId,
      'description': description,
      'imagePath': imagePath,
      'aiLabel': aiLabel,
      'submittedAt': submittedAt.toIso8601String(),
    };
  }
}
