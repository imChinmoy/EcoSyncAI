import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecosyncai/core/utils/app_constants.dart';
import 'package:ecosyncai/features/report/data/datasource/report_remote_data.dart';

import 'report_event.dart';
import 'report_state.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  ReportBloc(this._remoteData) : super(const ReportState()) {
    on<ReportBinSet>(_onReportBinSet);
    on<ReportDescriptionChanged>(_onReportDescriptionChanged);
    on<ReportMockImagePicked>(_onReportMockImagePicked);
    on<ReportImageRemoved>(_onReportImageRemoved);
    on<ReportSubmitted>(_onReportSubmitted);
    on<ReportReset>(_onReportReset);
    on<ToggleReportTorchEvent>(_onToggleReportTorch);
    on<CaptureReportImageEvent>(_onCaptureReportImage);
    on<ReportWardSet>(_onReportWardSet);
  }

  final ReportRemoteData _remoteData;

  void _onReportWardSet(ReportWardSet event, Emitter<ReportState> emit) {
    emit(state.copyWith(selectedWardId: event.wardId));
  }

  void _onToggleReportTorch(
    ToggleReportTorchEvent event,
    Emitter<ReportState> emit,
  ) {
    emit(state.copyWith(isTorchOn: !state.isTorchOn));
  }

  void _onCaptureReportImage(
    CaptureReportImageEvent event,
    Emitter<ReportState> emit,
  ) {
    emit(
      state.copyWith(
        capturedImagePath: event.imagePath,
        hasImage: true,
        aiLabel: 'Detected Waste', // Placeholder for now
      ),
    );
  }

  void _onReportBinSet(ReportBinSet event, Emitter<ReportState> emit) {
    emit(
      state.copyWith(
        selectedBin: event.bin,
        selectedWardId: event.bin.wardId,
        status: ReportStatus.idle,
        description: '',
        hasImage: false,
        aiLabel: '',
        errorMessage: '',
      ),
    );
  }

  void _onReportDescriptionChanged(
    ReportDescriptionChanged event,
    Emitter<ReportState> emit,
  ) {
    emit(state.copyWith(description: event.description));
  }

  void _onReportMockImagePicked(
    ReportMockImagePicked event,
    Emitter<ReportState> emit,
  ) {
    final labels = AppConstants.aiLabels;
    final aiLabel =
        labels[DateTime.now().millisecondsSinceEpoch % labels.length];
    emit(state.copyWith(hasImage: true, aiLabel: aiLabel));
  }

  void _onReportImageRemoved(
    ReportImageRemoved event,
    Emitter<ReportState> emit,
  ) {
    emit(state.copyWith(hasImage: false, aiLabel: '', capturedImagePath: null));
  }

  Future<void> _onReportSubmitted(
    ReportSubmitted event,
    Emitter<ReportState> emit,
  ) async {
    if (state.description.trim().isEmpty || !state.hasImage) {
      return;
    }

    // Must have either a bin selected or a ward selected
    if (state.selectedBin == null && state.selectedWardId == null) {
      return;
    }

    emit(state.copyWith(status: ReportStatus.submitting, errorMessage: ''));

    try {
      final lat = state.selectedBin?.lat ?? 28.6139;
      final lng = state.selectedBin?.lng ?? 77.2090;

      final result = await _remoteData.submitComplaint(
        wardId: state.selectedWardId!,
        lat: lat,
        lng: lng,
        message: state.description.trim(),
        imageUrl: state.capturedImagePath ?? '',
      );

      result.fold((error) {
        emit(
          state.copyWith(
            status: ReportStatus.error,
            errorMessage: error.isEmpty ? 'Submission failed. Try again.' : error,
          ),
        );
      }, (_) {
        emit(state.copyWith(status: ReportStatus.success, errorMessage: ''));
      });
    } catch (_) {
      emit(
        state.copyWith(
          status: ReportStatus.error,
          errorMessage: 'An error occurred. Please try again.',
        ),
      );
    }
  }

  void _onReportReset(ReportReset event, Emitter<ReportState> emit) {
    emit(const ReportState());
  }
}
