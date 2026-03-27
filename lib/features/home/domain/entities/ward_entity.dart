class WardEntity {
  final int id;
  final String name;
  final int binCount;
  final int fullCount;

  const WardEntity({
    required this.id,
    required this.name,
    required this.binCount,
    required this.fullCount,
  });

  static const WardEntity all = WardEntity(
    id: 0,
    name: 'All Wards',
    binCount: 0,
    fullCount: 0,
  );
}

