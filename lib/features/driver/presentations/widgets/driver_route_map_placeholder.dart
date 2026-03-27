import 'package:ecosyncai/core/themes/app_color.dart';
import 'package:ecosyncai/core/themes/app_text_styles.dart';
import 'package:ecosyncai/features/driver/domain/entities/driver_task_entity.dart';
import 'package:flutter/material.dart';

class DriverRouteMapPlaceholder extends StatelessWidget {
  const DriverRouteMapPlaceholder({super.key, required this.task});

  final DriverTaskEntity task;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.mapBackground,
        borderRadius: BorderRadius.circular(32),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(painter: _DriverMapPainter()),
            ),
            Positioned(
              top: 42,
              left: 48,
              child: _MapNode(
                label: 'Prev',
                color: AppColors.textMuted,
              ),
            ),
            Positioned(
              top: 80,
              right: 76,
              child: _MapNode(
                label: 'Next',
                color: AppColors.primaryDark,
              ),
            ),
            const Positioned(
              top: 76,
              left: 150,
              child: _CurrentStopPin(),
            ),
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      task.address,
                      style: AppTextStyles.heading3.copyWith(fontSize: 12),
                    ),
                    Text(
                      task.area,
                      style: AppTextStyles.bodySecondary.copyWith(fontSize: 10),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MapNode extends StatelessWidget {
  const _MapNode({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(height: 4),
        Text(label, style: AppTextStyles.caption.copyWith(fontSize: 9)),
      ],
    );
  }
}

class _CurrentStopPin extends StatelessWidget {
  const _CurrentStopPin();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: AppColors.accent,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.surface, width: 3),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withOpacity(0.3),
            blurRadius: 12,
          ),
        ],
      ),
      child: const Icon(Icons.delete_outline, color: Colors.white, size: 14),
    );
  }
}

class _DriverMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final roadPaint = Paint()..color = AppColors.mapRoadColor;
    final blockPaint = Paint()..color = AppColors.mapBlockColor;
    final routePaint = Paint()
      ..color = AppColors.primaryDark
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final blocks = [
      Rect.fromLTWH(size.width * 0.06, size.height * 0.08, 74, 32),
      Rect.fromLTWH(size.width * 0.64, size.height * 0.08, 68, 34),
      Rect.fromLTWH(size.width * 0.12, size.height * 0.54, 92, 38),
      Rect.fromLTWH(size.width * 0.66, size.height * 0.50, 74, 40),
    ];

    for (final block in blocks) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(block, const Radius.circular(8)),
        blockPaint,
      );
    }

    canvas.drawRect(
      Rect.fromLTWH(0, size.height * 0.28, size.width, 16),
      roadPaint,
    );
    canvas.drawRect(
      Rect.fromLTWH(0, size.height * 0.68, size.width, 16),
      roadPaint,
    );
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.26, 0, 18, size.height),
      roadPaint,
    );
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.72, 0, 18, size.height),
      roadPaint,
    );

    final path = Path()
      ..moveTo(size.width * 0.16, size.height * 0.25)
      ..lineTo(size.width * 0.30, size.height * 0.25)
      ..lineTo(size.width * 0.30, size.height * 0.48)
      ..lineTo(size.width * 0.52, size.height * 0.48)
      ..lineTo(size.width * 0.70, size.height * 0.48)
      ..lineTo(size.width * 0.70, size.height * 0.30)
      ..lineTo(size.width * 0.82, size.height * 0.30);

    canvas.drawPath(path, routePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
