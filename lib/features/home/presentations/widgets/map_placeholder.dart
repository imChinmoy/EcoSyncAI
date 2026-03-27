import 'dart:async';
import 'dart:ui' as ui;

import 'package:ecosyncai/core/locale/app_localizations.dart';
import 'package:ecosyncai/core/maps/map_styles.dart';
import 'package:ecosyncai/core/themes/app_color.dart';
import 'package:ecosyncai/features/home/domain/entities/bin_entity.dart';
import 'package:ecosyncai/features/home/presentations/bloc/bin/bin_bloc.dart';
import 'package:ecosyncai/features/home/presentations/bloc/bin/bin_event.dart';
import 'package:ecosyncai/features/home/presentations/bloc/bin/bin_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPlaceholder extends StatefulWidget {
  final void Function(BinEntity) onMarkerTap;

  const MapPlaceholder({super.key, required this.onMarkerTap});

  @override
  State<MapPlaceholder> createState() => _MapPlaceholderState();
}

class _MapPlaceholderState extends State<MapPlaceholder> {
  static const LatLng _fallbackCenter = LatLng(28.6139, 77.2090);

  GoogleMapController? _mapController;
  StreamSubscription<Position>? _positionSub;
  Position? _currentPosition;
  bool _permissionDenied = false;
  BitmapDescriptor? _fullBinIcon;
  BitmapDescriptor? _fillingBinIcon;
  BitmapDescriptor? _emptyBinIcon;
  BitmapDescriptor? _nearbyBinIcon;

  @override
  void initState() {
    super.initState();
    _prepareMarkerIcons();
    _initLocation();
  }

  @override
  void dispose() {
    _positionSub?.cancel();
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _initLocation() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted) setState(() => _permissionDenied = true);
      return;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      if (mounted) setState(() => _permissionDenied = true);
      return;
    }

    final current = await Geolocator.getCurrentPosition();
    if (!mounted) return;
    setState(() {
      _currentPosition = current;
      _permissionDenied = false;
    });
    context.read<BinBloc>().add(
          UserLocationUpdated(
            latitude: current.latitude,
            longitude: current.longitude,
          ),
        );

    _positionSub = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 5,
      ),
    ).listen((pos) {
      if (!mounted) return;
      setState(() => _currentPosition = pos);
      context.read<BinBloc>().add(
            UserLocationUpdated(
              latitude: pos.latitude,
              longitude: pos.longitude,
            ),
          );
    });
  }

  Future<void> _prepareMarkerIcons() async {
    final full = await _createBinMarkerIcon(AppColors.statusFull);
    final filling = await _createBinMarkerIcon(AppColors.statusFilling);
    final empty = await _createBinMarkerIcon(AppColors.statusEmpty);
    final nearby = await _createBinMarkerIcon(AppColors.primary);
    if (!mounted) return;
    setState(() {
      _fullBinIcon = full;
      _fillingBinIcon = filling;
      _emptyBinIcon = empty;
      _nearbyBinIcon = nearby;
    });
  }

  Future<BitmapDescriptor> _createBinMarkerIcon(Color color) async {
    const size = 96.0;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final center = const Offset(size / 2, size / 2);

    final shadowPaint = Paint()..color = Colors.black.withValues(alpha: 0.25);
    canvas.drawCircle(center.translate(0, 4), 34, shadowPaint);

    final circlePaint = Paint()..color = color;
    canvas.drawCircle(center, 32, circlePaint);
    canvas.drawCircle(
      center,
      32,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.25)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );

    final iconPainter = TextPainter(textDirection: TextDirection.ltr);
    iconPainter.text = TextSpan(
      text: String.fromCharCode(Icons.delete_outline.codePoint),
      style: TextStyle(
        fontSize: 42,
        fontFamily: Icons.delete_outline.fontFamily,
        package: Icons.delete_outline.fontPackage,
        color: Colors.white,
      ),
    );
    iconPainter.layout();
    iconPainter.paint(
      canvas,
      Offset(
        (size - iconPainter.width) / 2,
        (size - iconPainter.height) / 2,
      ),
    );

    final image = await recorder.endRecording().toImage(size.toInt(), size.toInt());
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
  }

  Set<Marker> _buildBinMarkers(List<BinEntity> bins) {
    return bins
        .map(
          (bin) {
            final distanceKm = _distanceFromUserKm(bin);
            final nearby = distanceKm != null && distanceKm <= 1.0;
            final distanceLabel = distanceKm == null
                ? ''
                : ' • ${distanceKm.toStringAsFixed(2)} km';

            return Marker(
              markerId: MarkerId(bin.id),
              position: LatLng(bin.lat, bin.lng),
              infoWindow: InfoWindow(
                title: bin.id,
                snippet:
                    '${bin.status} • ${bin.category}${nearby ? ' • nearby' : ''}$distanceLabel',
                onTap: () => widget.onMarkerTap(bin),
              ),
              icon: _iconForStatus(bin.status, nearby: nearby),
              onTap: () => widget.onMarkerTap(bin),
            );
          },
        )
        .toSet();
  }

  double? _distanceFromUserKm(BinEntity bin) {
    if (_currentPosition == null) return null;
    final meters = Geolocator.distanceBetween(
      _currentPosition!.latitude,
      _currentPosition!.longitude,
      bin.lat,
      bin.lng,
    );
    return meters / 1000;
  }

  BitmapDescriptor _iconForStatus(String status, {required bool nearby}) {
    if (nearby && _nearbyBinIcon != null) return _nearbyBinIcon!;

    switch (status.toLowerCase()) {
      case 'full':
        return _fullBinIcon ??
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
      case 'filling':
        return _fillingBinIcon ??
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange);
      default:
        return _emptyBinIcon ??
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
    }
  }

  Future<void> _fitCameraToContent(List<BinEntity> bins) async {
    final controller = _mapController;
    if (controller == null) return;

    final points = <LatLng>[
      if (_currentPosition != null)
        LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
      ...bins.map((b) => LatLng(b.lat, b.lng)),
    ];
    if (points.isEmpty) return;

    if (points.length == 1) {
      await controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: points.first, zoom: 15),
        ),
      );
      return;
    }

    var minLat = points.first.latitude;
    var maxLat = points.first.latitude;
    var minLng = points.first.longitude;
    var maxLng = points.first.longitude;

    for (final point in points.skip(1)) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }

    final bounds = LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
    await controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 80));
  }

  Future<void> _goToCurrentLocation() async {
    final controller = _mapController;
    final pos = _currentPosition;
    if (controller == null || pos == null) return;

    await controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(pos.latitude, pos.longitude),
          zoom: 16,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BinBloc, BinState>(
      buildWhen: (previous, current) =>
          previous.filteredBins != current.filteredBins,
      builder: (context, binState) {
        final l10n = AppLocalizations.of(context);
        final bins = binState.filteredBins;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _fitCameraToContent(bins);
        });

        return Stack(
          children: [
            GoogleMap(
              myLocationEnabled: _currentPosition != null,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              compassEnabled: true,
              initialCameraPosition: CameraPosition(
                target: _currentPosition == null
                    ? _fallbackCenter
                    : LatLng(
                        _currentPosition!.latitude,
                        _currentPosition!.longitude,
                      ),
                zoom: 13,
              ),
              markers: _buildBinMarkers(bins),
              onMapCreated: (controller) {
                _mapController = controller;
                controller.setMapStyle(kDarkBlueMapStyle);
                _fitCameraToContent(bins);
              },
            ),
            Positioned(
              left: 12,
              bottom: 12,
              child: FilledButton.icon(
                onPressed: _goToCurrentLocation,
                icon: const Icon(Icons.my_location, size: 16),
                label: Text(l10n.myLocation),
              ),
            ),
            if (_permissionDenied)
              Positioned(
                left: 12,
                right: 12,
                top: 12,
                child: Material(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(10),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      l10n.locationPermissionDenied,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
