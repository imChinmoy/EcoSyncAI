import 'package:camera/camera.dart';
import 'package:ecosyncai/core/themes/app_color.dart';
import 'package:ecosyncai/core/themes/app_text_styles.dart';
import 'package:ecosyncai/features/scanner/presentations/bloc/scanner/scanner_bloc.dart';
import 'package:ecosyncai/features/scanner/presentations/bloc/scanner/scanner_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        if (mounted) {
          context.read<ScannerBloc>().add(const ScannerError('No cameras available'));
        }
        return;
      }

      final backCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      _controller = CameraController(
        backCamera,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      _initializeControllerFuture = _controller!.initialize();
      if (mounted) setState(() {});
    } catch (e) {
      if (mounted) {
        context.read<ScannerBloc>().add(ScannerError('Camera error: $e'));
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized) {
      return;
    }

    try {
      await _initializeControllerFuture;
      final image = await _controller!.takePicture();
      if (mounted) {
        context.read<ScannerBloc>().add(ScannerImageCaptured(image.path));
      }
    } catch (e) {
      if (mounted) {
        context.read<ScannerBloc>().add(ScannerError('Capture error: $e'));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 📸 Camera Preview Layer
          _buildCameraPreview(),

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

  Widget _buildCameraPreview() {
    if (_controller == null || _initializeControllerFuture == null) {
      return _buildLoadingPlaceholder();
    }

    return FutureBuilder<void>(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return SizedBox.expand(
            child: CameraPreview(_controller!),
          );
        } else {
          return _buildLoadingPlaceholder();
        }
      },
    );
  }

  Widget _buildLoadingPlaceholder() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.black,
      child: const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
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
              onPressed: _takePicture,
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
