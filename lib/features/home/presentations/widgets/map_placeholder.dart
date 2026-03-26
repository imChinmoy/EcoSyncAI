import 'package:ecosyncai/core/themes/app_color.dart';
import 'package:ecosyncai/dummy_data/models/bin_model.dart';
import 'package:ecosyncai/features/home/presentations/bloc/bin/bin_bloc.dart';
import 'package:ecosyncai/features/home/presentations/bloc/bin/bin_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bin_marker.dart';

/// Pixel positions for bin markers on the fake map (0.0–1.0 relative)
const _binPositions = [
  Offset(0.18, 0.22),
  Offset(0.42, 0.35),
  Offset(0.65, 0.18),
  Offset(0.72, 0.55),
  Offset(0.30, 0.60),
  Offset(0.55, 0.70),
  Offset(0.80, 0.75),
  Offset(0.10, 0.70),
  Offset(0.48, 0.82),
  Offset(0.20, 0.45),
  Offset(0.88, 0.35),
  Offset(0.62, 0.48),
];

class MapPlaceholder extends StatelessWidget {
  final void Function(BinModel) onMarkerTap;

  const MapPlaceholder({super.key, required this.onMarkerTap});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BinBloc, BinState>(
      builder: (context, binProv) {
        final bins = binProv.filteredBins;
        return ClipRRect(
          borderRadius: BorderRadius.circular(0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final w = constraints.maxWidth;
              final h = constraints.maxHeight;
              return Stack(
                children: [
                  // Map background
                  Container(
                    color: AppColors.mapBackground,
                    child: CustomPaint(
                      painter: _FakeMapPainter(),
                      size: Size(w, h),
                    ),
                  ),

                  // Bin markers
                  ...List.generate(bins.length, (i) {
                    final pos = _binPositions[i % _binPositions.length];
                    return Positioned(
                      left: pos.dx * w - 14,
                      top: pos.dy * h - 14,
                      child: BinMarker(
                        status: bins[i].status,
                        binId: bins[i].id,
                        onTap: () => onMarkerTap(bins[i]),
                      ),
                    );
                  }),
                ],
              );
            },
          ),
        );
      },
    );
  }
}

class _FakeMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final roadPaint = Paint()..color = AppColors.mapRoadColor;
    final blockPaint = Paint()..color = AppColors.mapBlockColor;
    final linePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.5)
      ..strokeWidth = 1.5;

    // Draw green blocks (parks/buildings)
    final blocks = [
      Rect.fromLTWH(size.width * 0.05, size.height * 0.05, size.width * 0.25, size.height * 0.22),
      Rect.fromLTWH(size.width * 0.40, size.height * 0.10, size.width * 0.20, size.height * 0.18),
      Rect.fromLTWH(size.width * 0.70, size.height * 0.05, size.width * 0.22, size.height * 0.25),
      Rect.fromLTWH(size.width * 0.05, size.height * 0.50, size.width * 0.18, size.height * 0.30),
      Rect.fromLTWH(size.width * 0.55, size.height * 0.55, size.width * 0.20, size.height * 0.20),
      Rect.fromLTWH(size.width * 0.28, size.height * 0.68, size.width * 0.22, size.height * 0.22),
      Rect.fromLTWH(size.width * 0.75, size.height * 0.65, size.width * 0.20, size.height * 0.22),
    ];

    for (final block in blocks) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(block, const Radius.circular(6)),
        blockPaint,
      );
    }

    // Horizontal roads
    for (int i = 1; i <= 3; i++) {
      final y = size.height * (i / 4.0);
      canvas.drawRect(Rect.fromLTWH(0, y - 8, size.width, 16), roadPaint);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);
    }

    // Vertical roads
    for (int i = 1; i <= 3; i++) {
      final x = size.width * (i / 4.0);
      canvas.drawRect(Rect.fromLTWH(x - 8, 0, 16, size.height), roadPaint);
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
