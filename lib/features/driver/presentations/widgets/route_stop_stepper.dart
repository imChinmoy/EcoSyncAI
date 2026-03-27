import 'package:ecosyncai/core/themes/app_color.dart';
import 'package:ecosyncai/core/themes/app_text_styles.dart';
import 'package:flutter/material.dart';

/// Horizontal stepper: completed (filled green), current (ring), upcoming (grey).
class RouteStopStepper extends StatelessWidget {
  const RouteStopStepper({
    super.key,
    required this.totalStops,
    required this.currentIndex,
    this.routeFinished = false,
  });

  final int totalStops;
  final int currentIndex;
  final bool routeFinished;

  @override
  Widget build(BuildContext context) {
    if (totalStops <= 0) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your route',
          style: AppTextStyles.caption.copyWith(
            letterSpacing: 0.8,
            color: AppColors.textMuted,
          ),
        ),
        const SizedBox(height: 14),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < totalStops; i++) ...[
                if (i > 0) _Connector(done: routeFinished || i <= currentIndex),
                _StepOrb(
                  index: i + 1,
                  state: routeFinished
                      ? _StepState.done
                      : (i < currentIndex
                          ? _StepState.done
                          : (i == currentIndex
                              ? _StepState.current
                              : _StepState.upcoming)),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

enum _StepState { done, current, upcoming }

class _Connector extends StatelessWidget {
  const _Connector({required this.done});

  final bool done;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Container(
        width: 20,
        height: 3,
        decoration: BoxDecoration(
          color: done ? AppColors.primary : AppColors.divider,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}

class _StepOrb extends StatelessWidget {
  const _StepOrb({required this.index, required this.state});

  final int index;
  final _StepState state;

  @override
  Widget build(BuildContext context) {
    final isDone = state == _StepState.done;
    final isCurrent = state == _StepState.current;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isDone ? AppColors.primary : Colors.transparent,
            border: Border.all(
              color: isCurrent
                  ? AppColors.primary
                  : (isDone ? AppColors.primary : AppColors.divider),
              width: isCurrent ? 3 : 2,
            ),
            boxShadow: isCurrent
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.35),
                      blurRadius: 8,
                      spreadRadius: 0,
                    ),
                  ]
                : null,
          ),
          alignment: Alignment.center,
          child: Text(
            '$index',
            style: AppTextStyles.caption.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: isDone ? Colors.white : AppColors.textSecondary,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Pickup $index',
          style: AppTextStyles.caption.copyWith(
            fontSize: 10,
            color: isCurrent ? AppColors.primary : AppColors.textMuted,
            fontWeight: isCurrent ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
