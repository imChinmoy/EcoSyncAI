import 'package:ecosyncai/dummy_data/models/bin_model.dart';

enum ReportStatus { idle, submitting, success, error }

class ReportState {
  final ReportStatus status;
  final BinModel? selectedBin;
  final String description;
  final bool hasImage;
  final String aiLabel;
  final String errorMessage;

  const ReportState({
    this.status = ReportStatus.idle,
    this.selectedBin,
    this.description = '',
    this.hasImage = false,
    this.aiLabel = '',
    this.errorMessage = '',
  });

  ReportState copyWith({
    ReportStatus? status,
    BinModel? selectedBin,
    bool clearSelectedBin = false,
    String? description,
    bool? hasImage,
    String? aiLabel,
    String? errorMessage,
  }) {
    return ReportState(
      status: status ?? this.status,
      selectedBin: clearSelectedBin ? null : (selectedBin ?? this.selectedBin),
      description: description ?? this.description,
      hasImage: hasImage ?? this.hasImage,
      aiLabel: aiLabel ?? this.aiLabel,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
