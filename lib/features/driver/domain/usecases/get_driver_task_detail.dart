import '../entities/driver_task_entity.dart';
import '../repository/driver_repository.dart';

class GetDriverTaskDetail {
  final DriverRepository repository;

  GetDriverTaskDetail(this.repository);

  Future<DriverTaskEntity> call(String binId) async {
    return await repository.getDriverTaskDetail(binId);
  }
}
