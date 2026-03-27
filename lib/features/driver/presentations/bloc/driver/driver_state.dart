import 'package:ecosyncai/features/driver/domain/entities/driver_task_entity.dart';

abstract class DriverState {
  const DriverState();
}

class DriverInitial extends DriverState {}

class DriverLoading extends DriverState {}

class DriverLoaded extends DriverState {
  final DriverTaskEntity taskDetail;
  const DriverLoaded(this.taskDetail);
}

class DriverError extends DriverState {
  final String message;
  const DriverError(this.message);
}
