import 'package:ecosyncai/core/locale/app_localizations.dart';
import 'package:ecosyncai/core/themes/app_color.dart';
import 'package:ecosyncai/core/themes/app_effects.dart';
import 'package:ecosyncai/core/themes/app_text_styles.dart';
import 'package:ecosyncai/features/home/presentations/bloc/bin/bin_bloc.dart';
import 'package:ecosyncai/features/home/presentations/bloc/bin/bin_event.dart';
import 'package:ecosyncai/features/home/presentations/bloc/bin/bin_state.dart';
import 'package:ecosyncai/features/home/presentations/bloc/ward/ward_bloc.dart';
import 'package:ecosyncai/features/home/presentations/bloc/ward/ward_event.dart';
import 'package:ecosyncai/features/home/presentations/bloc/ward/ward_state.dart';
import 'package:ecosyncai/features/home/domain/entities/ward_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WardSelectionSheet extends StatefulWidget {
  const WardSelectionSheet({super.key});

  @override
  State<WardSelectionSheet> createState() => _WardSelectionSheetState();
}

class _WardSelectionSheetState extends State<WardSelectionSheet> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<BinBloc>().add(const FetchGlobalBinsForStatsRequested());
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WardBloc, WardState>(
      builder: (context, wardProv) {
        return BlocBuilder<BinBloc, BinState>(
          builder: (context, binProv) {
            final l10n = AppLocalizations.of(context);
            final mediaQuery = MediaQuery.of(context);
            return SafeArea(
              top: false,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: mediaQuery.size.height * 0.8,
                ),
                child: GlassCard(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                  radius: 24,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: AppColors.iconMuted,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(l10n.selectWard, style: AppTextStyles.heading2),
                      const SizedBox(height: 12),
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: wardProv.wards.length,
                          itemBuilder: (context, index) {
                            final ward = wardProv.wards[index];
                            return _WardTile(
                              ward: ward,
                              binCount: _wardBinCount(ward, wardProv, binProv),
                              fullCount: _wardFullCount(ward, wardProv, binProv),
                              isSelected: wardProv.pendingWard.id == ward.id,
                              onTap: () => context
                                  .read<WardBloc>()
                                  .add(PendingWardChanged(ward)),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          final wardId = wardProv.pendingWard.id;
                          context.read<WardBloc>().add(
                            const WardSelectionApplied(),
                          );
                          context.read<BinBloc>().add(
                            FetchBinsRequested(wardId: wardId),
                          );
                          Navigator.pop(context);
                        },
                        child: Text(l10n.applyArrow),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

/// Prefer aggregated counts from [BinState.allBinsGlobal] when loaded; otherwise API
/// fields on [WardEntity], and for "All Wards" sum per-ward API counts.
int _wardBinCount(
  WardEntity ward,
  WardState wardState,
  BinState binState,
) {
  final fromBins = binState.wardBinStats(ward.id);
  if (fromBins != null) return fromBins.binCount;
  if (ward.id == 0) {
    return wardState.wards
        .skip(1)
        .fold<int>(0, (sum, w) => sum + w.binCount);
  }
  return ward.binCount;
}

int _wardFullCount(
  WardEntity ward,
  WardState wardState,
  BinState binState,
) {
  final fromBins = binState.wardBinStats(ward.id);
  if (fromBins != null) return fromBins.fullCount;
  if (ward.id == 0) {
    return wardState.wards
        .skip(1)
        .fold<int>(0, (sum, w) => sum + w.fullCount);
  }
  return ward.fullCount;
}

class _WardTile extends StatelessWidget {
  final WardEntity ward;
  final int binCount;
  final int fullCount;
  final bool isSelected;
  final VoidCallback onTap;

  const _WardTile({
    required this.ward,
    required this.binCount,
    required this.fullCount,
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
                    '$binCount bins · $fullCount full',
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
