import 'package:ecosyncai/core/maps/map_styles.dart';
import 'package:ecosyncai/core/themes/app_color.dart';
import 'package:ecosyncai/core/themes/app_text_styles.dart';
import 'package:ecosyncai/features/driver/domain/entities/driver_route_entity.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Read-only map: polyline and markers from [route] (loaded by parent via APIs).
class DriverRouteMapDisplay extends StatefulWidget {
  const DriverRouteMapDisplay({
    super.key,
    required this.route,
    required this.currentStopIndex,
    required this.userLat,
    required this.userLng,
    this.myLocationEnabled = false,
    this.onRefresh,
  });

  final DriverRouteEntity? route;
  final int currentStopIndex;
  final double userLat;
  final double userLng;
  final bool myLocationEnabled;
  final VoidCallback? onRefresh;

  @override
  State<DriverRouteMapDisplay> createState() => _DriverRouteMapDisplayState();
}

class _DriverRouteMapDisplayState extends State<DriverRouteMapDisplay> {
  GoogleMapController? _controller;

  @override
  void didUpdateWidget(covariant DriverRouteMapDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.route != widget.route ||
        oldWidget.currentStopIndex != widget.currentStopIndex ||
        oldWidget.userLat != widget.userLat ||
        oldWidget.userLng != widget.userLng) {
      final pts = _compute().pts;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _fitBounds(pts);
      });
    }
  }

  ({Set<Polyline> lines, Set<Marker> marks, List<LatLng> pts}) _compute() {
    final route = widget.route;
    if (route == null) {
      return (lines: {}, marks: {}, pts: []);
    }

    final pts = route.polylinePoints
        .map((p) => LatLng(p.latitude, p.longitude))
        .toList();

    final polylines = pts.length >= 2
        ? {
            Polyline(
              polylineId: const PolylineId('road_route'),
              points: pts,
              color: AppColors.primary,
              width: 5,
              jointType: JointType.round,
              startCap: Cap.roundCap,
              endCap: Cap.roundCap,
              geodesic: true,
            ),
          }
        : <Polyline>{};

    final w = route.waypoints;
    final n = w.length;
    final cur = n > 0
        ? widget.currentStopIndex.clamp(0, n - 1)
        : 0;
    final markers = <Marker>{
      for (var i = 0; i < n; i++)
        Marker(
          markerId: MarkerId('stop_${w[i].id ?? i}'),
          position: LatLng(w[i].latitude, w[i].longitude),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            i < cur
                ? BitmapDescriptor.hueGreen
                : (i == cur
                    ? BitmapDescriptor.hueYellow
                    : BitmapDescriptor.hueRed),
          ),
          infoWindow: InfoWindow(
            title: w[i].id != null ? 'Stop ${w[i].id}' : 'Stop ${i + 1}',
            snippet: i == cur ? 'Current' : (i < cur ? 'Done' : 'Upcoming'),
          ),
        ),
    };

    return (lines: polylines, marks: markers, pts: pts);
  }

  Future<void> _fitBounds(List<LatLng> polyPts) async {
    final c = _controller;
    final points = polyPts.isNotEmpty
        ? polyPts
        : (widget.route?.waypoints
                .map((w) => LatLng(w.latitude, w.longitude))
                .toList() ??
            []);
    if (c == null || points.isEmpty) return;
    if (points.length == 1) {
      await c.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: points.first, zoom: 15),
        ),
      );
      return;
    }
    double minLat = points.first.latitude;
    double maxLat = points.first.latitude;
    double minLng = points.first.longitude;
    double maxLng = points.first.longitude;
    for (final p in points.skip(1)) {
      if (p.latitude < minLat) minLat = p.latitude;
      if (p.latitude > maxLat) maxLat = p.latitude;
      if (p.longitude < minLng) minLng = p.longitude;
      if (p.longitude > maxLng) maxLng = p.longitude;
    }
    await c.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(minLat, minLng),
          northeast: LatLng(maxLat, maxLng),
        ),
        64,
      ),
    );
  }

  Future<void> _goToUser() async {
    final c = _controller;
    if (c == null) return;
    await c.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(widget.userLat, widget.userLng),
          zoom: 16,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final center = LatLng(widget.userLat, widget.userLng);
    final computed = _compute();

    return Stack(
      fit: StackFit.expand,
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(target: center, zoom: 13),
          myLocationEnabled: widget.myLocationEnabled,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          compassEnabled: true,
          mapType: MapType.normal,
          markers: computed.marks,
          polylines: computed.lines,
          onMapCreated: (controller) {
            _controller = controller;
            controller.setMapStyle(kDarkBlueMapStyle);
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) _fitBounds(computed.pts);
            });
          },
        ),
        Positioned(
          right: 12,
          bottom: 24,
          child: Material(
            color: AppColors.surface,
            shape: const CircleBorder(),
            elevation: 4,
            child: IconButton(
              tooltip: 'My location',
              onPressed: _goToUser,
              icon: const Icon(Icons.my_location, color: AppColors.primary),
            ),
          ),
        ),
        if (widget.onRefresh != null)
          Positioned(
            right: 12,
            top: 12,
            child: Material(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(24),
              elevation: 4,
              child: IconButton(
                tooltip: 'Sync route',
                onPressed: widget.onRefresh,
                icon: const Icon(Icons.refresh, color: AppColors.primary),
              ),
            ),
          ),
        if (widget.route == null || widget.route!.waypoints.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'No route data yet. Use Refresh after loading the task tab.',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodySecondary,
              ),
            ),
          ),
      ],
    );
  }
}
