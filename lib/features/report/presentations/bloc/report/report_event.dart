import 'package:ecosyncai/features/home/domain/entities/bin_entity.dart';

abstract class ReportEvent {
  const ReportEvent();
}

class ReportBinSet extends ReportEvent {
  final BinEntity bin;

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

class ToggleReportTorchEvent extends ReportEvent {
  const ToggleReportTorchEvent();
}

class CaptureReportImageEvent extends ReportEvent {
  final String imagePath;
  const CaptureReportImageEvent(this.imagePath);
}

class ReportWardSet extends ReportEvent {
  final int wardId;
  const ReportWardSet(this.wardId);
}
