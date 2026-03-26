import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecosyncai/core/utils/app_constants.dart';
import 'package:ecosyncai/dummy_data/models/complaint_model.dart';
import 'package:ecosyncai/dummy_data/services/bin_service.dart';

import 'report_event.dart';
import 'report_state.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  ReportBloc(this._service) : super(const ReportState()) {
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

  final BinService _service;

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
      final binId = state.selectedBin?.id ?? 'WARD_${state.selectedWardId}';

      final complaint = ComplaintModel(
        binId: binId,
        description: state.description,
        imagePath: state.capturedImagePath ?? 'mock_image_path',
        aiLabel: state.aiLabel,
        submittedAt: DateTime.now(),
      );

      final success = await _service.submitComplaint(complaint);
      emit(
        state.copyWith(
          status: success ? ReportStatus.success : ReportStatus.error,
          errorMessage: success ? '' : 'Submission failed. Try again.',
        ),
      );
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
