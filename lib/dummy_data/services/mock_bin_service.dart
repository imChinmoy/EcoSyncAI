// import 'package:ecosyncai/dummy_data/data/bins_dummy.dart';
// import 'package:ecosyncai/dummy_data/models/bin_model.dart';
// import 'package:ecosyncai/dummy_data/models/complaint_model.dart';
// import 'bin_service.dart';

// /// Mock implementation of [BinService].
// /// Uses [dummyBins] as a data source with simulated async delay.
// /// Replace this class with a real HTTP/repository implementation later.
// class MockBinService implements BinService {
//   @override
//   Future<List<BinModel>> getBins({int wardId = 0}) async {
//     await Future.delayed(const Duration(milliseconds: 800)); // Simulated latency
//     if (wardId == 0) return List.from(dummyBins);
//     return dummyBins.where((bin) => bin.wardId == wardId).toList();
//   }

//   @override
//   Future<BinModel?> getBinById(String id) async {
//     await Future.delayed(const Duration(milliseconds: 300));
//     try {
//       return dummyBins.firstWhere((bin) => bin.id == id);
//     } catch (_) {
//       return null;
//     }
//   }

//   @override
//   Future<bool> submitComplaint(ComplaintModel complaint) async {
//     await Future.delayed(const Duration(milliseconds: 1000)); // Simulate API call
//     // Always returns success in mock
//     return true;
//   }
// }
