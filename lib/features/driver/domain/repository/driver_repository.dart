import '../entities/driver_task_entity.dart';

abstract class DriverRepository {
  Future<DriverTaskEntity> getDriverTaskDetail(String binId);
}
