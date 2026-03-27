import 'dart:ui';

import 'package:flutter/material.dart';

import 'app_color.dart';

class AppEffects {
  const AppEffects._();

  static BoxDecoration clay({
    double radius = 20,
    Color color = AppColors.cardBackground,
  }) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: AppColors.divider),
      boxShadow: const [
        BoxShadow(
          color: Color(0x99060A12),
          blurRadius: 20,
          offset: Offset(8, 8),
        ),
        BoxShadow(
          color: Color(0x33243042),
          blurRadius: 16,
          offset: Offset(-6, -6),
        ),
      ],
    );
  }
}

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double radius;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.radius = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radius),
              color: Colors.white.withValues(alpha: 0.05),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.14),
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x80050A12),
                  blurRadius: 16,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
