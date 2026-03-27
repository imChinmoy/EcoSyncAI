import 'package:camera/camera.dart';
import 'package:ecosyncai/core/locale/app_localizations.dart';
import 'package:ecosyncai/core/themes/app_color.dart';
import 'package:ecosyncai/core/themes/app_effects.dart';
import 'package:ecosyncai/core/themes/app_text_styles.dart';
import 'package:ecosyncai/features/scanner/domain/entities/scanner_result_entity.dart';
import 'package:ecosyncai/features/scanner/presentations/bloc/scanner/scanner_bloc.dart';
import 'package:ecosyncai/features/scanner/presentations/bloc/scanner/scanner_event.dart';
import 'package:ecosyncai/features/scanner/presentations/bloc/scanner/scanner_state.dart';
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
          context.read<ScannerBloc>().add(
            const ScannerError('No cameras available'),
          );
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
    _disableTorch();
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _disableTorch() async {
    try {
      if (_controller != null && _controller!.value.isInitialized) {
        await _controller!.setFlashMode(FlashMode.off);
      }
    } catch (_) {}
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

  Future<void> _toggleTorch() async {
    final isTorchOn = context.read<ScannerBloc>().state.isTorchOn;
    final nextMode = isTorchOn ? FlashMode.off : FlashMode.torch;

    try {
      if (_controller != null && _controller!.value.isInitialized) {
        await _controller!.setFlashMode(nextMode);
      }
      if (mounted) {
        context.read<ScannerBloc>().add(const TorchToggled());
      }
    } catch (e) {
      if (mounted) {
        context.read<ScannerBloc>().add(ScannerError('Flash error: $e'));
      }
    }
  }

  void _showScannerInfo(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 32),
          child: GlassCard(
            radius: 24,
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.auto_awesome_outlined,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Text('AI Scanner', style: AppTextStyles.heading3),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Capture an image of waste to receive AI-powered sorting guidance and disposal advice.',
                  style: AppTextStyles.bodySecondary.copyWith(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    child: const Text('Got it'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ScannerBloc, ScannerState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) async {
        if (state.status == ScannerStatus.success && state.result != null) {
          _showResultBottomSheet(context, state.result!);
        } else if (state.status == ScannerStatus.error &&
            state.errorMessage.isNotEmpty) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
        }

      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            // 📸 Camera Preview Layer
            _buildCameraPreview(),

            // 🟢 Overlay UI elements
            _buildOverlay(context),

            // 🔘 Scan Button
            _buildScanButton(context),

            _buildTorchControl(),

            _buildBottomControls(),

            // Torch control

            // 📦 Bottom control panel
          ],
        ),
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
          final preview = CameraPreview(_controller!);
          final aspectRatio = _controller!.value.aspectRatio;

          return LayoutBuilder(
            builder: (context, constraints) {
              final previewHeight = constraints.maxWidth * aspectRatio;

              return ClipRect(
                child: OverflowBox(
                  alignment: Alignment.center,
                  minWidth: constraints.maxWidth,
                  maxWidth: constraints.maxWidth,
                  minHeight: previewHeight,
                  maxHeight: previewHeight,
                  child: SizedBox(
                    width: constraints.maxWidth,
                    height: previewHeight,
                    child: preview,
                  ),
                ),
              );
            },
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
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                    size: 20,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                Text(
                  'AI Scanner',
                  style: AppTextStyles.heading2.copyWith(color: Colors.white),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () => _showScannerInfo(context),
                      icon: const Icon(
                        Icons.help_outline,
                        color: Colors.white,
                        size: 20,
                      ),
                      visualDensity: VisualDensity.compact,
                      splashRadius: 20,
                    ),
                    SizedBox(width: 16),
                    Icon(Icons.more_vert, color: Colors.white, size: 20),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Status Label
          GlassCard(
            radius: 20,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
              child: Container(height: thickness, color: color),
            ),
            // Vertical line
            Positioned(
              left: alignment.x == -1 ? 0 : null,
              right: alignment.x == 1 ? 0 : null,
              top: 0,
              bottom: 0,
              child: Container(width: thickness, color: color),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScanButton(BuildContext context) {
    return BlocBuilder<ScannerBloc, ScannerState>(
      builder: (context, state) {
        final isLoading = state.status == ScannerStatus.loading;

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
                color: Colors.white.withValues(alpha: 0.18),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.35),
                  width: 4,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: ElevatedButton(
                  onPressed: isLoading ? null : _takePicture,
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.all(16),
                    elevation: 0,
                  ),
                  child: isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 32,
                        ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTorchControl() {
    return Positioned(
      bottom: 136,
      left: 0,
      right: 0,
      child: Center(
        child: SizedBox(
          width: 180,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _buildTorchButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomControls() {
    return const SizedBox.shrink();
  }

  Widget _buildTorchButton() {
    return BlocBuilder<ScannerBloc, ScannerState>(
      builder: (context, state) {
        return _buildControlButton(
          state.isTorchOn ? Icons.flash_on : Icons.flash_off_outlined,
          _toggleTorch,
          color: state.isTorchOn ? AppColors.primary : Colors.white,
        );
      },
    );
  }

  Widget _buildControlButton(
    IconData icon,
    VoidCallback onPressed, {
    Color color = Colors.white,
  }) {
    return IconButton(
      icon: Icon(icon, color: color, size: 24),
      onPressed: onPressed,
    );
  }

  void _showResultBottomSheet(
    BuildContext context,
    ScannerResultEntity result,
  ) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        final l10n = AppLocalizations.of(sheetContext);
        final confidence = result.confidence == null
            ? 'N/A'
            : '${(result.confidence! <= 1 ? result.confidence! * 100 : result.confidence!).toStringAsFixed(1)}%';

        return SafeArea(
          child: GlassCard(
            radius: 24,
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.scanResult, style: AppTextStyles.heading2),
                const SizedBox(height: 12),
                Text('${l10n.itemLabel}: ${result.label}', style: AppTextStyles.body),
                const SizedBox(height: 8),
                Text(
                  '${l10n.confidenceLabel}: $confidence',
                  style: AppTextStyles.bodySecondary,
                ),
                if (result.category != null && result.category!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    '${l10n.category}: ${result.category!}',
                    style: AppTextStyles.bodySecondary,
                  ),
                ],
                if (result.disposalAdvice != null &&
                    result.disposalAdvice!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    '${l10n.adviceLabel}: ${result.disposalAdvice!}',
                    style: AppTextStyles.bodySecondary,
                  ),
                ],
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(sheetContext),
                    child: Text(l10n.close),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
