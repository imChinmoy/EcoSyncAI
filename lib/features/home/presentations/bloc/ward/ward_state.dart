import 'package:ecosyncai/dummy_data/models/ward_model.dart';

class WardState {
  final List<WardModel> wards;
  final WardModel selectedWard;
  final WardModel pendingWard;

  const WardState({
    required this.wards,
    required this.selectedWard,
    required this.pendingWard,
  });

  factory WardState.initial() {
    return WardState(
      wards: dummyWards,
      selectedWard: dummyWards.first,
      pendingWard: dummyWards.first,
    );
  }

  WardState copyWith({
    List<WardModel>? wards,
    WardModel? selectedWard,
    WardModel? pendingWard,
  }) {
    return WardState(
      wards: wards ?? this.wards,
      selectedWard: selectedWard ?? this.selectedWard,
      pendingWard: pendingWard ?? this.pendingWard,
    );
  }
}
