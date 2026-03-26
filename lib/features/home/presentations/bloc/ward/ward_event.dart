import 'package:ecosyncai/dummy_data/models/ward_model.dart';

abstract class WardEvent {
  const WardEvent();
}

class PendingWardChanged extends WardEvent {
  final WardModel ward;

  const PendingWardChanged(this.ward);
}

class WardSelectionApplied extends WardEvent {
  const WardSelectionApplied();
}

class WardPendingReset extends WardEvent {
  const WardPendingReset();
}
