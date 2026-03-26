enum ScannerStatus { initial, loading, success, error }

class ScannerState {
  final ScannerStatus status;
  final String? capturedImagePath;
  final String? errorMessage;
  final bool isTorchOn;

  const ScannerState({
    this.status = ScannerStatus.initial,
    this.capturedImagePath,
    this.errorMessage,
    this.isTorchOn = false,
  });

  ScannerState copyWith({
    ScannerStatus? status,
    String? capturedImagePath,
    String? errorMessage,
    bool? isTorchOn,
  }) {
    return ScannerState(
      status: status ?? this.status,
      capturedImagePath: capturedImagePath ?? this.capturedImagePath,
      errorMessage: errorMessage ?? this.errorMessage,
      isTorchOn: isTorchOn ?? this.isTorchOn,
    );
  }
}
