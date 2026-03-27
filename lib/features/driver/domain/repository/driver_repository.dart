import 'package:ecosyncai/core/Exception/either.dart';

import '../entities/driver_current_stop_entity.dart';
import '../entities/driver_route_entity.dart';
import '../entities/driver_task_entity.dart';

abstract class DriverRepository {
  Future<DriverTaskEntity> getDriverTaskDetail(String binId);

  Future<Either<String, DriverCurrentStopEntity>> updateDriverLocation({
    required String driverId,
    required int wardId,
    required double lat,
    required double lng,
  });

  Future<Either<String, DriverRouteEntity>> getDriverRoute({
    required String driverId,
    required int ward,
    required double lat,
    required double lng,
  });
}
