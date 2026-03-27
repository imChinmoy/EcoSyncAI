class BinEntity {
  final String id;
  final int wardId;
  final double lat;
  final double lng;
  final String status;
  final String category;
  final int capacity;
  final String address;
  final DateTime lastUpdated;

  const BinEntity({
    required this.id,
    required this.wardId,
    required this.lat,
    required this.lng,
    required this.status,
    required this.category,
    required this.capacity,
    required this.address,
    required this.lastUpdated,
  });
}