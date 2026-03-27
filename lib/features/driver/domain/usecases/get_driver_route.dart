import 'package:ecosyncai/core/Exception/either.dart';

import '../entities/driver_route_entity.dart';
import '../repository/driver_repository.dart';

class GetDriverRoute {
  GetDriverRoute(this._repository);

  final DriverRepository _repository;

  Future<Either<String, DriverRouteEntity>> call({
    required String driverId,
    required int ward,
    required double lat,
    required double lng,
  }) {
    return _repository.getDriverRoute(
      driverId: driverId,
      ward: ward,
      lat: lat,
      lng: lng,
    );
  }
}
