import 'package:ecosyncai/core/themes/app_color.dart';
import 'package:ecosyncai/core/themes/app_text_styles.dart';
import 'package:ecosyncai/core/utils/app_constants.dart';
import 'package:ecosyncai/features/home/presentations/providers/bin_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FilterSheet extends StatefulWidget {
  const FilterSheet({super.key});

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  late String _selectedStatus;
  late String _selectedCategory;

  @override
  void initState() {
    super.initState();
    final provider = context.read<BinProvider>();
    _selectedStatus = provider.statusFilter;
    _selectedCategory = provider.categoryFilter;
  }

  @override
  Widget build(BuildContext context) {
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
          Text('Filter Bins', style: AppTextStyles.heading2),
          const SizedBox(height: 16),
          Text('Status', style: AppTextStyles.heading3),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: AppConstants.statuses.map((s) {
              final selected = _selectedStatus == s;
              return ChoiceChip(
                label: Text(s, style: AppTextStyles.badgeText.copyWith(
                  color: selected ? Colors.white : AppColors.textPrimary,
                )),
                selected: selected,
                onSelected: (_) => setState(() => _selectedStatus = s),
                selectedColor: AppColors.primary,
                backgroundColor: AppColors.surface,
                side: BorderSide(color: selected ? AppColors.primary : AppColors.divider),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          Text('Category', style: AppTextStyles.heading3),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: AppConstants.categories.map((c) {
              final selected = _selectedCategory == c;
              return ChoiceChip(
                label: Text(c, style: AppTextStyles.badgeText.copyWith(
                  color: selected ? Colors.white : AppColors.textPrimary,
                )),
                selected: selected,
                onSelected: (_) => setState(() => _selectedCategory = c),
                selectedColor: AppColors.primary,
                backgroundColor: AppColors.surface,
                side: BorderSide(color: selected ? AppColors.primary : AppColors.divider),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    context.read<BinProvider>().clearFilters();
                    Navigator.pop(context);
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text('Clear', style: AppTextStyles.button.copyWith(color: AppColors.primary)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: () {
                    context.read<BinProvider>().applyFilter(
                      status: _selectedStatus,
                      category: _selectedCategory,
                    );
                    Navigator.pop(context);
                  },
                  child: const Text('Apply Filters'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
