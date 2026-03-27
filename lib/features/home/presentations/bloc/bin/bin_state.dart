import 'package:ecosyncai/features/home/domain/entities/bin_entity.dart';

enum BinStatus { initial, loading, loaded, empty, error }

class BinState {
  final BinStatus status;
  final List<BinEntity> allBins;
  /// Last successful fetch for `wardId == 0` (all wards). Kept when a single-ward
  /// fetch replaces [allBins] so UI (e.g. ward sheet) can still show per-ward totals.
  final List<BinEntity> allBinsGlobal;
  final List<BinEntity> filteredBins;
  final BinEntity? selectedBin;
  final String errorMessage;
  final String searchQuery;
  final String statusFilter;
  final String categoryFilter;
  final int selectedWardId;
  final double? userLatitude;
  final double? userLongitude;
  final double radiusKm;

  const BinState({
    this.status = BinStatus.initial,
    this.allBins = const [],
    this.allBinsGlobal = const [],
    this.filteredBins = const [],
    this.selectedBin,
    this.errorMessage = '',
    this.searchQuery = '',
    this.statusFilter = 'All',
    this.categoryFilter = 'All',
    this.selectedWardId = 0,
    this.userLatitude,
    this.userLongitude,
    this.radiusKm = 100,
  });

  BinState copyWith({
    BinStatus? status,
    List<BinEntity>? allBins,
    List<BinEntity>? allBinsGlobal,
    List<BinEntity>? filteredBins,
    BinEntity? selectedBin,
    bool clearSelectedBin = false,
    String? errorMessage,
    String? searchQuery,
    String? statusFilter,
    String? categoryFilter,
    int? selectedWardId,
    double? userLatitude,
    double? userLongitude,
    double? radiusKm,
  }) {
    return BinState(
      status: status ?? this.status,
      allBins: allBins ?? this.allBins,
      allBinsGlobal: allBinsGlobal ?? this.allBinsGlobal,
      filteredBins: filteredBins ?? this.filteredBins,
      selectedBin: clearSelectedBin ? null : (selectedBin ?? this.selectedBin),
      errorMessage: errorMessage ?? this.errorMessage,
      searchQuery: searchQuery ?? this.searchQuery,
      statusFilter: statusFilter ?? this.statusFilter,
      categoryFilter: categoryFilter ?? this.categoryFilter,
      selectedWardId: selectedWardId ?? this.selectedWardId,
      userLatitude: userLatitude ?? this.userLatitude,
      userLongitude: userLongitude ?? this.userLongitude,
      radiusKm: radiusKm ?? this.radiusKm,
    );
  }

  /// Per-ward totals from [allBinsGlobal] when available (see [wardBinStats]).
  static bool _isFullStatus(BinEntity bin) =>
      bin.status.toLowerCase() == 'full';

  /// When [allBinsGlobal] is non-empty, returns bin and full counts for [wardId]
  /// (`0` = all wards). Otherwise returns null — use [WardEntity] counts.
  ({int binCount, int fullCount})? wardBinStats(int wardId) {
    if (allBinsGlobal.isEmpty) return null;
    if (wardId == 0) {
      return (
        binCount: allBinsGlobal.length,
        fullCount: allBinsGlobal.where(_isFullStatus).length,
      );
    }
    final inWard =
        allBinsGlobal.where((b) => b.wardId == wardId).toList(growable: false);
    return (
      binCount: inWard.length,
      fullCount: inWard.where(_isFullStatus).length,
    );
  }

  int get totalBins => allBins.length;
  int get fullBins => allBins.where((bin) => bin.status == 'Full').length;
  int get fillingBins => allBins.where((bin) => bin.status == 'Filling').length;
  int get emptyBins => allBins.where((bin) => bin.status == 'Empty').length;
}
