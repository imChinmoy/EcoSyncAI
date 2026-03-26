import 'package:ecosyncai/dummy_data/models/bin_model.dart';

enum BinStatus { initial, loading, loaded, empty, error }

class BinState {
  final BinStatus status;
  final List<BinModel> allBins;
  final List<BinModel> filteredBins;
  final BinModel? selectedBin;
  final String errorMessage;
  final String searchQuery;
  final String statusFilter;
  final String categoryFilter;
  final int selectedWardId;

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
  });

  BinState copyWith({
    BinStatus? status,
    List<BinModel>? allBins,
    List<BinModel>? filteredBins,
    BinModel? selectedBin,
    bool clearSelectedBin = false,
    String? errorMessage,
    String? searchQuery,
    String? statusFilter,
    String? categoryFilter,
    int? selectedWardId,
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
    );
  }

  int get totalBins => allBins.length;
  int get fullBins => allBins.where((bin) => bin.status == 'Full').length;
  int get fillingBins => allBins.where((bin) => bin.status == 'Filling').length;
  int get emptyBins => allBins.where((bin) => bin.status == 'Empty').length;
}
