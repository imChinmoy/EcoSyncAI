import 'package:ecosyncai/core/themes/app_color.dart';
import 'package:ecosyncai/core/themes/app_text_styles.dart';
import 'package:ecosyncai/dummy_data/models/bin_model.dart';
import 'package:flutter/material.dart';
import 'status_badge.dart';

class BinCard extends StatelessWidget {
  final BinModel bin;
  final VoidCallback onTap;

  const BinCard({super.key, required this.bin, required this.onTap});

  String _formatTime(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return '${diff.inHours} hour${diff.inHours > 1 ? 's' : ''} ago';
    return '${diff.inDays} day${diff.inDays > 1 ? 's' : ''} ago';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.divider),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top row: Bin ID + badge
                    Row(
                      children: [
                        Text(bin.id, style: AppTextStyles.heading3),
                        const SizedBox(width: 8),
                        StatusBadge(status: bin.status),
                      ],
                    ),
                    const SizedBox(height: 6),
                    // Category
                    Text(bin.category, style: AppTextStyles.body),
                    const SizedBox(height: 4),
                    // Address
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined,
                            size: 13, color: AppColors.textSecondary),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            bin.address,
                            style: AppTextStyles.bodySecondary,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    // Last updated
                    Row(
                      children: [
                        const Icon(Icons.access_time,
                            size: 12, color: AppColors.textMuted),
                        const SizedBox(width: 3),
                        Text(
                          _formatTime(bin.lastUpdated),
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right,
                  color: AppColors.iconMuted, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
