import 'package:ecosyncai/dummy_data/models/bin_model.dart';
import 'package:ecosyncai/dummy_data/services/bin_service.dart';
import 'package:flutter/material.dart';

enum BinState { initial, loading, loaded, empty, error }

class BinProvider extends ChangeNotifier {
  final BinService _service;

  BinProvider(this._service);

  BinState _state = BinState.initial;
  List<BinModel> _bins = [];
  List<BinModel> _filteredBins = [];
  BinModel? _selectedBin;
  String _errorMessage = '';
  String _searchQuery = '';
  String _statusFilter = 'All';
  String _categoryFilter = 'All';
  int _selectedWardId = 0;

  BinState get state => _state;
  List<BinModel> get bins => _filteredBins;
  BinModel? get selectedBin => _selectedBin;
  String get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;
  String get statusFilter => _statusFilter;
  String get categoryFilter => _categoryFilter;

  Future<void> fetchBins({int wardId = 0}) async {
    _selectedWardId = wardId;
    _state = BinState.loading;
    notifyListeners();

    try {
      _bins = await _service.getBins(wardId: wardId);
      _applyFilters();
      _state = _filteredBins.isEmpty ? BinState.empty : BinState.loaded;
    } catch (e) {
      _state = BinState.error;
      _errorMessage = 'Failed to load bins. Please try again.';
    }

    notifyListeners();
  }

  void selectBin(BinModel bin) {
    _selectedBin = bin;
    notifyListeners();
  }

  void clearSelectedBin() {
    _selectedBin = null;
    notifyListeners();
  }

  void onSearch(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  void applyFilter({String? status, String? category}) {
    if (status != null) _statusFilter = status;
    if (category != null) _categoryFilter = category;
    _applyFilters();
    notifyListeners();
  }

  void clearFilters() {
    _statusFilter = 'All';
    _categoryFilter = 'All';
    _searchQuery = '';
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    _filteredBins = _bins.where((bin) {
      final matchesSearch = _searchQuery.isEmpty ||
          bin.id.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          bin.address.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          bin.category.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesStatus =
          _statusFilter == 'All' || bin.status == _statusFilter;

      final matchesCategory =
          _categoryFilter == 'All' || bin.category == _categoryFilter;

      return matchesSearch && matchesStatus && matchesCategory;
    }).toList();

    if (_filteredBins.isEmpty && _bins.isNotEmpty) {
      _state = BinState.empty;
    } else if (_bins.isNotEmpty) {
      _state = BinState.loaded;
    }
  }

  // Summary stats
  int get totalBins => _bins.length;
  int get fullBins => _bins.where((b) => b.status == 'Full').length;
  int get fillingBins => _bins.where((b) => b.status == 'Filling').length;
  int get emptyBins => _bins.where((b) => b.status == 'Empty').length;
}
