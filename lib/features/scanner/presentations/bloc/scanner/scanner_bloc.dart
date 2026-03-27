import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecosyncai/features/scanner/domain/repository/scanner_repository.dart';
import 'scanner_event.dart';
import 'scanner_state.dart';

class ScannerBloc extends Bloc<ScannerEvent, ScannerState> {
  final ScannerRepository _repository;

  ScannerBloc(this._repository) : super(const ScannerState()) {
    on<ScannerImageCaptured>(_onScannerImageCaptured);
    on<ScannerError>(_onScannerError);
    on<ScannerReset>(_onScannerReset);
    on<TorchToggled>(_onTorchToggled);
  }

  void _onTorchToggled(TorchToggled event, Emitter<ScannerState> emit) {
    emit(state.copyWith(isTorchOn: !state.isTorchOn));
  }

  Future<void> _onScannerImageCaptured(
    ScannerImageCaptured event,
    Emitter<ScannerState> emit,
  ) async {
    emit(
      state.copyWith(
        status: ScannerStatus.loading,
        capturedImagePath: event.imagePath,
        clearError: true,
        clearResult: true,
      ),
    );

    final result = await _repository.classifyImage(event.imagePath);

    result.fold(
      (error) {
        emit(
          state.copyWith(
            status: ScannerStatus.error,
            errorMessage: error,
            clearResult: true,
          ),
        );
      },
      (data) {
        emit(state.copyWith(status: ScannerStatus.success, result: data));
      },
    );
  }

  void _onScannerError(ScannerError event, Emitter<ScannerState> emit) {
    emit(
      state.copyWith(status: ScannerStatus.error, errorMessage: event.message),
    );
  }

  void _onScannerReset(ScannerReset event, Emitter<ScannerState> emit) {
    emit(state.copyWith(status: ScannerStatus.initial, clearError: true, clearResult: true));
  }
}
