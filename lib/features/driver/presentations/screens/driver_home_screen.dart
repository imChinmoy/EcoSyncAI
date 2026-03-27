import 'package:ecosyncai/core/themes/app_color.dart';
import 'package:ecosyncai/core/themes/app_text_styles.dart';
import 'package:ecosyncai/features/auth/presentations/screens/role_selection_screen.dart';
import 'package:ecosyncai/features/driver/domain/repository/driver_repository.dart';
import 'package:ecosyncai/features/driver/presentations/cubit/driver_route_session_cubit.dart';
import 'package:ecosyncai/features/driver/presentations/screens/driver_task_detail_screen.dart';
import 'package:ecosyncai/features/home/presentations/bloc/ward/ward_bloc.dart';
import 'package:ecosyncai/features/home/presentations/bloc/ward/ward_event.dart';
import 'package:ecosyncai/features/home/presentations/bloc/ward/ward_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DriverHomeScreen extends StatelessWidget {
  const DriverHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Driver Dashboard'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_outlined),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Shift Overview',
                style: AppTextStyles.caption.copyWith(
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text('Welcome back, Driver', style: AppTextStyles.heading1),
              const SizedBox(height: 8),
              Text(
                'Monitor your route, review stop priority, and continue collection tasks.',
                style: AppTextStyles.bodySecondary,
              ),
              const SizedBox(height: 24),
              _ActiveRouteCard(
                onOpenRoute: () => _openTaskDetail(context),
              ),
              const SizedBox(height: 20),
              Row(
                children: const [
                  Expanded(
                    child: _MetricCard(
                      title: 'Stops',
                      value: '12',
                      subtitle: '3 completed',
                      icon: Icons.route_outlined,
                      tint: AppColors.primary,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _MetricCard(
                      title: 'Urgent',
                      value: '4',
                      subtitle: 'Need pickup',
                      icon: Icons.warning_amber_rounded,
                      tint: AppColors.statusFull,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: const [
                  Expanded(
                    child: _MetricCard(
                      title: 'Distance',
                      value: '18 km',
                      subtitle: 'Optimized',
                      icon: Icons.map_outlined,
                      tint: AppColors.primaryDark,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _MetricCard(
                      title: 'ETA',
                      value: '1h 35m',
                      subtitle: 'Current route',
                      icon: Icons.schedule_outlined,
                      tint: AppColors.statusFilling,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text('Today\'s Route', style: AppTextStyles.heading2),
              const SizedBox(height: 12),
              const _RouteStopTile(
                title: 'BIN-0942-X',
                subtitle: 'Civic Center Way, Ward 4',
                status: 'Current Stop',
                statusColor: AppColors.statusFilling,
              ),
              const _RouteStopTile(
                title: 'BIN-1051-A',
                subtitle: 'North District, Sector 9',
                status: 'Urgent',
                statusColor: AppColors.statusFull,
              ),
              const _RouteStopTile(
                title: 'BIN-1184-C',
                subtitle: 'Market Loop, Ward 5',
                status: 'Queued',
                statusColor: AppColors.primary,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _openTaskDetail(context),
                  icon: const Icon(Icons.navigation_outlined),
                  label: const Text('Open Active Route'),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const RoleSelectionScreen(),
                      ),
                    );
                  },
                  child: const Text('Back to Role Selection'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openTaskDetail(BuildContext context) {
    final repo = context.read<DriverRepository>();
    final wardBloc = context.read<WardBloc>();
    if (wardBloc.state.status != WardStatus.loaded) {
      wardBloc.add(FetchWardsRequested());
    }
    final wards = wardBloc.state.wards.where((w) => w.id != 0).toList();
    Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (_) => RepositoryProvider<DriverRepository>.value(
          value: repo,
          child: BlocProvider(
            create: (_) => DriverRouteSessionCubit(
              repository: repo,
              driverId: 'driver_01',
              initialWardId: wards.isNotEmpty ? wards.first.id : 1,
              selectableWards: wards.isNotEmpty ? wards : null,
            )..initialize(),
            child: const DriverTaskDetailScreen(),
          ),
        ),
      ),
    );
  }
}

class _ActiveRouteCard extends StatelessWidget {
  const _ActiveRouteCard({required this.onOpenRoute});

  final VoidCallback onOpenRoute;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.local_shipping_outlined,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Route A12', style: AppTextStyles.heading2),
                    Text(
                      'Ward 4 to North Zone',
                      style: AppTextStyles.bodySecondary,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.statusEmptyBg,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text(
                  'ACTIVE',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.statusEmpty,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            'Your optimized route is ready. Continue from the current stop and keep track of urgent pickups.',
            style: AppTextStyles.bodySecondary,
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _SmallPill(
                  icon: Icons.flag_outlined,
                  text: 'Stop 5 of 12',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _SmallPill(
                  icon: Icons.timer_outlined,
                  text: 'ETA 1h 35m',
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onOpenRoute,
              child: const Text('Continue Route'),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.tint,
  });

  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color tint;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: tint.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: tint, size: 20),
          ),
          const SizedBox(height: 14),
          Text(title, style: AppTextStyles.caption),
          const SizedBox(height: 4),
          Text(value, style: AppTextStyles.heading2),
          const SizedBox(height: 2),
          Text(subtitle, style: AppTextStyles.bodySecondary),
        ],
      ),
    );
  }
}

class _RouteStopTile extends StatelessWidget {
  const _RouteStopTile({
    required this.title,
    required this.subtitle,
    required this.status,
    required this.statusColor,
  });

  final String title;
  final String subtitle;
  final String status;
  final Color statusColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 48,
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.heading3),
                const SizedBox(height: 4),
                Text(subtitle, style: AppTextStyles.bodySecondary),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              status,
              style: AppTextStyles.caption.copyWith(
                color: statusColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallPill extends StatelessWidget {
  const _SmallPill({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 16, color: AppColors.primary),
          const SizedBox(width: 8),
          Text(text, style: AppTextStyles.caption.copyWith(fontSize: 10)),
        ],
      ),
    );
  }
}
