import 'package:ecosyncai/features/home/domain/entities/ward_entity.dart';

abstract class WardEvent {
  const WardEvent();
}

class FetchWardsRequested extends WardEvent {
  const FetchWardsRequested();
}

class PendingWardChanged extends WardEvent {
  final WardEntity ward;

  const PendingWardChanged(this.ward);
}

class WardSelectionApplied extends WardEvent {
  const WardSelectionApplied();
}

class WardPendingReset extends WardEvent {
  const WardPendingReset();
}
