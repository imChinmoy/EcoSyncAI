import 'package:ecosyncai/core/themes/app_color.dart';
import 'package:ecosyncai/core/themes/app_text_styles.dart';
import 'package:flutter/material.dart';

class StatusBadge extends StatelessWidget {
  final String status;
  final bool small;

  const StatusBadge({super.key, required this.status, this.small = false});

  Color get _bgColor {
    switch (status.toLowerCase()) {
      case 'full':
        return AppColors.statusFullBg;
      case 'filling':
        return AppColors.statusFillingBg;
      default:
        return AppColors.statusEmptyBg;
    }
  }

  Color get _textColor {
    switch (status.toLowerCase()) {
      case 'full':
        return AppColors.statusFull;
      case 'filling':
        return AppColors.statusFilling;
      default:
        return AppColors.statusEmpty;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: small ? 8 : 10,
        vertical: small ? 3 : 4,
      ),
      decoration: BoxDecoration(
        color: _bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: AppTextStyles.badgeText.copyWith(
          color: _textColor,
          fontSize: small ? 10 : 11,
        ),
      ),
    );
  }
}
