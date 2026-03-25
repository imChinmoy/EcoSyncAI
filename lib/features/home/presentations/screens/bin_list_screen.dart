import 'package:ecosyncai/core/themes/app_color.dart';
import 'package:ecosyncai/core/themes/app_text_styles.dart';
import 'package:ecosyncai/features/home/presentations/providers/bin_provider.dart';
import 'package:ecosyncai/features/home/presentations/widgets/bin_card.dart';
import 'package:ecosyncai/features/home/presentations/widgets/bin_detail_sheet.dart';
import 'package:ecosyncai/features/home/presentations/widgets/empty_state.dart';
import 'package:ecosyncai/features/home/presentations/widgets/filter_sheet.dart';
import 'package:ecosyncai/features/home/presentations/widgets/loading_shimmer.dart';
import 'package:ecosyncai/features/report/presentations/screens/report_issue_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BinListScreen extends StatelessWidget {
  const BinListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Waste Bins'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // ── Search + Filter bar ─────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Row(
              children: [
                Expanded(child: _SearchBar()),
                const SizedBox(width: 10),
                _FilterButton(),
              ],
            ),
          ),

          // ── Active filters row ──────────────────
          Consumer<BinProvider>(
            builder: (_, p, __) {
              final hasFilter = p.statusFilter != 'All' || p.categoryFilter != 'All';
              if (!hasFilter) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
                child: Row(
                  children: [
                    const Icon(Icons.filter_list, size: 14, color: AppColors.primary),
                    const SizedBox(width: 4),
                    Text('Filters active', style: AppTextStyles.caption.copyWith(color: AppColors.primary)),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => p.clearFilters(),
                      child: Text('Clear', style: AppTextStyles.caption.copyWith(
                        color: AppColors.accent, fontWeight: FontWeight.w600,
                      )),
                    ),
                  ],
                ),
              );
            },
          ),

          // ── Bin list ────────────────────────────
          Expanded(
            child: Consumer<BinProvider>(
              builder: (_, binProv, __) {
                if (binProv.state == BinState.loading || binProv.state == BinState.initial) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: LoadingShimmer(itemCount: 6),
                  );
                }
                if (binProv.state == BinState.empty) {
                  return const EmptyStateWidget(
                    title: 'No bins found',
                    subtitle: 'Try adjusting your search or filters.',
                  );
                }
                if (binProv.state == BinState.error) {
                  return EmptyStateWidget(
                    title: 'Error loading bins',
                    subtitle: binProv.errorMessage,
                    icon: Icons.error_outline,
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                  itemCount: binProv.bins.length,
                  itemBuilder: (context, i) {
                    final bin = binProv.bins[i];
                    return BinCard(
                      bin: bin,
                      onTap: () {
                        binProv.selectBin(bin);
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (_) => BinDetailSheet(
                            bin: bin,
                            onReportIssue: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const ReportIssueScreen()),
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ── Search Bar ──────────────────────────────────────────────────────────────
class _SearchBar extends StatelessWidget {
  final TextEditingController _ctrl = TextEditingController();

  _SearchBar();

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _ctrl,
      onChanged: (v) => context.read<BinProvider>().onSearch(v),
      style: AppTextStyles.body,
      decoration: InputDecoration(
        hintText: 'Search bins...',
        prefixIcon: const Icon(Icons.search, color: AppColors.textMuted, size: 20),
        suffixIcon: Consumer<BinProvider>(
          builder: (_, p, __) => p.searchQuery.isEmpty
              ? const SizedBox.shrink()
              : GestureDetector(
                  onTap: () {
                    _ctrl.clear();
                    context.read<BinProvider>().onSearch('');
                  },
                  child: const Icon(Icons.close, size: 18, color: AppColors.textMuted),
                ),
        ),
      ),
    );
  }
}

// ── Filter Button ────────────────────────────────────────────────────────────
class _FilterButton extends StatelessWidget {
  const _FilterButton();

  @override
  Widget build(BuildContext context) {
    return Consumer<BinProvider>(
      builder: (_, p, __) {
        final isActive = p.statusFilter != 'All' || p.categoryFilter != 'All';
        return GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => const FilterSheet(),
            );
          },
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: isActive ? AppColors.primary : AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isActive ? AppColors.primary : AppColors.divider,
              ),
            ),
            child: Icon(
              Icons.tune,
              color: isActive ? Colors.white : AppColors.textSecondary,
              size: 20,
            ),
          ),
        );
      },
    );
  }
}