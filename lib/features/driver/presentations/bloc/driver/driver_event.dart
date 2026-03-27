abstract class DriverEvent {
  const DriverEvent();
}

class FetchDriverTaskDetail extends DriverEvent {
  final String binId;
  const FetchDriverTaskDetail(this.binId);
}
