import '../../domain/entities/driver_task_entity.dart';
import '../../domain/repository/driver_repository.dart';
import '../datasource/driver_dummy_datasource.dart';

class DriverRepositoryImpl implements DriverRepository {
  final DriverDataSource dataSource;

  DriverRepositoryImpl(this.dataSource);

  @override
  Future<DriverTaskEntity> getDriverTaskDetail(String binId) async {
    return await dataSource.getTaskDetail(binId);
  }
}
