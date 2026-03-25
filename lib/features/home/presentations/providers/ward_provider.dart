import 'package:ecosyncai/dummy_data/models/ward_model.dart';
import 'package:flutter/material.dart';

class WardProvider extends ChangeNotifier {
  List<WardModel> _wards = dummyWards;
  WardModel _selectedWard = dummyWards.first; // 'All Wards' by default
  WardModel _pendingWard = dummyWards.first;

  List<WardModel> get wards => _wards;
  WardModel get selectedWard => _selectedWard;
  WardModel get pendingWard => _pendingWard;

  void setPendingWard(WardModel ward) {
    _pendingWard = ward;
    notifyListeners();
  }

  /// Called when user taps Apply in the Ward Selection Sheet
  void applyWardSelection() {
    _selectedWard = _pendingWard;
    notifyListeners();
  }

  void resetPending() {
    _pendingWard = _selectedWard;
    notifyListeners();
  }
}
