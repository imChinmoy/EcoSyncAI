import '../../domain/entities/driver_current_stop_entity.dart';

class DriverLocationModel {
  const DriverLocationModel({
    required this.binId,
    required this.wasteCategory,
    required this.wardLabel,
    required this.zone,
    required this.fillLevel,
    required this.isFull,
    required this.lastPingedMinutesAgo,
    required this.lastUpdated,
    required this.issueFlags,
    required this.address,
    required this.area,
    required this.routeActive,
    this.stopNumber,
    this.totalStops,
  });

  final String binId;
  final String wasteCategory;
  final String wardLabel;
  final String zone;
  final int fillLevel;
  final bool isFull;
  final int lastPingedMinutesAgo;
  final DateTime? lastUpdated;
  final String issueFlags;
  final String address;
  final String area;
  final bool routeActive;
  final int? stopNumber;
  final int? totalStops;

  DriverCurrentStopEntity toEntity() => DriverCurrentStopEntity(
        binId: binId,
        wasteCategory: wasteCategory,
        wardLabel: wardLabel,
        zone: zone,
        fillLevel: fillLevel,
        isFull: isFull,
        lastPingedMinutesAgo: lastPingedMinutesAgo,
        lastUpdated: lastUpdated,
        issueFlags: issueFlags,
        address: address,
        area: area,
        routeActive: routeActive,
        stopNumber: stopNumber,
        totalStops: totalStops,
      );

  factory DriverLocationModel.fromJson(dynamic data) {
    if (data == null || data is! Map) {
      return DriverLocationModel._empty();
    }
    final m = Map<String, dynamic>.from(data);
    final updatedRaw = m['lastUpdated'] ?? m['last_updated'] ?? m['updatedAt'];
    DateTime? updated;
    if (updatedRaw is String) {
      updated = DateTime.tryParse(updatedRaw);
    } else if (updatedRaw is int) {
      updated = DateTime.fromMillisecondsSinceEpoch(updatedRaw);
    }

    return DriverLocationModel(
      binId: _s(m, ['binId', 'bin_id', 'id']) ?? '—',
      wasteCategory: _s(m, ['wasteCategory', 'waste_category', 'category']) ?? '—',
      wardLabel: _s(m, ['ward', 'wardLabel', 'ward_name']) ?? '—',
      zone: _s(m, ['zone', 'area_zone']) ?? '—',
      fillLevel: _i(m, ['fillLevel', 'fill_level', 'level']) ?? 0,
      isFull: _b(m, ['isFull', 'is_full', 'full']) ?? false,
      lastPingedMinutesAgo:
          _i(m, ['lastPingedMinutesAgo', 'last_pinged_minutes', 'minutes_since_ping']) ?? 0,
      lastUpdated: updated,
      issueFlags: _s(m, ['issueFlags', 'issue_flags', 'flags']) ?? 'None',
      address: _s(m, ['address', 'street', 'line1']) ?? '—',
      area: _s(m, ['area', 'locality', 'district']) ?? '—',
      routeActive: _b(m, ['routeActive', 'route_active']) ?? true,
      stopNumber: _i(m, ['stopNumber', 'stop_number', 'currentStop']),
      totalStops: _i(m, ['totalStops', 'total_stops', 'stopsTotal']),
    );
  }

  factory DriverLocationModel._empty() {
    return DriverLocationModel(
      binId: '—',
      wasteCategory: '—',
      wardLabel: '—',
      zone: '—',
      fillLevel: 0,
      isFull: false,
      lastPingedMinutesAgo: 0,
      lastUpdated: null,
      issueFlags: 'None',
      address: '—',
      area: '—',
      routeActive: true,
    );
  }

  static String? _s(Map<String, dynamic> m, List<String> keys) {
    for (final k in keys) {
      final v = m[k];
      if (v != null) return v.toString();
    }
    return null;
  }

  static int? _i(Map<String, dynamic> m, List<String> keys) {
    for (final k in keys) {
      final v = m[k];
      if (v is int) return v;
      if (v is num) return v.toInt();
    }
    return null;
  }

  static bool? _b(Map<String, dynamic> m, List<String> keys) {
    for (final k in keys) {
      final v = m[k];
      if (v is bool) return v;
    }
    return null;
  }
}
