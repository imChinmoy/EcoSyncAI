import 'package:ecosyncai/features/home/domain/entities/ward_entity.dart';

enum WardStatus { initial, loading, loaded, error }

class WardState {
  final WardStatus status;
  final List<WardEntity> wards;
  final WardEntity selectedWard;
  final WardEntity pendingWard;
  final String errorMessage;

  const WardState({
    required this.status,
    required this.wards,
    required this.selectedWard,
    required this.pendingWard,
    required this.errorMessage,
  });

  factory WardState.initial() {
    return WardState(
      status: WardStatus.initial,
      wards: const [WardEntity.all],
      selectedWard: WardEntity.all,
      pendingWard: WardEntity.all,
      errorMessage: '',
    );
  }

  WardState copyWith({
    WardStatus? status,
    List<WardEntity>? wards,
    WardEntity? selectedWard,
    WardEntity? pendingWard,
    String? errorMessage,
  }) {
    return WardState(
      status: status ?? this.status,
      wards: wards ?? this.wards,
      selectedWard: selectedWard ?? this.selectedWard,
      pendingWard: pendingWard ?? this.pendingWard,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
