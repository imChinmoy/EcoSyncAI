import 'package:ecosyncai/core/locale/app_localizations.dart';
import 'package:ecosyncai/core/themes/app_color.dart';
import 'package:ecosyncai/core/themes/app_effects.dart';
import 'package:ecosyncai/core/themes/app_text_styles.dart';
import 'package:ecosyncai/features/home/presentations/screens/map_screen.dart';
import 'package:ecosyncai/features/scanner/presentations/screens/scanner_screen.dart';
import 'package:flutter/material.dart';

enum _MaterialBadge { success, tracking, none }

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header Section ───────────────────────────────────────────
              _buildHeader(l10n),
              const SizedBox(height: 24),

              // ── Summary Cards (Diverted & Offset) ───────────────────────
              Row(
                children: [
                  Expanded(
                    child: _buildSummaryCard(
                      icon: Icons.recycling,
                      label: l10n.diverted,
                      value: '12.4 kg',
                      iconColor: AppColors.statusEmpty,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildSummaryCard(
                      icon: Icons.co2,
                      label: l10n.offset,
                      value: '48 kg',
                      iconColor: Colors.blueAccent,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // ── AI Scanner Section ───────────────────────────────────────
              _buildAiScannerCard(context, l10n),
              const SizedBox(height: 32),

              // ── Nearby & Schedules Section ───────────────────────────────
              _buildSectionTitle(l10n.nearbySchedules),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 3, child: _buildNearbyBinsCard(l10n, context)),
                  const SizedBox(width: 16),
                  Expanded(flex: 2, child: _buildScheduleCard(l10n)),
                ],
              ),
              const SizedBox(height: 32),

              // ── Materials Saved Section ──────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSectionTitle(l10n.materialsSaved),
                  Text(
                    l10n.history,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildMaterialSavedItem(
                label: l10n.biodegradable,
                subLabel: l10n.organicWaste,
                value: '5.2 kg',
                badge: _MaterialBadge.success,
                l10n: l10n,
                color: AppColors.statusEmpty,
              ),
              const SizedBox(height: 12),
              _buildMaterialSavedItem(
                label: l10n.recyclables,
                subLabel: l10n.plasticPaper,
                value: '4.8 kg',
                badge: _MaterialBadge.tracking,
                l10n: l10n,
                color: Colors.lightBlueAccent,
              ),
              const SizedBox(height: 12),
              _buildMaterialSavedItem(
                label: l10n.eWaste,
                subLabel: l10n.electronics,
                value: '2.4 kg',
                badge: _MaterialBadge.none,
                l10n: l10n,
                color: Colors.indigoAccent,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // ── Helper Widgets ────────────────────────────────────────────────────────

  Widget _buildHeader(AppLocalizations l10n) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.globalCitizen,
              style: AppTextStyles.caption.copyWith(
                letterSpacing: 1.2,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              l10n.helloAlex,
              style: AppTextStyles.heading1.copyWith(fontSize: 28),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: AppEffects.clay(radius: 16),
          child: Column(
            children: [
              Text(
                '340${l10n.pointsSuffix}',
                style: AppTextStyles.heading3.copyWith(
                  color: AppColors.statusEmpty,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                l10n.ecoTierGold,
                style: AppTextStyles.caption.copyWith(fontSize: 9),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard({
    required IconData icon,
    required String label,
    required String value,
    required Color iconColor,
  }) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      radius: 20,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTextStyles.bodySecondary),
              Text(
                value,
                style: AppTextStyles.heading3.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAiScannerCard(BuildContext context, AppLocalizations l10n) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: AppEffects.clay(radius: 32, color: const Color(0xFF111826)),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.4),
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.qr_code_scanner,
                  color: Colors.white,
                  size: 40,
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.auto_awesome,
                    color: Colors.amber,
                    size: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            l10n.identifySort,
            style: AppTextStyles.heading2.copyWith(
              color: Colors.white,
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.sortCameraHint,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySecondary.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ScannerScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.background,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
            child: Text(l10n.launchAiScanner),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: AppTextStyles.heading2.copyWith(fontSize: 18));
  }

  Widget _buildNearbyBinsCard(AppLocalizations l10n, BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      radius: 24,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const MapScreen()),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.statusEmpty.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.location_on,
                    color: AppColors.statusEmpty,
                    size: 20,
                  ),
                ),
                Text(
                  l10n.activeHubs,
                  style: AppTextStyles.caption.copyWith(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(l10n.nearbyBins, style: AppTextStyles.heading3),
            const SizedBox(height: 4),
            Text(
              l10n.findDropoffNearby,
              style: AppTextStyles.bodySecondary.copyWith(fontSize: 11),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildTinyAvatar(Colors.grey[300]!),
                const SizedBox(width: 4),
                _buildTinyAvatar(Colors.grey[400]!),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTinyAvatar(Color color) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
    );
  }

  Widget _buildScheduleCard(AppLocalizations l10n) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      radius: 24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blueAccent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.calendar_today,
              color: Colors.blueAccent,
              size: 20,
            ),
          ),
          const SizedBox(height: 32),
          Text(l10n.scheduleDaySample, style: AppTextStyles.heading3),
          const SizedBox(height: 4),
          Text(
            l10n.recycleDay,
            style: AppTextStyles.caption.copyWith(
              fontSize: 9,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMaterialSavedItem({
    required String label,
    required String subLabel,
    required String value,
    required _MaterialBadge badge,
    required AppLocalizations l10n,
    required Color color,
  }) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      radius: 20,
      child: Row(
        children: [
          Container(
            width: 4,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTextStyles.heading3),
                Text(
                  subLabel,
                  style: AppTextStyles.bodySecondary.copyWith(fontSize: 11),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: AppTextStyles.heading3.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (badge != _MaterialBadge.none) ...[
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: badge == _MaterialBadge.success
                        ? AppColors.statusEmpty.withValues(alpha: 0.1)
                        : Colors.blueAccent.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    badge == _MaterialBadge.success
                        ? l10n.success
                        : l10n.tracking,
                    style: AppTextStyles.caption.copyWith(
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                      color: badge == _MaterialBadge.success
                          ? AppColors.statusEmpty
                          : Colors.blueAccent,
                    ),
                  ),
                ),
              ] else ...[
                const SizedBox(height: 4),
                Container(
                  width: 50,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: 0.6,
                    child: Container(
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
