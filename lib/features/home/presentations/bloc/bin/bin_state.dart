import 'package:ecosyncai/features/home/domain/entities/bin_entity.dart';

enum BinStatus { initial, loading, loaded, empty, error }

class BinState {
  final BinStatus status;
  final List<BinEntity> allBins;
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

  int get totalBins => allBins.length;
  int get fullBins => allBins.where((bin) => bin.status == 'Full').length;
  int get fillingBins => allBins.where((bin) => bin.status == 'Filling').length;
  int get emptyBins => allBins.where((bin) => bin.status == 'Empty').length;
}
