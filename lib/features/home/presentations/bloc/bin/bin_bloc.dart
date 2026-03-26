import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecosyncai/dummy_data/models/bin_model.dart';
import 'package:ecosyncai/dummy_data/services/bin_service.dart';

import 'bin_event.dart';
import 'bin_state.dart';

class BinBloc extends Bloc<BinEvent, BinState> {
  BinBloc(this._service) : super(const BinState()) {
    on<FetchBinsRequested>(_onFetchBinsRequested);
    on<BinSelected>(_onBinSelected);
    on<BinSelectionCleared>(_onBinSelectionCleared);
    on<BinSearchChanged>(_onBinSearchChanged);
    on<BinFilterApplied>(_onBinFilterApplied);
    on<BinFiltersCleared>(_onBinFiltersCleared);
  }

  final BinService _service;

  Future<void> _onFetchBinsRequested(
    FetchBinsRequested event,
    Emitter<BinState> emit,
  ) async {
    emit(
      state.copyWith(
        status: BinStatus.loading,
        selectedWardId: event.wardId,
        errorMessage: '',
      ),
    );

    try {
      final bins = await _service.getBins(wardId: event.wardId);
      emit(_buildFilteredState(state.copyWith(allBins: bins, selectedWardId: event.wardId)));
    } catch (_) {
      emit(
        state.copyWith(
          status: BinStatus.error,
          errorMessage: 'Failed to load bins. Please try again.',
        ),
      );
    }
  }

  void _onBinSelected(BinSelected event, Emitter<BinState> emit) {
    emit(state.copyWith(selectedBin: event.bin));
  }

  void _onBinSelectionCleared(BinSelectionCleared event, Emitter<BinState> emit) {
    emit(state.copyWith(clearSelectedBin: true));
  }

  void _onBinSearchChanged(BinSearchChanged event, Emitter<BinState> emit) {
    emit(_buildFilteredState(state.copyWith(searchQuery: event.query)));
  }

  void _onBinFilterApplied(BinFilterApplied event, Emitter<BinState> emit) {
    emit(
      _buildFilteredState(
        state.copyWith(
          statusFilter: event.status ?? state.statusFilter,
          categoryFilter: event.category ?? state.categoryFilter,
        ),
      ),
    );
  }

  void _onBinFiltersCleared(BinFiltersCleared event, Emitter<BinState> emit) {
    emit(
      _buildFilteredState(
        state.copyWith(
          searchQuery: '',
          statusFilter: 'All',
          categoryFilter: 'All',
        ),
      ),
    );
  }

  BinState _buildFilteredState(BinState baseState) {
    final filteredBins = _applyFilters(
      bins: baseState.allBins,
      searchQuery: baseState.searchQuery,
      statusFilter: baseState.statusFilter,
      categoryFilter: baseState.categoryFilter,
    );

    final nextStatus =
        filteredBins.isEmpty ? BinStatus.empty : BinStatus.loaded;

    return baseState.copyWith(
      filteredBins: filteredBins,
      status: nextStatus,
      errorMessage: '',
    );
  }

  List<BinModel> _applyFilters({
    required List<BinModel> bins,
    required String searchQuery,
    required String statusFilter,
    required String categoryFilter,
  }) {
    return bins.where((bin) {
      final normalizedQuery = searchQuery.toLowerCase();
      final matchesSearch = normalizedQuery.isEmpty ||
          bin.id.toLowerCase().contains(normalizedQuery) ||
          bin.address.toLowerCase().contains(normalizedQuery) ||
          bin.category.toLowerCase().contains(normalizedQuery);

      final matchesStatus = statusFilter == 'All' || bin.status == statusFilter;
      final matchesCategory = categoryFilter == 'All' || bin.category == categoryFilter;

      return matchesSearch && matchesStatus && matchesCategory;
    }).toList();
  }
}
