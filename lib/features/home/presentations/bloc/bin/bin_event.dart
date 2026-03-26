import 'package:ecosyncai/dummy_data/models/bin_model.dart';

abstract class BinEvent {
  const BinEvent();
}

class FetchBinsRequested extends BinEvent {
  final int wardId;

  const FetchBinsRequested({this.wardId = 0});
}

class BinSelected extends BinEvent {
  final BinModel bin;

  const BinSelected(this.bin);
}

class BinSelectionCleared extends BinEvent {
  const BinSelectionCleared();
}

class BinSearchChanged extends BinEvent {
  final String query;

  const BinSearchChanged(this.query);
}

class BinFilterApplied extends BinEvent {
  final String? status;
  final String? category;

  const BinFilterApplied({this.status, this.category});
}

class BinFiltersCleared extends BinEvent {
  const BinFiltersCleared();
}
