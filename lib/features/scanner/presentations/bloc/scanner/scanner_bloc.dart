import 'package:flutter_bloc/flutter_bloc.dart';
import 'scanner_event.dart';
import 'scanner_state.dart';

class ScannerBloc extends Bloc<ScannerEvent, ScannerState> {
  ScannerBloc() : super(const ScannerState()) {
    on<ScannerImageCaptured>(_onScannerImageCaptured);
    on<ScannerError>(_onScannerError);
    on<ScannerReset>(_onScannerReset);
  }

  void _onScannerImageCaptured(
    ScannerImageCaptured event,
    Emitter<ScannerState> emit,
  ) {
    emit(state.copyWith(
      status: ScannerStatus.success,
      capturedImagePath: event.imagePath,
    ));
  }

  void _onScannerError(
    ScannerError event,
    Emitter<ScannerState> emit,
  ) {
    emit(state.copyWith(
      status: ScannerStatus.error,
      errorMessage: event.message,
    ));
  }

  void _onScannerReset(
    ScannerReset event,
    Emitter<ScannerState> emit,
  ) {
    emit(const ScannerState());
  }
}
