class WardModel {
  final int id;
  final String name;
  final int binCount;
  final int fullCount;

  const WardModel({
    required this.id,
    required this.name,
    required this.binCount,
    required this.fullCount,
  });
}

final List<WardModel> dummyWards = [
  const WardModel(id: 0, name: 'All Wards', binCount: 12, fullCount: 4),
  const WardModel(id: 1, name: 'Ward 1', binCount: 3, fullCount: 1),
  const WardModel(id: 2, name: 'Ward 2', binCount: 3, fullCount: 1),
  const WardModel(id: 3, name: 'Ward 3', binCount: 3, fullCount: 1),
  const WardModel(id: 4, name: 'Ward 4', binCount: 3, fullCount: 1),
];
