import 'package:ecosyncai/core/themes/app_color.dart';
import 'package:ecosyncai/core/themes/app_effects.dart';
import 'package:ecosyncai/core/themes/app_text_styles.dart';
import 'package:ecosyncai/features/home/presentations/bloc/bin/bin_bloc.dart';
import 'package:ecosyncai/features/home/presentations/bloc/bin/bin_event.dart';
import 'package:ecosyncai/features/home/presentations/bloc/ward/ward_bloc.dart';
import 'package:ecosyncai/features/home/presentations/bloc/ward/ward_event.dart';
import 'package:ecosyncai/features/home/presentations/bloc/ward/ward_state.dart';
import 'package:ecosyncai/features/home/domain/entities/ward_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WardSelectionSheet extends StatelessWidget {
  const WardSelectionSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WardBloc, WardState>(
      builder: (context, wardProv) {
        return GlassCard(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          radius: 24,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40, height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.iconMuted,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text('Select Ward', style: AppTextStyles.heading2),
              const SizedBox(height: 12),
              ...wardProv.wards.map((ward) => _WardTile(
                    ward: ward,
                    isSelected: wardProv.pendingWard.id == ward.id,
                    onTap: () =>
                        context.read<WardBloc>().add(PendingWardChanged(ward)),
                  )),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  final wardId = wardProv.pendingWard.id;
                  context.read<WardBloc>().add(const WardSelectionApplied());
                  context
                      .read<BinBloc>()
                      .add(FetchBinsRequested(wardId: wardId));
                  Navigator.pop(context);
                },
                child: const Text('Apply →'),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _WardTile extends StatelessWidget {
  final WardEntity ward;
  final bool isSelected;
  final VoidCallback onTap;

  const _WardTile({
    required this.ward,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: AppEffects.clay(
          radius: 12,
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.12)
              : AppColors.cardBackground,
        ).copyWith(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.divider,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(ward.name, style: AppTextStyles.heading3),
                  Text(
                    '${ward.binCount} bins · ${ward.fullCount} full',
                    style: AppTextStyles.bodySecondary,
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: AppColors.primary, size: 20),
          ],
        ),
      ),
    );
  }
}
