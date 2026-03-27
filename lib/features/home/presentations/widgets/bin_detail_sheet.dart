import 'package:ecosyncai/core/locale/app_localizations.dart';
import 'package:ecosyncai/core/themes/app_color.dart';
import 'package:ecosyncai/core/themes/app_effects.dart';
import 'package:ecosyncai/core/themes/app_text_styles.dart';
import 'package:ecosyncai/features/home/domain/entities/bin_entity.dart';
import 'package:ecosyncai/features/home/presentations/bloc/bin/bin_bloc.dart';
import 'package:ecosyncai/features/home/presentations/bloc/bin/bin_event.dart';
import 'package:ecosyncai/features/report/presentations/bloc/report/report_bloc.dart';
import 'package:ecosyncai/features/report/presentations/bloc/report/report_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'status_badge.dart';

class BinDetailSheet extends StatelessWidget {
  final BinEntity bin;
  final VoidCallback onReportIssue;

  const BinDetailSheet({
    super.key,
    required this.bin,
    required this.onReportIssue,
  });

  String _formatTime(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return '${diff.inHours} hour${diff.inHours > 1 ? 's' : ''} ago';
    return '${diff.inDays} day${diff.inDays > 1 ? 's' : ''} ago';
  }

  Color get _capacityColor {
    switch (bin.status.toLowerCase()) {
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
    final l10n = AppLocalizations.of(context);
    return GlassCard(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      radius: 24,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40, height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: AppColors.iconMuted,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.delete_outline, color: AppColors.primary, size: 22),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(bin.id, style: AppTextStyles.heading2),
                  const SizedBox(height: 4),
                  StatusBadge(status: bin.status),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 12),

          // Details
          _DetailRow(icon: Icons.category_outlined, label: l10n.category, value: bin.category),
          _DetailRow(icon: Icons.location_on_outlined, label: l10n.addressLabel, value: bin.address),
          const SizedBox(height: 12),

          // Capacity
          Text(l10n.capacity, style: AppTextStyles.heading3),
          const SizedBox(height: 8),
          Row(children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: bin.capacity / 100.0,
                  minHeight: 10,
                  backgroundColor: AppColors.divider,
                  valueColor: AlwaysStoppedAnimation<Color>(_capacityColor),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text('${bin.capacity}%', style: AppTextStyles.heading3.copyWith(color: _capacityColor)),
          ]),
          const SizedBox(height: 4),
          Text('${bin.capacity}${l10n.percentFull}', style: AppTextStyles.bodySecondary),
          const SizedBox(height: 12),
          _DetailRow(icon: Icons.access_time, label: l10n.lastUpdatedLabel, value: _formatTime(bin.lastUpdated)),
          const SizedBox(height: 24),

          // Report button
          ElevatedButton.icon(
            onPressed: () {
              context.read<BinBloc>().add(BinSelected(bin));
              context.read<ReportBloc>().add(ReportBinSet(bin));
              Navigator.pop(context);
              onReportIssue();
            },
            icon: const Icon(Icons.report_outlined, size: 18),
            label: Text(l10n.reportIssue),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
              minimumSize: const Size.fromHeight(52),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(text: '$label: ', style: AppTextStyles.bodySecondary),
                  TextSpan(text: value, style: AppTextStyles.body),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
