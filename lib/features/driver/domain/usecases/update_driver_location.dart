import 'package:ecosyncai/core/Exception/either.dart';

import '../entities/driver_current_stop_entity.dart';
import '../repository/driver_repository.dart';

class UpdateDriverLocation {
  UpdateDriverLocation(this._repository);

  final DriverRepository _repository;

  Future<Either<String, DriverCurrentStopEntity>> call({
    required String driverId,
    required int wardId,
    required double lat,
    required double lng,
  }) {
    return _repository.updateDriverLocation(
      driverId: driverId,
      wardId: wardId,
      lat: lat,
      lng: lng,
    );
  }
}
