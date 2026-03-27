import 'package:ecosyncai/features/home/domain/entities/bin_entity.dart';

abstract class BinEvent {
  const BinEvent();
}

class FetchBinsRequested extends BinEvent {
  final int wardId;

  const FetchBinsRequested({this.wardId = 0});
}

/// Loads all bins for ward stats only; does not replace [BinState.allBins] or filters.
class FetchGlobalBinsForStatsRequested extends BinEvent {
  const FetchGlobalBinsForStatsRequested();
}

class BinSelected extends BinEvent {
  final BinEntity bin;

  const BinSelected(this.bin);
}

class BinSelectionCleared extends BinEvent {
  const BinSelectionCleared();
}

class BinSearchChanged extends BinEvent {
  final String query;

  const BinSearchChanged(this.query);
}

class BinFilterApplied extends BinEvent {
  final String? status;
  final String? category;

  const BinFilterApplied({this.status, this.category});
}

class BinFiltersCleared extends BinEvent {
  const BinFiltersCleared();
}

class UserLocationUpdated extends BinEvent {
  final double latitude;
  final double longitude;

  const UserLocationUpdated({
    required this.latitude,
    required this.longitude,
  });
}
