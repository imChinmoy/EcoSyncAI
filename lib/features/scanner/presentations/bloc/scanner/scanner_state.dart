import 'package:ecosyncai/features/scanner/domain/entities/scanner_result_entity.dart';

enum ScannerStatus { initial, loading, success, error }

class ScannerState {
  final ScannerStatus status;
  final String capturedImagePath;
  final String errorMessage;
  final bool isTorchOn;
  final ScannerResultEntity? result;

  const ScannerState({
    this.status = ScannerStatus.initial,
    this.capturedImagePath = '',
    this.errorMessage = '',
    this.isTorchOn = false,
    this.result,
  });

  ScannerState copyWith({
    ScannerStatus? status,
    String? capturedImagePath,
    String? errorMessage,
    bool? isTorchOn,
    ScannerResultEntity? result,
    bool clearResult = false,
    bool clearError = false,
  }) {
    return ScannerState(
      status: status ?? this.status,
      capturedImagePath: capturedImagePath ?? this.capturedImagePath,
      errorMessage: clearError ? '' : (errorMessage ?? this.errorMessage),
      isTorchOn: isTorchOn ?? this.isTorchOn,
      result: clearResult ? null : (result ?? this.result),
    );
  }
}
