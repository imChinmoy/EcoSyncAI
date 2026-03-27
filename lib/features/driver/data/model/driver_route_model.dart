import '../../domain/entities/driver_route_entity.dart';

class DriverRouteModel {
  const DriverRouteModel({
    required this.waypoints,
    this.raw,
  });

  final List<RouteWaypoint> waypoints;
  final Map<String, dynamic>? raw;

  DriverRouteEntity toEntity(List<RouteLatLng> polylinePoints) => DriverRouteEntity(
        waypoints: waypoints,
        polylinePoints: polylinePoints,
        raw: raw,
      );

  /// Straight line through stops (fallback when Directions is unavailable).
  List<RouteLatLng> straightPolyline() {
    return waypoints
        .map((w) => RouteLatLng(w.latitude, w.longitude))
        .toList();
  }

  factory DriverRouteModel.fromJson(dynamic data) {
    if (data == null) {
      return const DriverRouteModel(waypoints: []);
    }
    if (data is List) {
      return DriverRouteModel(
        waypoints: _parseWaypointList(data),
        raw: null,
      );
    }
    if (data is Map<String, dynamic>) {
      return DriverRouteModel(
        waypoints: _parseWaypointsFromMap(data),
        raw: data,
      );
    }
    return const DriverRouteModel(waypoints: []);
  }

  static List<RouteWaypoint> _parseWaypointList(List<dynamic> list) {
    final out = <RouteWaypoint>[];
    for (final item in list) {
      final p = _parseWaypoint(item);
      if (p != null) out.add(p);
    }
    return out;
  }

  static List<RouteWaypoint> _parseWaypointsFromMap(Map<String, dynamic> json) {
    final nested = json['data'];
    if (nested is Map<String, dynamic>) {
      final inner = _parseWaypointsFromMap(nested);
      if (inner.isNotEmpty) return inner;
    }
    if (nested is List) {
      final parsed = _parseWaypointList(nested);
      if (parsed.isNotEmpty) return parsed;
    }
    for (final key in [
      'polyline',
      'path',
      'coordinates',
      'points',
      'route',
      'geometry',
      'stops',
    ]) {
      final v = json[key];
      if (v is List) {
        final parsed = _parseWaypointList(v);
        if (parsed.isNotEmpty) return parsed;
      }
    }
    final data = json['data'];
    if (data is Map<String, dynamic>) {
      return _parseWaypointsFromMap(data);
    }
    if (data is List) {
      return _parseWaypointList(data);
    }
    return [];
  }

  static RouteWaypoint? _parseWaypoint(dynamic item) {
    if (item is Map) {
      final lat = item['lat'] ?? item['latitude'];
      final lng = item['lng'] ?? item['longitude'];
      if (lat is num && lng is num) {
        final id = item['id'];
        int? idVal;
        if (id is int) {
          idVal = id;
        } else if (id is num) {
          idVal = id.toInt();
        }
        final wid = item['wardId'] ?? item['ward_id'];
        int? wardVal;
        if (wid is int) {
          wardVal = wid;
        } else if (wid is num) {
          wardVal = wid.toInt();
        }

        final status = item['status']?.toString();
        final category = item['category']?.toString();

        DateTime? updated;
        final lu = item['lastUpdated'] ?? item['last_updated'];
        if (lu is String) {
          updated = DateTime.tryParse(lu);
        }

        return RouteWaypoint(
          id: idVal,
          latitude: lat.toDouble(),
          longitude: lng.toDouble(),
          wardId: wardVal,
          status: status,
          category: category,
          lastUpdated: updated,
        );
      }
    } else if (item is List && item.length >= 2) {
      final a = item[0];
      final b = item[1];
      if (a is num && b is num) {
        return RouteWaypoint(
          id: null,
          latitude: a.toDouble(),
          longitude: b.toDouble(),
        );
      }
    }
    return null;
  }
}
