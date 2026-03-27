import 'package:ecosyncai/features/driver/domain/entities/driver_current_stop_entity.dart';
import 'package:ecosyncai/features/driver/domain/entities/driver_route_entity.dart';
import 'package:ecosyncai/features/driver/domain/repository/driver_repository.dart';
import 'package:ecosyncai/features/home/domain/entities/ward_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

enum DriverSessionStatus { initial, loading, ready, error }

class DriverRouteSessionState {
  const DriverRouteSessionState({
    required this.status,
    required this.driverId,
    required this.wardId,
    required this.selectableWards,
    this.lat,
    this.lng,
    this.stopDetails,
    this.route,
    required this.currentStopIndex,
    required this.routeFinished,
    this.errorMessage,
    this.locationPermissionDenied = false,
  });

  final DriverSessionStatus status;
  final String driverId;
  final int wardId;
  final List<WardEntity> selectableWards;
  final double? lat;
  final double? lng;
  final DriverCurrentStopEntity? stopDetails;
  final DriverRouteEntity? route;
  final int currentStopIndex;
  final bool routeFinished;
  final String? errorMessage;
  final bool locationPermissionDenied;

  int get totalStops => route?.waypoints.length ?? 0;

  DriverRouteSessionState copyWith({
    DriverSessionStatus? status,
    String? driverId,
    int? wardId,
    List<WardEntity>? selectableWards,
    double? lat,
    double? lng,
    DriverCurrentStopEntity? stopDetails,
    DriverRouteEntity? route,
    int? currentStopIndex,
    bool? routeFinished,
    String? errorMessage,
    bool? locationPermissionDenied,
    bool clearStopDetails = false,
    bool clearRoute = false,
    bool clearError = false,
  }) {
    return DriverRouteSessionState(
      status: status ?? this.status,
      driverId: driverId ?? this.driverId,
      wardId: wardId ?? this.wardId,
      selectableWards: selectableWards ?? this.selectableWards,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      stopDetails: clearStopDetails ? null : (stopDetails ?? this.stopDetails),
      route: clearRoute ? null : (route ?? this.route),
      currentStopIndex: currentStopIndex ?? this.currentStopIndex,
      routeFinished: routeFinished ?? this.routeFinished,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      locationPermissionDenied:
          locationPermissionDenied ?? this.locationPermissionDenied,
    );
  }

  static List<WardEntity> defaultWardPicker() {
    return List.generate(
      12,
      (i) => WardEntity(
        id: i + 1,
        name: 'Ward ${i + 1}',
        binCount: 0,
        fullCount: 0,
      ),
    );
  }
}

class DriverRouteSessionCubit extends Cubit<DriverRouteSessionState> {
  DriverRouteSessionCubit({
    required DriverRepository repository,
    required String driverId,
    required int initialWardId,
    List<WardEntity>? selectableWards,
  })  : _repository = repository,
        super(
          DriverRouteSessionState(
            status: DriverSessionStatus.initial,
            driverId: driverId,
            wardId: initialWardId,
            selectableWards: (selectableWards != null &&
                    selectableWards.where((w) => w.id != 0).isNotEmpty)
                ? selectableWards.where((w) => w.id != 0).toList()
                : DriverRouteSessionState.defaultWardPicker(),
            currentStopIndex: 0,
            routeFinished: false,
          ),
        );

  final DriverRepository _repository;

  static const double _fallbackLat = 28.6139;
  static const double _fallbackLng = 77.2090;

  Future<void> initialize() => syncRoute();

  Future<void> changeWard(int wardId) async {
    emit(
      state.copyWith(
        wardId: wardId,
        currentStopIndex: 0,
        routeFinished: false,
        clearError: true,
      ),
    );
    await syncRoute();
  }

  Future<void> markCollected() async {
    final n = state.totalStops;
    if (n == 0 || state.routeFinished) return;

    if (state.currentStopIndex >= n - 1) {
      emit(state.copyWith(routeFinished: true, status: DriverSessionStatus.ready));
      return;
    }

    emit(state.copyWith(
      currentStopIndex: state.currentStopIndex + 1,
      clearError: true,
    ));
    await syncRoute();
  }

  /// Reloads GPS, `POST /driver/location`, `GET /route/driver` (and road polyline in repo).
  Future<void> syncRoute() async {
    emit(state.copyWith(
      status: DriverSessionStatus.loading,
      clearError: true,
    ));

    double lat = state.lat ?? _fallbackLat;
    double lng = state.lng ?? _fallbackLng;
    var permissionDenied = false;

    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (serviceEnabled) {
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission != LocationPermission.denied &&
          permission != LocationPermission.deniedForever) {
        try {
          final pos = await Geolocator.getCurrentPosition();
          lat = pos.latitude;
          lng = pos.longitude;
        } catch (_) {}
      } else {
        permissionDenied = true;
      }
    } else {
      permissionDenied = true;
    }

    DriverCurrentStopEntity? stop;
    String? locErr;

    final locResult = await _repository.updateDriverLocation(
      driverId: state.driverId,
      wardId: state.wardId,
      lat: lat,
      lng: lng,
    );
    locResult.fold(
      (e) => locErr = e,
      (s) => stop = s,
    );

    DriverRouteEntity? routeEntity;
    String? routeErr;

    final routeResult = await _repository.getDriverRoute(
      driverId: state.driverId,
      ward: state.wardId,
      lat: lat,
      lng: lng,
    );
    routeResult.fold(
      (e) => routeErr = e,
      (r) => routeEntity = r,
    );

    final err = <String>[
      if (locErr != null && locErr!.isNotEmpty) locErr!,
      if (routeErr != null && routeErr!.isNotEmpty) routeErr!,
    ].join(' · ');
    if (routeEntity == null && err.isNotEmpty) {
      emit(state.copyWith(
        status: DriverSessionStatus.error,
        errorMessage: err,
        lat: lat,
        lng: lng,
        stopDetails: stop,
        locationPermissionDenied: permissionDenied,
      ));
      return;
    }

    var idx = state.currentStopIndex;
    final waypoints = routeEntity?.waypoints.length ?? 0;
    if (waypoints > 0 && idx >= waypoints) {
      idx = waypoints - 1;
    }

    emit(state.copyWith(
      status: DriverSessionStatus.ready,
      lat: lat,
      lng: lng,
      stopDetails: stop,
      route: routeEntity,
      currentStopIndex: idx,
      errorMessage: err.isNotEmpty ? err : null,
      locationPermissionDenied: permissionDenied,
    ));
  }
}
