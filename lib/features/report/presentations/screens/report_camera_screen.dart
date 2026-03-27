import 'package:camera/camera.dart';
import 'package:ecosyncai/core/themes/app_color.dart';
import 'package:ecosyncai/core/themes/app_text_styles.dart';
import 'package:ecosyncai/features/report/presentations/bloc/report/report_bloc.dart';
import 'package:ecosyncai/features/report/presentations/bloc/report/report_event.dart';
import 'package:ecosyncai/features/report/presentations/bloc/report/report_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReportCameraScreen extends StatefulWidget {
  const ReportCameraScreen({super.key});

  @override
  State<ReportCameraScreen> createState() => _ReportCameraScreenState();
}

class _ReportCameraScreenState extends State<ReportCameraScreen> {
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
      if (cameras.isEmpty) return;

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
      debugPrint('Camera initialization error: $e');
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
    if (_controller == null || !_controller!.value.isInitialized) return;

    try {
      await _initializeControllerFuture;
      final image = await _controller!.takePicture();
      if (mounted) {
        Navigator.pop(context, image.path);
      }
    } catch (e) {
      debugPrint('Capture error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ReportBloc, ReportState>(
      listenWhen: (previous, current) => previous.isTorchOn != current.isTorchOn,
      listener: (context, state) async {
        if (_controller != null && _controller!.value.isInitialized) {
          try {
            await _controller!.setFlashMode(
              state.isTorchOn ? FlashMode.torch : FlashMode.off,
            );
          } catch (_) {}
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            // 📸 Camera Preview
            _buildCameraPreview(),

            // 🟢 Overlay UI
            _buildOverlay(context),

            // 🔘 Capture Button
            _buildCaptureButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildCameraPreview() {
    if (_controller == null || _initializeControllerFuture == null) {
      return const Center(child: CircularProgressIndicator(color: AppColors.primary));
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
          return const Center(child: CircularProgressIndicator(color: AppColors.primary));
        }
      },
    );
  }

  Widget _buildOverlay(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 28),
                  onPressed: () => Navigator.pop(context),
                ),
                Text(
                  'Capture Issue',
                  style: AppTextStyles.heading2.copyWith(color: Colors.white),
                ),
                BlocBuilder<ReportBloc, ReportState>(
                  builder: (context, state) {
                    return IconButton(
                      icon: Icon(
                        state.isTorchOn ? Icons.flash_on : Icons.flash_off,
                        color: state.isTorchOn ? AppColors.primary : Colors.white,
                        size: 24,
                      ),
                      onPressed: () => context.read<ReportBloc>().add(const ToggleReportTorchEvent()),
                    );
                  },
                ),
              ],
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Focus on the issue clearly',
              style: AppTextStyles.bodySecondary.copyWith(color: Colors.white),
            ),
          ),
          const SizedBox(height: 120),
        ],
      ),
    );
  }

  Widget _buildCaptureButton() {
    return Positioned(
      bottom: 40,
      left: 0,
      right: 0,
      child: Center(
        child: GestureDetector(
          onTap: _takePicture,
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
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: const Icon(Icons.camera_alt, color: AppColors.primary, size: 32),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
