class RouteLatLng {
  const RouteLatLng(this.latitude, this.longitude);

  final double latitude;
  final double longitude;
}

/// Stop from `GET /route/driver` (bins along the route).
class RouteWaypoint {
  const RouteWaypoint({
    this.id,
    required this.latitude,
    required this.longitude,
    this.wardId,
    this.status,
    this.category,
    this.lastUpdated,
  });

  final int? id;
  final double latitude;
  final double longitude;

  /// Ward this bin belongs to (when API sends it).
  final int? wardId;

  /// e.g. `Full`, `Empty`
  final String? status;

  /// e.g. `mixed`, `recyclable`
  final String? category;

  final DateTime? lastUpdated;
}

class DriverRouteEntity {
  const DriverRouteEntity({
    required this.waypoints,
    required this.polylinePoints,
    this.raw,
  });

  /// Ordered stops (markers).
  final List<RouteWaypoint> waypoints;

  /// Points to draw — typically road-snapped via Directions API.
  final List<RouteLatLng> polylinePoints;

  final Map<String, dynamic>? raw;
}
