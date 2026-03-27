import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:ecosyncai/features/driver/domain/entities/driver_route_entity.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

/// Snaps ordered waypoints to drivable roads using the Google Directions API (REST).
///
/// **Keys:** The Maps SDK key is often **Android/iOS-restricted**. Those restrictions
/// usually **do not apply** to the Directions **web service**, which returns
/// `REQUEST_DENIED`. Set [GOOGLE_DIRECTIONS_API_KEY] to a key whose application
/// restriction is **None** (dev) or use a **backend proxy** with an IP-restricted key.
/// Enable **Directions API** + **billing** on the GCP project.
class GoogleDirectionsService {
  GoogleDirectionsService({Dio? dio}) : _dio = dio ?? Dio();

  final Dio _dio;

  static String _apiKey() {
    final directions = dotenv.env['GOOGLE_DIRECTIONS_API_KEY']?.trim() ?? '';
    if (directions.isNotEmpty) return directions;
    return dotenv.env['GOOGLE_MAPS_API_KEY']?.trim() ?? '';
  }

  /// Returns dense points along roads, or `null` if the API is unavailable or fails.
  Future<List<RouteLatLng>?> getRoadPolyline(List<RouteWaypoint> waypoints) async {
    if (waypoints.length < 2) return null;

    final key = _apiKey();
    if (key.isEmpty) {
      log(
        'GoogleDirectionsService: Set GOOGLE_DIRECTIONS_API_KEY or GOOGLE_MAPS_API_KEY in .env',
        name: 'GoogleDirectionsService',
      );
      return null;
    }

    final origin = '${waypoints.first.latitude},${waypoints.first.longitude}';
    final destination = '${waypoints.last.latitude},${waypoints.last.longitude}';

    final query = <String, dynamic>{
      'origin': origin,
      'destination': destination,
      'key': key,
      'mode': 'driving',
    };

    if (waypoints.length > 2) {
      final middle = waypoints.sublist(1, waypoints.length - 1);
      query['waypoints'] = middle.map((w) => '${w.latitude},${w.longitude}').join('|');
    }

    try {
      final res = await _dio.get<Map<String, dynamic>>(
        'https://maps.googleapis.com/maps/api/directions/json',
        queryParameters: query,
      );

      final data = res.data;
      if (data == null) return null;

      final status = data['status'] as String?;
      if (status != 'OK') {
        final err = data['error_message'] as String?;
        log(
          'GoogleDirectionsService: status=$status'
          '${err != null ? ' — $err' : ''}',
          name: 'GoogleDirectionsService',
        );
        if (status == 'REQUEST_DENIED') {
          log(
            'REQUEST_DENIED: Enable Directions API + billing in Google Cloud. '
            'If your Maps key is Android/iOS-restricted, create a separate key with '
            'Application restrictions = None (or call Directions from your server) and '
            'set GOOGLE_DIRECTIONS_API_KEY in .env.',
            name: 'GoogleDirectionsService',
          );
        }
        return null;
      }

      final routes = data['routes'] as List<dynamic>?;
      if (routes == null || routes.isEmpty) return null;

      final overview = routes.first as Map<String, dynamic>;
      final poly = overview['overview_polyline'] as Map<String, dynamic>?;
      final encoded = poly?['points'] as String?;
      if (encoded == null || encoded.isEmpty) return null;

      final decoded = PolylinePoints().decodePolyline(encoded);
      return decoded
          .map((p) => RouteLatLng(p.latitude, p.longitude))
          .toList();
    } catch (e, st) {
      log('GoogleDirectionsService error: $e', stackTrace: st);
      return null;
    }
  }
}
