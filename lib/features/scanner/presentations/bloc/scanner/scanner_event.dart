abstract class ScannerEvent {
  const ScannerEvent();
}

class ScannerImageCaptured extends ScannerEvent {
  final String imagePath;
  const ScannerImageCaptured(this.imagePath);
}

class ScannerError extends ScannerEvent {
  final String message;
  const ScannerError(this.message);
}

class ScannerReset extends ScannerEvent {
  const ScannerReset();
}

class TorchToggled extends ScannerEvent {
  const TorchToggled();
}
