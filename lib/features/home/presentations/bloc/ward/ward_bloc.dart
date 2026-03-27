import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecosyncai/features/home/domain/repository/ward_repository.dart';
import 'package:ecosyncai/features/home/domain/entities/ward_entity.dart';

import 'ward_event.dart';
import 'ward_state.dart';

class WardBloc extends Bloc<WardEvent, WardState> {
  final WardRepository _repository;

  WardBloc(this._repository) : super(WardState.initial()) {
    on<FetchWardsRequested>(_onFetchWardsRequested);
    on<PendingWardChanged>(_onPendingWardChanged);
    on<WardSelectionApplied>(_onWardSelectionApplied);
    on<WardPendingReset>(_onWardPendingReset);
  }

  Future<void> _onFetchWardsRequested(
    FetchWardsRequested event,
    Emitter<WardState> emit,
  ) async {
    emit(state.copyWith(status: WardStatus.loading, errorMessage: ''));

    final result = await _repository.getWards();
    result.fold(
      (err) => emit(state.copyWith(status: WardStatus.error, errorMessage: err)),
      (wards) {
        final next = <WardEntity>[WardEntity.all, ...wards];
        emit(
          state.copyWith(
            status: WardStatus.loaded,
            wards: next,
            errorMessage: '',
          ),
        );
      },
    );
  }

  void _onPendingWardChanged(PendingWardChanged event, Emitter<WardState> emit) {
    emit(state.copyWith(pendingWard: event.ward));
  }

  void _onWardSelectionApplied(WardSelectionApplied event, Emitter<WardState> emit) {
    emit(state.copyWith(selectedWard: state.pendingWard));
  }

  void _onWardPendingReset(WardPendingReset event, Emitter<WardState> emit) {
    emit(state.copyWith(pendingWard: state.selectedWard));
  }
}
