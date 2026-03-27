import 'dart:developer';

import 'package:ecosyncai/core/Exception/either.dart';
import 'package:ecosyncai/core/network/app_constants.dart';
import 'package:ecosyncai/core/network/network.dart';
import 'package:ecosyncai/features/driver/data/model/driver_location_model.dart';
import 'package:ecosyncai/features/driver/data/model/driver_route_model.dart';

abstract class DriverRemoteDataSource {
  Future<Either<String, DriverLocationModel>> updateDriverLocation({
    required String driverId,
    required int wardId,
    required double lat,
    required double lng,
  });

  Future<Either<String, DriverRouteModel>> getDriverRoute({
    required String driverId,
    required int ward,
    required double lat,
    required double lng,
  });
}

class DriverRemoteDataSourceImpl implements DriverRemoteDataSource {
  Future<Either<String, T>> _handleRequest<T>({
    required Future<dynamic> Function() request,
    required T Function(dynamic data) parser,
  }) async {
    try {
      final response = await request();
      final code = response.statusCode;
      if (code == 200 || code == 201 || code == 204) {
        if (code == 204 || response.data == null || response.data == '') {
          return Either.right(parser(null));
        }
        log('Driver API response: ${response.data}');
        return Either.right(parser(response.data));
      }
      return Either.left('Error: $code');
    } catch (e) {
      log('Driver API error: $e');
      return Either.left(e.toString());
    }
  }

  @override
  Future<Either<String, DriverLocationModel>> updateDriverLocation({
    required String driverId,
    required int wardId,
    required double lat,
    required double lng,
  }) {
    return _handleRequest(
      request: () => Network.post(ApiEndpoints.driverLocation, {
        'driverId': driverId,
        'wardId': wardId,
        'lat': lat,
        'lng': lng,
      }),
      parser: (data) => DriverLocationModel.fromJson(data),
    );
  }

  @override
  Future<Either<String, DriverRouteModel>> getDriverRoute({
    required String driverId,
    required int ward,
    required double lat,
    required double lng,
  }) {
    return _handleRequest(
      request: () => Network.get(
        ApiEndpoints.routeDriver,
        queryParameters: {
          'driverId': driverId,
          'ward': ward,
          'lat': lat,
          'lng': lng,
        },
      ),
      parser: (data) => DriverRouteModel.fromJson(data),
    );
  }
}
