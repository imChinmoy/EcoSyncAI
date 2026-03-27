class DriverTaskEntity {
  final String binId;
  final int stopNumber;
  final int totalStops;
  final bool routeActive;
  final String wasteCategory;
  final String ward;
  final String zone;
  final int fillLevel;
  final bool isFull;
  final int lastPingedMinutesAgo;
  final DateTime lastUpdated;
  final String issueFlags;
  final String address;
  final String area;

  const DriverTaskEntity({
    required this.binId,
    required this.stopNumber,
    required this.totalStops,
    required this.routeActive,
    required this.wasteCategory,
    required this.ward,
    required this.zone,
    required this.fillLevel,
    required this.isFull,
    required this.lastPingedMinutesAgo,
    required this.lastUpdated,
    required this.issueFlags,
    required this.address,
    required this.area,
  });
}
