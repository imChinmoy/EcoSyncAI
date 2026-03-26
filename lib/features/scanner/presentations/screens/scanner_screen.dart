import 'package:ecosyncai/core/themes/app_color.dart';
import 'package:ecosyncai/core/themes/app_text_styles.dart';
import 'package:flutter/material.dart';

class ScannerScreen extends StatelessWidget {
  const ScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: integrate camera plugin
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 📸 Camera background placeholder
          _buildCameraPlaceholder(),

          // 🟢 Overlay UI elements
          _buildOverlay(context),

          // 🔘 Scan Button
          _buildScanButton(),

          // 📦 Bottom control panel
          _buildBottomControls(),
        ],
      ),
    );
  }

  Widget _buildCameraPlaceholder() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withOpacity(0.6),
            Colors.transparent,
            Colors.black.withOpacity(0.6),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.camera_alt_outlined,
          color: Colors.white.withOpacity(0.2),
          size: 100,
        ),
      ),
    );
  }

  Widget _buildOverlay(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // Minimal Top Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
                Text(
                  'AI Scanner',
                  style: AppTextStyles.heading2.copyWith(color: Colors.white),
                ),
                const Row(
                  children: [
                    Icon(Icons.help_outline, color: Colors.white, size: 20),
                    SizedBox(width: 16),
                    Icon(Icons.more_vert, color: Colors.white, size: 20),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Status Label
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Position waste clearly',
              style: AppTextStyles.bodySecondary.copyWith(color: Colors.white),
            ),
          ),

          const Spacer(),

          // Focus Frame
          _buildFocusFrame(context),

          const Spacer(flex: 2),
        ],
      ),
    );
  }

  Widget _buildFocusFrame(BuildContext context) {
    final size = MediaQuery.of(context).size.width * 0.7;
    return Center(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.transparent),
        ),
        child: Stack(
          children: [
            // Corners
            _buildCorner(Alignment.topLeft),
            _buildCorner(Alignment.topRight),
            _buildCorner(Alignment.bottomLeft),
            _buildCorner(Alignment.bottomRight),
            
            // Subtle glow in center (simulated)
            Center(
              child: Container(
                width: size * 0.8,
                height: size * 0.8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.primary.withOpacity(0.1),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCorner(Alignment alignment) {
    const double cornerSize = 30;
    const double thickness = 3;
    final color = AppColors.primary;

    return Align(
      alignment: alignment,
      child: Container(
        width: cornerSize,
        height: cornerSize,
        child: Stack(
          children: [
            // Horizontal line
            Positioned(
              top: alignment.y == -1 ? 0 : null,
              bottom: alignment.y == 1 ? 0 : null,
              left: 0,
              right: 0,
              child: Container(
                height: thickness,
                color: color,
              ),
            ),
            // Vertical line
            Positioned(
              left: alignment.x == -1 ? 0 : null,
              right: alignment.x == 1 ? 0 : null,
              top: 0,
              bottom: 0,
              child: Container(
                width: thickness,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScanButton() {
    return Positioned(
      bottom: 120,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.2),
            border: Border.all(color: Colors.white, width: 4),
          ),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.all(16),
                elevation: 0,
              ),
              child: const Icon(Icons.qr_code_scanner, color: Colors.white, size: 32),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomControls() {
    return Positioned(
      bottom: 40,
      left: 32,
      right: 32,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surface.withOpacity(0.15),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildControlButton(Icons.photo_library_outlined),
            _buildControlButton(Icons.flash_on_outlined),
            _buildControlButton(Icons.settings_outlined),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton(IconData icon) {
    return IconButton(
      icon: Icon(icon, color: Colors.white, size: 24),
      onPressed: () {},
    );
  }
}
