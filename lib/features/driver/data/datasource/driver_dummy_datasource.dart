import '../model/driver_task_model.dart';

abstract class DriverDataSource {
  Future<DriverTaskModel> getTaskDetail(String binId);
}

class DriverDummyDataSource implements DriverDataSource {
  @override
  Future<DriverTaskModel> getTaskDetail(String binId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));
    
    return DriverTaskModel(
      binId: binId,
      stopNumber: 5,
      totalStops: 12,
      routeActive: true,
      wasteCategory: "Recyclable Plastic",
      ward: "Ward 4",
      zone: "North Zone",
      fillLevel: 95,
      isFull: true,
      lastPingedMinutesAgo: 4,
      lastUpdated: DateTime.now(),
      issueFlags: "None",
      address: "4522 Civic Center Way",
      area: "North District, Sector 7",
    );
  }
}
