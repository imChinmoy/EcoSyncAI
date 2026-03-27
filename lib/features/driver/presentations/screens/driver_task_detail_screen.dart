import 'package:ecosyncai/core/themes/app_color.dart';
import 'package:ecosyncai/core/themes/app_text_styles.dart';
import 'package:ecosyncai/features/driver/domain/entities/driver_current_stop_entity.dart';
import 'package:ecosyncai/features/driver/domain/entities/driver_route_entity.dart';
import 'package:ecosyncai/features/driver/presentations/cubit/driver_route_session_cubit.dart';
import 'package:ecosyncai/features/home/domain/entities/ward_entity.dart';
import 'package:ecosyncai/features/driver/presentations/widgets/driver_floating_nav_bar.dart';
import 'package:ecosyncai/features/driver/presentations/widgets/driver_route_map_display.dart';
import 'package:ecosyncai/features/driver/presentations/widgets/route_stop_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class DriverTaskDetailScreen extends StatefulWidget {
  const DriverTaskDetailScreen({super.key});

  @override
  State<DriverTaskDetailScreen> createState() => _DriverTaskDetailScreenState();
}

class _DriverTaskDetailScreenState extends State<DriverTaskDetailScreen> {
  int _navIndex = 0;

  String _fmt(DateTime? d) {
    if (d == null) return '—';
    return DateFormat('MMM d, hh:mm a').format(d);
  }

  String _wardName(DriverRouteSessionState s) {
    for (final w in s.selectableWards) {
      if (w.id == s.wardId) return w.name;
    }
    return 'Ward ${s.wardId}';
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DriverRouteSessionCubit, DriverRouteSessionState>(
      builder: (context, state) {
        final cubit = context.read<DriverRouteSessionCubit>();

        if (state.status == DriverSessionStatus.initial ||
            (state.status == DriverSessionStatus.loading &&
                state.stopDetails == null &&
                state.route == null)) {
          return _scaffoldShell(
            context,
            title: 'Loading…',
            child: const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          );
        }

        if (state.status == DriverSessionStatus.error &&
            state.route == null &&
            state.stopDetails == null) {
          return _scaffoldShell(
            context,
            title: 'Route',
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      state.errorMessage ?? 'Something went wrong',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodySecondary,
                    ),
                    const SizedBox(height: 20),
                    FilledButton(
                      onPressed: () => cubit.syncRoute(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        final stop = state.stopDetails ?? DriverCurrentStopEntity.empty();
        final lat = state.lat ?? 28.6139;
        final lng = state.lng ?? 77.2090;
        final RouteWaypoint? currentWp =
            state.route != null &&
                    state.currentStopIndex >= 0 &&
                    state.currentStopIndex < state.route!.waypoints.length
                ? state.route!.waypoints[state.currentStopIndex]
                : null;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.background,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(
              _navIndex == 0 ? 'Pickup' : 'Map',
              style: AppTextStyles.heading2.copyWith(fontSize: 18),
            ),
            centerTitle: true,
            actions: [
              if (state.status == DriverSessionStatus.loading)
                const Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: Center(
                    child: SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                ),
            ],
          ),
          body: Column(
            children: [
              if (state.errorMessage != null &&
                  state.errorMessage!.isNotEmpty &&
                  state.status == DriverSessionStatus.ready)
                Material(
                  color: AppColors.statusFull.withValues(alpha: 0.12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.warning_amber_rounded,
                            size: 18, color: AppColors.statusFull),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            state.errorMessage!,
                            style: AppTextStyles.caption,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              Expanded(
                child: _navIndex == 0
                    ? _TasksBody(
                        state: state,
                        stop: stop,
                        currentWaypoint: currentWp,
                        wardName: _wardName(state),
                        formatDate: _fmt,
                        onWardChanged: cubit.changeWard,
                        onMarkCollected: state.routeFinished || state.totalStops == 0
                            ? null
                            : () => cubit.markCollected(),
                        routeFinished: state.routeFinished,
                      )
                    : DriverRouteMapDisplay(
                        route: state.route,
                        currentStopIndex: state.currentStopIndex,
                        userLat: lat,
                        userLng: lng,
                        myLocationEnabled:
                            !state.locationPermissionDenied,
                        onRefresh: () => cubit.syncRoute(),
                      ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: DriverFloatingNavBar(
                  currentIndex: _navIndex,
                  onTap: (index) => setState(() => _navIndex = index),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _scaffoldShell(
    BuildContext context, {
    required String title,
    required Widget child,
  }) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(title, style: AppTextStyles.heading2.copyWith(fontSize: 18)),
        centerTitle: true,
      ),
      body: child,
    );
  }
}

class _TasksBody extends StatelessWidget {
  const _TasksBody({
    required this.state,
    required this.stop,
    required this.currentWaypoint,
    required this.wardName,
    required this.formatDate,
    required this.onWardChanged,
    required this.onMarkCollected,
    required this.routeFinished,
  });

  final DriverRouteSessionState state;
  final DriverCurrentStopEntity stop;
  final RouteWaypoint? currentWaypoint;
  final String wardName;
  final String Function(DateTime?) formatDate;
  final Future<void> Function(int) onWardChanged;
  final VoidCallback? onMarkCollected;
  final bool routeFinished;

  @override
  Widget build(BuildContext context) {
    final total = state.totalStops;
    final wp = currentWaypoint;
    final idx = state.currentStopIndex + 1;

    final binLabel = wp?.id != null
        ? 'Bin #${wp!.id}'
        : (stop.binId != '—' ? stop.binId : 'This bin');

    final categoryText = _friendlyCategory(wp?.category ?? stop.wasteCategory);
    final statusText = _friendlyBinStatus(wp?.status, stop.isFull);
    final lastReading = wp?.lastUpdated ?? stop.lastUpdated;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 36),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _WardRow(
            wardId: state.wardId,
            wardName: wardName,
            wards: state.selectableWards,
            onChanged: onWardChanged,
          ),
          const SizedBox(height: 22),
          if (routeFinished)
            _DoneBanner()
          else if (total > 0) ...[
            RouteStopStepper(
              totalStops: total,
              currentIndex: state.currentStopIndex,
              routeFinished: routeFinished,
            ),
            const SizedBox(height: 10),
            Text(
              '$idx of $total pickups on this run',
              style: AppTextStyles.bodySecondary.copyWith(height: 1.4),
            ),
            const SizedBox(height: 20),
          ] else
            Padding(
              padding: const EdgeInsets.only(bottom: 18),
              child: Text(
                'No bins listed for this ward yet. Try another ward or sync again.',
                style: AppTextStyles.bodySecondary.copyWith(height: 1.4),
              ),
            ),
          if (!routeFinished && total > 0) ...[
            Text(
              'This pickup',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textMuted,
                letterSpacing: 0.6,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              binLabel,
              style: AppTextStyles.heading1.copyWith(
                fontSize: 30,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                _SoftChip(
                  icon: Icons.category_outlined,
                  label: categoryText,
                  emphasized: true,
                ),
                _SoftChip(
                  icon: Icons.flag_outlined,
                  label: statusText,
                  color: _statusTint(wp?.status, stop.isFull),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (lastReading != null)
              Text(
                'Sensor last reading · ${formatDate(lastReading)}',
                style: AppTextStyles.bodySecondary.copyWith(fontSize: 13),
              )
            else if (stop.lastPingedMinutesAgo > 0)
              Text(
                'Last contact about ${stop.lastPingedMinutesAgo} min ago',
                style: AppTextStyles.bodySecondary.copyWith(fontSize: 13),
              ),
            const SizedBox(height: 20),
            _LocationHintCard(
              waypoint: wp,
              fallbackAddress: stop.address,
              fallbackArea: stop.area,
            ),
            if (stop.issueFlags.isNotEmpty &&
                stop.issueFlags != '—' &&
                stop.issueFlags.toLowerCase() != 'none') ...[
              const SizedBox(height: 14),
              _NoteCard(text: stop.issueFlags),
            ],
          ],
          const SizedBox(height: 28),
          _GradientButton(
            label: routeFinished ? 'All done for this ward' : 'Mark collected',
            icon: Icons.check_circle_outline,
            onPressed: onMarkCollected,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _OutlineButton(
                  label: 'Report problem',
                  icon: Icons.error_outline,
                  onPressed: () {},
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _OutlineButton(
                  label: 'Skip stop',
                  icon: Icons.skip_next_outlined,
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

String _friendlyCategory(String raw) {
  final t = raw.trim();
  if (t.isEmpty || t == '—') return 'Category not set';
  final lower = t.toLowerCase();
  if (lower == 'mixed') return 'Mixed waste';
  if (lower.contains('plastic')) return 'Plastic';
  if (lower.contains('organic')) return 'Organic';
  return t[0].toUpperCase() + (t.length > 1 ? t.substring(1).toLowerCase() : '');
}

String _friendlyBinStatus(String? apiStatus, bool isFullFallback) {
  if (apiStatus != null && apiStatus.trim().isNotEmpty) {
    final s = apiStatus.trim();
    return s[0].toUpperCase() + (s.length > 1 ? s.substring(1).toLowerCase() : '');
  }
  return isFullFallback ? 'Full' : 'OK';
}

Color _statusTint(String? apiStatus, bool isFullFallback) {
  final s = (apiStatus ?? '').toLowerCase();
  if (s.contains('full') || isFullFallback) return AppColors.statusFull;
  if (s.contains('empty') || s.contains('low')) return AppColors.statusEmpty;
  if (s.contains('fill')) return AppColors.statusFilling;
  return AppColors.primary;
}

class _DoneBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.28)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.celebration_outlined, color: AppColors.primary, size: 26),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              'You\'ve finished every stop on this ward. Pick another ward above or head back when you\'re ready.',
              style: AppTextStyles.bodySecondary.copyWith(height: 1.45),
            ),
          ),
        ],
      ),
    );
  }
}

class _SoftChip extends StatelessWidget {
  const _SoftChip({
    required this.icon,
    required this.label,
    this.emphasized = false,
    this.color,
  });

  final IconData icon;
  final String label;
  final bool emphasized;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: emphasized
            ? c.withValues(alpha: 0.12)
            : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: emphasized ? c.withValues(alpha: 0.35) : AppColors.divider,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: c),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _LocationHintCard extends StatelessWidget {
  const _LocationHintCard({
    required this.waypoint,
    required this.fallbackAddress,
    required this.fallbackArea,
  });

  final RouteWaypoint? waypoint;
  final String fallbackAddress;
  final String fallbackArea;

  @override
  Widget build(BuildContext context) {
    final w = waypoint;
    final hasTextAddress =
        fallbackAddress.isNotEmpty && fallbackAddress != '—';

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.divider.withValues(alpha: 0.85)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.near_me_outlined, size: 20, color: AppColors.primary.withValues(alpha: 0.9)),
              const SizedBox(width: 8),
              Text(
                'Where to go',
                style: AppTextStyles.heading3.copyWith(fontSize: 15),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (w != null) ...[
            Text(
              '${w.latitude.toStringAsFixed(4)}°, '
              '${w.longitude.toStringAsFixed(4)}°',
              style: AppTextStyles.heading2.copyWith(
                fontSize: 17,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.2,
              ),
            ),
            const SizedBox(height: 8),
          ],
          Text(
            'Open the Map tab for turn-by-turn context along the optimized path.',
            style: AppTextStyles.bodySecondary.copyWith(height: 1.45),
          ),
          if (hasTextAddress) ...[
            const SizedBox(height: 12),
            Text(fallbackAddress, style: AppTextStyles.bodySecondary),
            if (fallbackArea.isNotEmpty && fallbackArea != '—')
              Text(fallbackArea, style: AppTextStyles.caption),
          ],
        ],
      ),
    );
  }
}

class _NoteCard extends StatelessWidget {
  const _NoteCard({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.statusFilling.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, size: 18, color: AppColors.statusFilling),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.caption.copyWith(height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}

class _WardRow extends StatelessWidget {
  const _WardRow({
    required this.wardId,
    required this.wardName,
    required this.wards,
    required this.onChanged,
  });

  final int wardId;
  final String wardName;
  final List<WardEntity> wards;
  final Future<void> Function(int) onChanged;

  @override
  Widget build(BuildContext context) {
    final safeId = wards.any((w) => w.id == wardId)
        ? wardId
        : (wards.isNotEmpty ? wards.first.id : wardId);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          const Icon(Icons.map_outlined, size: 20, color: AppColors.primary),
          const SizedBox(width: 10),
          Text(
            'Working in',
            style: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                value: safeId,
                isExpanded: true,
                borderRadius: BorderRadius.circular(12),
                dropdownColor: AppColors.surface,
                style: AppTextStyles.heading3.copyWith(fontSize: 15),
                items: [
                  for (final w in wards)
                    DropdownMenuItem<int>(
                      value: w.id,
                      child: Text(w.name),
                    ),
                ],
                onChanged: (v) async {
                  if (v != null) await onChanged(v);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GradientButton extends StatelessWidget {
  const _GradientButton({
    required this.label,
    required this.icon,
    this.onPressed,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                AppColors.primary,
                AppColors.primary.withValues(alpha: 0.85),
              ],
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 22),
              const SizedBox(width: 10),
              Text(
                label,
                style: AppTextStyles.heading3.copyWith(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OutlineButton extends StatelessWidget {
  const _OutlineButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.textSecondary,
        padding: const EdgeInsets.symmetric(vertical: 12),
        side: BorderSide(color: AppColors.divider.withValues(alpha: 0.9)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      icon: Icon(icon, size: 18),
      label: Text(
        label,
        style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }
}
