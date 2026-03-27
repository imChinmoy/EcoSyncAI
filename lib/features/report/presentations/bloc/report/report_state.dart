import 'package:ecosyncai/features/home/domain/entities/bin_entity.dart';

enum ReportStatus { idle, submitting, success, error }

class ReportState {
  final ReportStatus status;
  final BinEntity? selectedBin;
  final int? selectedWardId;
  final String description;
  final bool hasImage;
  final String? capturedImagePath;
  final bool isTorchOn;
  final String aiLabel;
  final String errorMessage;

  const ReportState({
    this.status = ReportStatus.idle,
    this.selectedBin,
    this.selectedWardId,
    this.description = '',
    this.hasImage = false,
    this.capturedImagePath,
    this.isTorchOn = false,
    this.aiLabel = '',
    this.errorMessage = '',
  });

  ReportState copyWith({
    ReportStatus? status,
    BinEntity? selectedBin,
    int? selectedWardId,
    bool clearSelectedBin = false,
    bool clearCapturedImagePath = false,
    String? description,
    bool? hasImage,
    String? capturedImagePath,
    bool? isTorchOn,
    String? aiLabel,
    String? errorMessage,
  }) {
    return ReportState(
      status: status ?? this.status,
      selectedBin: clearSelectedBin ? null : (selectedBin ?? this.selectedBin),
      selectedWardId: selectedWardId ?? this.selectedWardId,
      description: description ?? this.description,
      hasImage: hasImage ?? this.hasImage,
      capturedImagePath: clearCapturedImagePath
          ? null
          : (capturedImagePath ?? this.capturedImagePath),
      isTorchOn: isTorchOn ?? this.isTorchOn,
      aiLabel: aiLabel ?? this.aiLabel,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
