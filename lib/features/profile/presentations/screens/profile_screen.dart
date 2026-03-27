import 'package:ecosyncai/core/themes/app_color.dart';
import 'package:ecosyncai/core/themes/app_effects.dart';
import 'package:ecosyncai/core/themes/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _notificationsEnabled = true;

  Future<void> _clearSavedSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Saved session cleared.')),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Expanded(
      child: GlassCard(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        radius: 16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 18, color: AppColors.primary),
            const SizedBox(height: 10),
            Text(value, style: AppTextStyles.heading2),
            const SizedBox(height: 2),
            Text(title, style: AppTextStyles.caption),
          ],
        ),
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
    Color iconColor = AppColors.primary,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.14),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(title, style: AppTextStyles.heading3),
      subtitle: subtitle == null ? null : Text(subtitle, style: AppTextStyles.caption),
      trailing: trailing ??
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.textMuted,
          ),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Profile', style: AppTextStyles.heading1),
              const SizedBox(height: 4),
              Text(
                'Manage your account and preferences',
                style: AppTextStyles.bodySecondary,
              ),
              const SizedBox(height: 16),
              GlassCard(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 58,
                      height: 58,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.surface,
                      ),
                      child: const Icon(
                        Icons.person_rounded,
                        color: AppColors.primary,
                        size: 30,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('EcoSync User', style: AppTextStyles.heading2),
                          const SizedBox(height: 3),
                          Text(
                            'Community volunteer',
                            style: AppTextStyles.bodySecondary,
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.14),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Ward Monitor',
                              style: AppTextStyles.badgeText.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Edit profile will be available soon.'),
                          ),
                        );
                      },
                      icon: const Icon(Icons.edit_outlined, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  _buildStatCard(
                    title: 'Reports',
                    value: '34',
                    icon: Icons.report_gmailerrorred_rounded,
                  ),
                  const SizedBox(width: 10),
                  _buildStatCard(
                    title: 'Scans',
                    value: '112',
                    icon: Icons.qr_code_scanner_rounded,
                  ),
                  const SizedBox(width: 10),
                  _buildStatCard(
                    title: 'Points',
                    value: '860',
                    icon: Icons.star_rounded,
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Text(
                'Preferences',
                style: AppTextStyles.heading3,
              ),
              const SizedBox(height: 8),
              GlassCard(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                radius: 16,
                child: Column(
                  children: [
                    _buildActionTile(
                      icon: Icons.notifications_none_rounded,
                      title: 'Push Notifications',
                      subtitle: 'Alerts for nearby full bins and updates',
                      trailing: Switch.adaptive(
                        value: _notificationsEnabled,
                        onChanged: (value) {
                          setState(() => _notificationsEnabled = value);
                        },
                        activeColor: AppColors.primary,
                      ),
                    ),
                    const Divider(height: 1),
                    _buildActionTile(
                      icon: Icons.language_rounded,
                      title: 'Language',
                      subtitle: 'English',
                      onTap: () {},
                    ),
                    const Divider(height: 1),
                    _buildActionTile(
                      icon: Icons.help_outline_rounded,
                      title: 'Help & Support',
                      subtitle: 'FAQs and contact options',
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'Account',
                style: AppTextStyles.heading3,
              ),
              const SizedBox(height: 8),
              GlassCard(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                radius: 16,
                child: Column(
                  children: [
                    _buildActionTile(
                      icon: Icons.shield_outlined,
                      title: 'Privacy Policy',
                      onTap: () {},
                    ),
                    const Divider(height: 1),
                    _buildActionTile(
                      icon: Icons.logout_rounded,
                      iconColor: AppColors.statusFull,
                      title: 'Clear Saved Session',
                      subtitle: 'Removes local auth token from this device',
                      trailing: const SizedBox.shrink(),
                      onTap: _clearSavedSession,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
