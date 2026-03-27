import 'package:ecosyncai/core/themes/app_color.dart';
import 'package:ecosyncai/core/themes/app_text_styles.dart';
import 'package:ecosyncai/features/driver/domain/entities/driver_task_entity.dart';
import 'package:ecosyncai/features/driver/presentations/bloc/driver/driver_bloc.dart';
import 'package:ecosyncai/features/driver/presentations/bloc/driver/driver_event.dart';
import 'package:ecosyncai/features/driver/presentations/bloc/driver/driver_state.dart';
import 'package:ecosyncai/features/driver/presentations/widgets/driver_floating_nav_bar.dart';
import 'package:ecosyncai/features/driver/presentations/widgets/driver_route_map_placeholder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class DriverTaskDetailScreen extends StatefulWidget {
  final String binId;
  const DriverTaskDetailScreen({super.key, required this.binId});

  @override
  State<DriverTaskDetailScreen> createState() => _DriverTaskDetailScreenState();
}

class _DriverTaskDetailScreenState extends State<DriverTaskDetailScreen> {
  int _navIndex = 0;

  String _formatLastUpdated(DateTime dateTime) {
    return DateFormat('MMM d, hh:mm a').format(dateTime);
  }

  @override
  void initState() {
    super.initState();
    context.read<DriverBloc>().add(FetchDriverTaskDetail(widget.binId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocBuilder<DriverBloc, DriverState>(
          builder: (context, state) {
            if (state is DriverInitial || state is DriverLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            } else if (state is DriverError) {
              return Center(child: Text('Error: ${state.message}'));
            } else if (state is DriverLoaded) {
              final task = state.taskDetail;
              return Stack(
                children: [
                  SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Route Info ───────────────────────────────────────
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'CURRENT ROUTE',
                                style: AppTextStyles.caption.copyWith(letterSpacing: 1.2),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Stop ${task.stopNumber} of ${task.totalStops}',
                                style: AppTextStyles.heading1.copyWith(fontSize: 24),
                              ),
                            ],
                          ),
                          if (task.routeActive)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'ACTIVE ROUTE',
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // ── Bin ID & Status ──────────────────────────────────
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                task.binId,
                                style: AppTextStyles.heading1.copyWith(fontSize: 32),
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.wifi, size: 14, color: AppColors.primary),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Last pinged: ${task.lastPingedMinutesAgo} mins ago',
                                    style: AppTextStyles.bodySecondary.copyWith(fontSize: 12),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          if (task.isFull)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppColors.statusFull.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                      color: AppColors.statusFull,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'FULL',
                                    style: AppTextStyles.caption.copyWith(
                                      color: AppColors.statusFull,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 28),

                      // ── Details Card ─────────────────────────────────────
                      _buildDetailsCard(task),
                      const SizedBox(height: 20),

                      // ── Flags & Updated ──────────────────────────────────
                      Row(
                        children: [
                          Expanded(
                            child: _buildInfoTile(
                              label: 'ISSUE FLAGS',
                              value: task.issueFlags,
                              icon: Icons.check_circle,
                              iconColor: AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildInfoTile(
                              label: 'LAST UPDATED',
                              value: _formatLastUpdated(task.lastUpdated),
                              icon: null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // ── Location Section ─────────────────────────────────
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('LOCATION', style: AppTextStyles.heading3.copyWith(letterSpacing: 1.1)),
                          TextButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.near_me, size: 16, color: AppColors.primary),
                            label: Text(
                              'Open in Maps',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      DriverRouteMapPlaceholder(task: task),
                      const SizedBox(height: 32),

                      // ── Action Buttons ───────────────────────────────────
                      _buildMainActionButton('Mark Collected', Icons.check_circle_outline),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildSecondaryButton('REPORT PROBLEM', Icons.error_outline),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildSecondaryButton('SKIP STOP', Icons.skip_next_outlined),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // ── Floating Nav Bar ──────────────────────────────────────
                Align(
                  alignment: Alignment.bottomCenter,
                  child: DriverFloatingNavBar(
                    currentIndex: _navIndex,
                    onTap: (index) {
                      setState(() {
                        _navIndex = index;
                      });
                    },
                  ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
      )
    );
  }

  Widget _buildDetailsCard(DriverTaskEntity task) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('WASTE CATEGORY', style: AppTextStyles.caption),
                    const SizedBox(height: 4),
                    Text(
                      task.wasteCategory,
                      style: AppTextStyles.heading2.copyWith(color: AppColors.primary),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.05),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.eco_outlined, color: AppColors.primary, size: 28),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Divider(color: AppColors.divider.withOpacity(0.5)),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('WARD / ZONE', style: AppTextStyles.caption),
                    const SizedBox(height: 4),
                    Text(
                      '${task.ward} / ${task.zone}',
                      style: AppTextStyles.heading3,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('FILL LEVEL', style: AppTextStyles.caption),
                    const SizedBox(height: 4),
                    Text(
                      '${task.fillLevel}% (High Capacity)',
                      style: AppTextStyles.heading3.copyWith(color: AppColors.statusFull),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile({
    required String label,
    required String value,
    required IconData? icon,
    Color? iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.caption.copyWith(fontSize: 9)),
          const SizedBox(height: 8),
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18, color: iconColor),
                const SizedBox(width: 8),
              ],
              Text(value, style: AppTextStyles.heading3.copyWith(fontSize: 14)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMainActionButton(String label, IconData icon) {
    return Container(
      width: double.infinity,
      height: 64,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(32),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white),
              const SizedBox(width: 12),
              Text(
                label,
                style: AppTextStyles.heading3.copyWith(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSecondaryButton(String label, IconData icon) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.divider),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(28),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: AppColors.textSecondary),
              const SizedBox(width: 8),
              Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
