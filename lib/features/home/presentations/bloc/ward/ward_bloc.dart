import 'package:flutter_bloc/flutter_bloc.dart';

import 'ward_event.dart';
import 'ward_state.dart';

class WardBloc extends Bloc<WardEvent, WardState> {
  WardBloc() : super(WardState.initial()) {
    on<PendingWardChanged>(_onPendingWardChanged);
    on<WardSelectionApplied>(_onWardSelectionApplied);
    on<WardPendingReset>(_onWardPendingReset);
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
