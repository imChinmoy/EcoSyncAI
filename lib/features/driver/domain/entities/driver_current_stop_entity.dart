/// Current stop context from `POST /driver/location` (parsed flexibly).
class DriverCurrentStopEntity {
  const DriverCurrentStopEntity({
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

  static DriverCurrentStopEntity empty() => DriverCurrentStopEntity(
        binId: '—',
        wasteCategory: '—',
        wardLabel: '—',
        zone: '—',
        fillLevel: 0,
        isFull: false,
        lastPingedMinutesAgo: 0,
        lastUpdated: null,
        issueFlags: '—',
        address: '—',
        area: '—',
        routeActive: true,
      );
}
