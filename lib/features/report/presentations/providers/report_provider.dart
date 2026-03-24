import 'package:ecosyncai/core/utils/app_constants.dart';
import 'package:ecosyncai/dummy_data/models/bin_model.dart';
import 'package:ecosyncai/dummy_data/models/complaint_model.dart';
import 'package:ecosyncai/dummy_data/services/bin_service.dart';
import 'package:flutter/material.dart';

enum ReportState { idle, submitting, success, error }

class ReportProvider extends ChangeNotifier {
  final BinService _service;

  ReportProvider(this._service);

  ReportState _state = ReportState.idle;
  BinModel? _selectedBin;
  String _description = '';
  bool _hasImage = false; // Mock — no real image bytes
  String _aiLabel = '';
  String _errorMessage = '';

  ReportState get state => _state;
  BinModel? get selectedBin => _selectedBin;
  String get description => _description;
  bool get hasImage => _hasImage;
  String get aiLabel => _aiLabel;
  String get errorMessage => _errorMessage;

  void setBin(BinModel bin) {
    _selectedBin = bin;
    _state = ReportState.idle;
    _description = '';
    _hasImage = false;
    _aiLabel = '';
    notifyListeners();
  }

  void setDescription(String text) {
    _description = text;
    notifyListeners();
  }

  /// Simulates picking an image and AI-classifying it
  void pickMockImage() {
    _hasImage = true;
    final labels = AppConstants.aiLabels;
    _aiLabel = labels[DateTime.now().millisecondsSinceEpoch % labels.length];
    notifyListeners();
  }

  void removeImage() {
    _hasImage = false;
    _aiLabel = '';
    notifyListeners();
  }

  Future<void> submitComplaint() async {
    if (_selectedBin == null || _description.trim().isEmpty) return;

    _state = ReportState.submitting;
    notifyListeners();

    try {
      final complaint = ComplaintModel(
        binId: _selectedBin!.id,
        description: _description,
        imagePath: _hasImage ? 'mock_image_path' : null,
        aiLabel: _aiLabel,
        submittedAt: DateTime.now(),
      );

      final success = await _service.submitComplaint(complaint);
      _state = success ? ReportState.success : ReportState.error;
      if (!success) _errorMessage = 'Submission failed. Try again.';
    } catch (e) {
      _state = ReportState.error;
      _errorMessage = 'An error occurred. Please try again.';
    }

    notifyListeners();
  }

  void reset() {
    _state = ReportState.idle;
    _description = '';
    _hasImage = false;
    _aiLabel = '';
    _errorMessage = '';
    notifyListeners();
  }
}
