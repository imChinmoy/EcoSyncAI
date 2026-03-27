import 'package:ecosyncai/features/driver/domain/usecases/get_driver_task_detail.dart';
import 'package:ecosyncai/features/driver/presentations/bloc/driver/driver_event.dart';
import 'package:ecosyncai/features/driver/presentations/bloc/driver/driver_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DriverBloc extends Bloc<DriverEvent, DriverState> {
  final GetDriverTaskDetail getDriverTaskDetail;

  DriverBloc({required this.getDriverTaskDetail}) : super(DriverInitial()) {
    on<FetchDriverTaskDetail>(_onFetchDriverTaskDetail);
  }

  Future<void> _onFetchDriverTaskDetail(
    FetchDriverTaskDetail event,
    Emitter<DriverState> emit,
  ) async {
    emit(DriverLoading());
    try {
      final taskDetail = await getDriverTaskDetail(event.binId);
      emit(DriverLoaded(taskDetail));
    } catch (e) {
      emit(DriverError(e.toString()));
    }
  }
}
