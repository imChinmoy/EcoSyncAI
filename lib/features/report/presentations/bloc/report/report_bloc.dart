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
  }

  final BinService _service;

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

  void _onReportMockImagePicked(ReportMockImagePicked event, Emitter<ReportState> emit) {
    final labels = AppConstants.aiLabels;
    final aiLabel = labels[DateTime.now().millisecondsSinceEpoch % labels.length];
    emit(state.copyWith(hasImage: true, aiLabel: aiLabel));
  }

  void _onReportImageRemoved(ReportImageRemoved event, Emitter<ReportState> emit) {
    emit(state.copyWith(hasImage: false, aiLabel: ''));
  }

  Future<void> _onReportSubmitted(ReportSubmitted event, Emitter<ReportState> emit) async {
    if (state.selectedBin == null || state.description.trim().isEmpty) {
      return;
    }

    emit(state.copyWith(status: ReportStatus.submitting, errorMessage: ''));

    try {
      final complaint = ComplaintModel(
        binId: state.selectedBin!.id,
        description: state.description,
        imagePath: state.hasImage ? 'mock_image_path' : null,
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
    emit(
      state.copyWith(
        status: ReportStatus.idle,
        description: '',
        hasImage: false,
        aiLabel: '',
        errorMessage: '',
      ),
    );
  }
}
