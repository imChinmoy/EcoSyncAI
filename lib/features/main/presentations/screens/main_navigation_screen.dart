import 'package:ecosyncai/core/locale/app_localizations.dart';
import 'package:ecosyncai/core/themes/app_color.dart';
import 'package:ecosyncai/features/home/presentations/screens/home_screen.dart';
import 'package:ecosyncai/features/home/presentations/screens/map_screen.dart';
import 'package:ecosyncai/features/profile/presentations/screens/profile_screen.dart';
import 'package:ecosyncai/features/report/presentations/screens/report_issue_screen.dart';
import 'package:flutter/material.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 2; // Map is the default tab

  final List<Widget> _screens = [
    const HomeScreen(),
    const ReportIssueScreen(),
    const MapScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashFactory: NoSplash.splashFactory,
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.surface,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textSecondary,
          items: [
            BottomNavigationBarItem(
              icon: _AnimatedNavIcon(
                icon: Icons.home_outlined,
                selected: _selectedIndex == 0,
              ),
              activeIcon: const _AnimatedNavIcon(
                icon: Icons.home,
                selected: true,
              ),
              label: l10n.navHome,
            ),
            BottomNavigationBarItem(
              icon: _AnimatedNavIcon(
                icon: Icons.report_problem_outlined,
                selected: _selectedIndex == 1,
              ),
              activeIcon: const _AnimatedNavIcon(
                icon: Icons.report_problem,
                selected: true,
              ),
              label: l10n.navReport,
            ),
            BottomNavigationBarItem(
              icon: _AnimatedNavIcon(
                icon: Icons.map_outlined,
                selected: _selectedIndex == 2,
              ),
              activeIcon: const _AnimatedNavIcon(
                icon: Icons.map,
                selected: true,
              ),
              label: l10n.navMap,
            ),
            BottomNavigationBarItem(
              icon: _AnimatedNavIcon(
                icon: Icons.person_outline,
                selected: _selectedIndex == 3,
              ),
              activeIcon: const _AnimatedNavIcon(
                icon: Icons.person,
                selected: true,
              ),
              label: l10n.navProfile,
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimatedNavIcon extends StatelessWidget {
  final IconData icon;
  final bool selected;

  const _AnimatedNavIcon({
    required this.icon,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 24,
      height: 24,
      child: AnimatedSlide(
        duration: const Duration(milliseconds: 320),
        curve: Curves.elasticOut,
        offset: selected ? const Offset(0, -0.12) : Offset.zero,
        child: AnimatedScale(
          duration: const Duration(milliseconds: 320),
          curve: Curves.elasticOut,
          scale: selected ? 1.12 : 1.0,
          child: Icon(icon),
        ),
      ),
    );
  }
}
