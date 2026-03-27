import 'package:ecosyncai/core/Exception/either.dart';

import '../../domain/entities/driver_current_stop_entity.dart';
import '../../domain/entities/driver_route_entity.dart';
import '../../domain/entities/driver_task_entity.dart';
import '../../domain/repository/driver_repository.dart';
import '../datasource/driver_dummy_datasource.dart';
import '../datasource/driver_remote_datasource.dart';
import '../directions/google_directions_service.dart';

class DriverRepositoryImpl implements DriverRepository {
  DriverRepositoryImpl(
    this._taskDataSource,
    this._remote,
    this._directions,
  );

  final DriverDataSource _taskDataSource;
  final DriverRemoteDataSource _remote;
  final GoogleDirectionsService _directions;

  @override
  Future<DriverTaskEntity> getDriverTaskDetail(String binId) async {
    return await _taskDataSource.getTaskDetail(binId);
  }

  @override
  Future<Either<String, DriverCurrentStopEntity>> updateDriverLocation({
    required String driverId,
    required int wardId,
    required double lat,
    required double lng,
  }) async {
    final result = await _remote.updateDriverLocation(
      driverId: driverId,
      wardId: wardId,
      lat: lat,
      lng: lng,
    );
    return result.fold(
      (e) => Either.left(e),
      (m) => Either.right(m.toEntity()),
    );
  }

  @override
  Future<Either<String, DriverRouteEntity>> getDriverRoute({
    required String driverId,
    required int ward,
    required double lat,
    required double lng,
  }) async {
    final result = await _remote.getDriverRoute(
      driverId: driverId,
      ward: ward,
      lat: lat,
      lng: lng,
    );
    if (result.isLeft) return Either.left(result.leftValue);
    final m = result.rightValue;
    if (m.waypoints.length < 2) {
      return Either.right(m.toEntity(m.straightPolyline()));
    }
    final road = await _directions.getRoadPolyline(m.waypoints);
    final polyline = road ?? m.straightPolyline();
    return Either.right(m.toEntity(polyline));
  }
}
