import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecosyncai/features/home/domain/entities/bin_entity.dart';
import 'package:ecosyncai/features/home/domain/repository/bin_repository.dart';
import 'package:geolocator/geolocator.dart';

import 'bin_event.dart';
import 'bin_state.dart';

class BinBloc extends Bloc<BinEvent, BinState> {
  final BinRepository _repository;

  BinBloc(this._repository) : super(const BinState()) {
    on<FetchBinsRequested>(_onFetchBinsRequested);
    on<FetchGlobalBinsForStatsRequested>(_onFetchGlobalBinsForStatsRequested);
    on<BinSelected>(_onBinSelected);
    on<BinSelectionCleared>(_onBinSelectionCleared);
    on<BinSearchChanged>(_onBinSearchChanged);
    on<BinFilterApplied>(_onBinFilterApplied);
    on<BinFiltersCleared>(_onBinFiltersCleared);
    on<UserLocationUpdated>(_onUserLocationUpdated);
  }

  // ─────────────────────────────────────────────
  // FETCH FROM API
  // ─────────────────────────────────────────────
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

    final result = await _repository.getBins(wardId: event.wardId);

    result.fold(
      (error) {
        emit(
          state.copyWith(
            status: BinStatus.error,
            errorMessage: error,
          ),
        );
      },
      (bins) {
        emit(
          _buildFilteredState(
            state.copyWith(
              allBins: bins,
              selectedWardId: event.wardId,
              allBinsGlobal: event.wardId == 0 ? bins : state.allBinsGlobal,
            ),
          ),
        );
      },
    );
  }

  Future<void> _onFetchGlobalBinsForStatsRequested(
    FetchGlobalBinsForStatsRequested event,
    Emitter<BinState> emit,
  ) async {
    if (state.allBinsGlobal.isNotEmpty) return;

    final result = await _repository.getBins(wardId: 0);
    result.fold(
      (_) {},
      (bins) => emit(state.copyWith(allBinsGlobal: bins)),
    );
  }

  // ─────────────────────────────────────────────
  void _onBinSelected(BinSelected event, Emitter<BinState> emit) {
    emit(state.copyWith(selectedBin: event.bin));
  }

  void _onBinSelectionCleared(
    BinSelectionCleared event,
    Emitter<BinState> emit,
  ) {
    emit(state.copyWith(clearSelectedBin: true));
  }

  void _onBinSearchChanged(
    BinSearchChanged event,
    Emitter<BinState> emit,
  ) {
    emit(_buildFilteredState(state.copyWith(searchQuery: event.query)));
  }

  void _onBinFilterApplied(
    BinFilterApplied event,
    Emitter<BinState> emit,
  ) {
    emit(
      _buildFilteredState(
        state.copyWith(
          statusFilter: event.status ?? state.statusFilter,
          categoryFilter: event.category ?? state.categoryFilter,
        ),
      ),
    );
  }

  void _onBinFiltersCleared(
    BinFiltersCleared event,
    Emitter<BinState> emit,
  ) {
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

  void _onUserLocationUpdated(
    UserLocationUpdated event,
    Emitter<BinState> emit,
  ) {
    emit(
      _buildFilteredState(
        state.copyWith(
          userLatitude: event.latitude,
          userLongitude: event.longitude,
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // FILTER LOGIC (UNCHANGED, BUT NOW ENTITY-BASED)
  // ─────────────────────────────────────────────
  BinState _buildFilteredState(BinState baseState) {
    final filteredBins = _applyFilters(
      bins: baseState.allBins,
      searchQuery: baseState.searchQuery,
      statusFilter: baseState.statusFilter,
      categoryFilter: baseState.categoryFilter,
      userLatitude: baseState.userLatitude,
      userLongitude: baseState.userLongitude,
      radiusKm: baseState.radiusKm,
    );

    final nextStatus =
        filteredBins.isEmpty ? BinStatus.empty : BinStatus.loaded;

    return baseState.copyWith(
      filteredBins: filteredBins,
      status: nextStatus,
      errorMessage: '',
    );
  }

  List<BinEntity> _applyFilters({
    required List<BinEntity> bins,
    required String searchQuery,
    required String statusFilter,
    required String categoryFilter,
    required double? userLatitude,
    required double? userLongitude,
    required double radiusKm,
  }) {
    return bins.where((bin) {
      final query = searchQuery.toLowerCase();

      final matchesSearch = query.isEmpty ||
          bin.id.toLowerCase().contains(query) ||
          bin.address.toLowerCase().contains(query) ||
          bin.category.toLowerCase().contains(query);

      final matchesStatus =
          statusFilter == 'All' || bin.status == statusFilter;

      final matchesCategory =
          categoryFilter == 'All' || bin.category == categoryFilter;

      final matchesRadius = userLatitude == null || userLongitude == null
          ? true
          : (Geolocator.distanceBetween(
                    userLatitude,
                    userLongitude,
                    bin.lat,
                    bin.lng,
                  ) /
                  1000) <=
              radiusKm;

      return matchesSearch && matchesStatus && matchesCategory && matchesRadius;
    }).toList();
  }
}