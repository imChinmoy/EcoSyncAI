import 'package:ecosyncai/dummy_data/models/bin_model.dart';

abstract class ReportEvent {
  const ReportEvent();
}

class ReportBinSet extends ReportEvent {
  final BinModel bin;

  const ReportBinSet(this.bin);
}

class ReportDescriptionChanged extends ReportEvent {
  final String description;

  const ReportDescriptionChanged(this.description);
}

class ReportMockImagePicked extends ReportEvent {
  const ReportMockImagePicked();
}

class ReportImageRemoved extends ReportEvent {
  const ReportImageRemoved();
}

class ReportSubmitted extends ReportEvent {
  const ReportSubmitted();
}

class ReportReset extends ReportEvent {
  const ReportReset();
}
