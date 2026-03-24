import 'package:ecosyncai/core/themes/app_color.dart';
import 'package:ecosyncai/core/themes/app_text_styles.dart';
import 'package:ecosyncai/dummy_data/models/ward_model.dart';
import 'package:ecosyncai/features/home/presentations/providers/bin_provider.dart';
import 'package:ecosyncai/features/home/presentations/providers/ward_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WardSelectionSheet extends StatelessWidget {
  const WardSelectionSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<WardProvider>(
      builder: (context, wardProv, _) {
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          decoration: const BoxDecoration(
            color: AppColors.sheetBackground,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
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
                    onTap: () => wardProv.setPendingWard(ward),
                  )),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  wardProv.applyWardSelection();
                  final wardId = wardProv.selectedWard.id;
                  context.read<BinProvider>().fetchBins(wardId: wardId);
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
  final WardModel ward;
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
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.1)
              : AppColors.surface,
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
