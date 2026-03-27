import 'dart:async';

import 'package:ecosyncai/core/themes/app_color.dart';
import 'package:ecosyncai/features/auth/presentations/screens/role_selection_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

/// Lottie asset path (filename contains a space).
const String kSplashLottieAsset = 'assets/animations/Delete Files.json';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _lottieController;
  Timer? _fallbackTimer;
  bool _didNavigate = false;

  @override
  void initState() {
    super.initState();
    _lottieController = AnimationController(vsync: this);
    _fallbackTimer = Timer(const Duration(seconds: 6), _goToMain);
  }

  void _goToMain() {
    if (!mounted || _didNavigate) return;
    _didNavigate = true;
    _fallbackTimer?.cancel();
    Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const RoleSelectionScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  void dispose() {
    _fallbackTimer?.cancel();
    _lottieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Lottie.asset(
                  kSplashLottieAsset,
                  controller: _lottieController,
                  repeat: false,
                  fit: BoxFit.contain,
                  onLoaded: (composition) {
                    _lottieController
                      ..duration = composition.duration
                      ..forward().whenComplete(_goToMain);
                  },
                  errorBuilder: (context, error, stackTrace) {
                    WidgetsBinding.instance
                        .addPostFrameCallback((_) => _goToMain());
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 48),
              child: Text(
                'EcoSyncAI',
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
