enum BinType { organic, recyclable, hazardous, electronic, other }

class BinEntity {
  final String id;
  final String title;
  final String description;
  final BinType type;
  final String createdAt;
  final String updatedAt;

  BinEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
  });
}
