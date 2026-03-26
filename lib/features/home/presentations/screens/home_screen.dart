import 'package:ecosyncai/core/themes/app_color.dart';
import 'package:ecosyncai/core/themes/app_text_styles.dart';
import 'package:ecosyncai/dummy_data/models/bin_model.dart';
import 'package:ecosyncai/features/home/presentations/bloc/bin/bin_bloc.dart';
import 'package:ecosyncai/features/home/presentations/bloc/bin/bin_event.dart';
import 'package:ecosyncai/features/home/presentations/bloc/bin/bin_state.dart';
import 'package:ecosyncai/features/home/presentations/bloc/ward/ward_bloc.dart';
import 'package:ecosyncai/features/home/presentations/bloc/ward/ward_event.dart';
import 'package:ecosyncai/features/home/presentations/bloc/ward/ward_state.dart';
import 'package:ecosyncai/features/home/presentations/widgets/bin_card.dart';
import 'package:ecosyncai/features/home/presentations/widgets/bin_detail_sheet.dart';
import 'package:ecosyncai/features/home/presentations/widgets/empty_state.dart';
import 'package:ecosyncai/features/home/presentations/widgets/loading_shimmer.dart';
import 'package:ecosyncai/features/home/presentations/widgets/map_placeholder.dart';
import 'package:ecosyncai/features/home/presentations/widgets/ward_selection_sheet.dart';
import 'package:ecosyncai/features/report/presentations/screens/report_issue_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DraggableScrollableController _sheetController =
      DraggableScrollableController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BinBloc>().add(const FetchBinsRequested());
    });
  }

  @override
  void dispose() {
    _sheetController.dispose();
    super.dispose();
  }

  void _openWardSheet() {
    context.read<WardBloc>().add(const WardPendingReset());
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const WardSelectionSheet(),
    );
  }

  void _showBinDetail(BinModel bin) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BinDetailSheet(
        bin: bin,
        onReportIssue: _navigateToReport,
      ),
    );
  }

  void _navigateToReport() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ReportIssueScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // ── Map section ──────────────────────────────────────
          Positioned.fill(
            bottom: MediaQuery.of(context).size.height * 0.18,
            child: Column(
              children: [
                _TopBar(onWardTap: _openWardSheet),
                Expanded(
                  child: MapPlaceholder(onMarkerTap: _showBinDetail),
                ),
              ],
            ),
          ),

          // ── Draggable bottom sheet ────────────────────────────
          DraggableScrollableSheet(
            controller: _sheetController,
            initialChildSize: 0.22,
            minChildSize: 0.18,
            maxChildSize: 0.90,
            snap: true,
            snapSizes: const [0.22, 0.55, 0.90],
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: AppColors.sheetBackground,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(24)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 16,
                      offset: Offset(0, -4),
                    )
                  ],
                ),
                child: Column(
                  children: [
                    // Drag handle + sheet header
                    _SheetHeader(scrollController: scrollController),

                    // Content
                    Expanded(
                      child: BlocBuilder<BinBloc, BinState>(
                        builder: (_, binState) {
                          if (binState.status == BinStatus.loading ||
                              binState.status == BinStatus.initial) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: LoadingShimmer(itemCount: 4),
                            );
                          }
                          if (binState.status == BinStatus.empty) {
                            return const EmptyStateWidget(
                              title: 'No bins in this ward',
                              subtitle: 'All clear — no bins to show.',
                              icon: Icons.check_circle_outline,
                            );
                          }
                          if (binState.status == BinStatus.error) {
                            return EmptyStateWidget(
                              title: 'Something went wrong',
                              subtitle: binState.errorMessage,
                              icon: Icons.error_outline,
                            );
                          }
                          return _BinSheetList(
                            scrollController: scrollController,
                            onBinTap: _showBinDetail,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ── Top Bar ─────────────────────────────────────────────────────────────────
class _TopBar extends StatelessWidget {
  final VoidCallback onWardTap;
  const _TopBar({required this.onWardTap});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            // Ward dropdown button
            Expanded(
              child: BlocBuilder<WardBloc, WardState>(
                builder: (_, wardState) => GestureDetector(
                  onTap: onWardTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.divider),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.location_city,
                            color: AppColors.primary, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            wardState.selectedWard.name,
                            style: AppTextStyles.dropdownLabel,
                          ),
                        ),
                        const Icon(Icons.keyboard_arrow_down,
                            color: AppColors.textSecondary, size: 18),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Notification icon
            _IconBtn(icon: Icons.notifications_outlined, onTap: () {}),
            const SizedBox(width: 8),
            // Profile icon
            _IconBtn(icon: Icons.person_outline, onTap: () {}),
          ],
        ),
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _IconBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.divider),
        ),
        child: Icon(icon, color: AppColors.textSecondary, size: 20),
      ),
    );
  }
}

// ── Sheet Header ─────────────────────────────────────────────────────────────
class _SheetHeader extends StatelessWidget {
  final ScrollController scrollController;
  const _SheetHeader({required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: scrollController,
      child: Column(
        children: [
          const SizedBox(height: 10),
          Container(
            width: 40, height: 4,
            decoration: BoxDecoration(
              color: AppColors.iconMuted,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Row(
              children: [
                Text('Nearby Bins', style: AppTextStyles.heading2),
                const Spacer(),
                BlocBuilder<BinBloc, BinState>(
                  builder: (_, state) => Text(
                    '${state.filteredBins.length} bins',
                    style: AppTextStyles.bodySecondary,
                  ),
                ),
              ],
            ),
          ),
          // Stats row
          BlocBuilder<BinBloc, BinState>(
            builder: (_, p) => Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Row(
                children: [
                  _StatChip(count: p.fullBins, label: 'Full', color: AppColors.statusFull),
                  const SizedBox(width: 6),
                  _StatChip(count: p.fillingBins, label: 'Filling', color: AppColors.statusFilling),
                  const SizedBox(width: 6),
                  _StatChip(count: p.emptyBins, label: 'Empty', color: AppColors.statusEmpty),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final int count;
  final String label;
  final Color color;
  const _StatChip({required this.count, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 4),
          Text('$count $label', style: AppTextStyles.caption.copyWith(color: color, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

// ── Bin Sheet List ────────────────────────────────────────────────────────────
class _BinSheetList extends StatelessWidget {
  final ScrollController scrollController;
  final void Function(BinModel bin) onBinTap;

  const _BinSheetList({
    required this.scrollController,
    required this.onBinTap,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BinBloc, BinState>(
      builder: (_, binProv) {
        return ListView.builder(
          controller: scrollController,
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
          itemCount: binProv.filteredBins.length,
          itemBuilder: (_, i) => BinCard(
            bin: binProv.filteredBins[i],
            onTap: () => onBinTap(binProv.filteredBins[i]),
          ),
        );
      },
    );
  }
}
