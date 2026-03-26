enum ScannerStatus { initial, loading, success, error }

class ScannerState {
  final ScannerStatus status;
  final String? capturedImagePath;
  final String? errorMessage;

  const ScannerState({
    this.status = ScannerStatus.initial,
    this.capturedImagePath,
    this.errorMessage,
  });

  ScannerState copyWith({
    ScannerStatus? status,
    String? capturedImagePath,
    String? errorMessage,
  }) {
    return ScannerState(
      status: status ?? this.status,
      capturedImagePath: capturedImagePath ?? this.capturedImagePath,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
