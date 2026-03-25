import 'package:ecosyncai/dummy_data/models/bin_model.dart';
import 'package:ecosyncai/dummy_data/models/complaint_model.dart';

/// Abstract interface for BinService.
/// Swap [MockBinService] for a real implementation to plug in the backend.
abstract class BinService {
  /// Fetch all bins (optionally filtered by wardId; 0 = all wards)
  Future<List<BinModel>> getBins({int wardId = 0});

  /// Fetch a single bin by ID
  Future<BinModel?> getBinById(String id);

  /// Submit a complaint for a bin
  Future<bool> submitComplaint(ComplaintModel complaint);
}
