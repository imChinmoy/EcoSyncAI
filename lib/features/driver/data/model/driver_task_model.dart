import '../../domain/entities/driver_task_entity.dart';

class DriverTaskModel extends DriverTaskEntity {
  const DriverTaskModel({
    required super.binId,
    required super.stopNumber,
    required super.totalStops,
    required super.routeActive,
    required super.wasteCategory,
    required super.ward,
    required super.zone,
    required super.fillLevel,
    required super.isFull,
    required super.lastPingedMinutesAgo,
    required super.lastUpdated,
    required super.issueFlags,
    required super.address,
    required super.area,
  });

  factory DriverTaskModel.fromJson(Map<String, dynamic> json) {
    return DriverTaskModel(
      binId: json['binId'],
      stopNumber: json['stopNumber'],
      totalStops: json['totalStops'],
      routeActive: json['routeActive'],
      wasteCategory: json['wasteCategory'],
      ward: json['ward'],
      zone: json['zone'],
      fillLevel: json['fillLevel'],
      isFull: json['isFull'],
      lastPingedMinutesAgo: json['lastPingedMinutesAgo'],
      lastUpdated: DateTime.parse(json['lastUpdated']),
      issueFlags: json['issueFlags'],
      address: json['address'],
      area: json['area'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'binId': binId,
      'stopNumber': stopNumber,
      'totalStops': totalStops,
      'routeActive': routeActive,
      'wasteCategory': wasteCategory,
      'ward': ward,
      'zone': zone,
      'fillLevel': fillLevel,
      'isFull': isFull,
      'lastPingedMinutesAgo': lastPingedMinutesAgo,
      'lastUpdated': lastUpdated.toIso8601String(),
      'issueFlags': issueFlags,
      'address': address,
      'area': area,
    };
  }
}
