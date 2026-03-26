import 'dart:io';
import 'package:ecosyncai/core/themes/app_color.dart';
import 'package:ecosyncai/core/themes/app_text_styles.dart';
import 'package:ecosyncai/features/home/presentations/bloc/bin/bin_bloc.dart';
import 'package:ecosyncai/features/home/presentations/bloc/ward/ward_bloc.dart';
import 'package:ecosyncai/features/home/presentations/bloc/ward/ward_state.dart';
import 'package:ecosyncai/features/home/presentations/widgets/status_badge.dart';
import 'package:ecosyncai/features/report/presentations/bloc/report/report_bloc.dart';
import 'package:ecosyncai/features/report/presentations/bloc/report/report_event.dart';
import 'package:ecosyncai/features/report/presentations/bloc/report/report_state.dart';
import 'package:ecosyncai/features/report/presentations/screens/report_camera_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReportIssueScreen extends StatefulWidget {
  const ReportIssueScreen({super.key});

  @override
  State<ReportIssueScreen> createState() => _ReportIssueScreenState();
}

class _ReportIssueScreenState extends State<ReportIssueScreen> {
  final TextEditingController _ctrl = TextEditingController();
  int? _selectedWardId;

  @override
  void initState() {
    super.initState();
    // Pre-select ward if a bin is already selected
    final bin = context.read<BinBloc>().state.selectedBin;
    if (bin != null) {
      _selectedWardId = bin.wardId;
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _openCamera() async {
    final String? imagePath = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => const ReportCameraScreen()),
    );

    if (imagePath != null && mounted) {
      context.read<ReportBloc>().add(CaptureReportImageEvent(imagePath));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ReportBloc, ReportState>(
      listenWhen: (previous, current) =>
          previous.status != current.status &&
          current.status == ReportStatus.success,
      listener: (context, state) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.statusEmpty,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white, size: 18),
                const SizedBox(width: 8),
                Text(
                  'Complaint submitted successfully!',
                  style: AppTextStyles.body.copyWith(color: Colors.white),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () =>
                      ScaffoldMessenger.of(context).hideCurrentSnackBar(),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white70,
                    size: 16,
                  ),
                ),
              ],
            ),
          ),
        );
        Future.delayed(const Duration(milliseconds: 500), () {
          if (context.mounted) {
            context.read<ReportBloc>().add(const ReportReset());
            _ctrl.clear();
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          }
        });
      },
      child: BlocBuilder<ReportBloc, ReportState>(
        builder: (context, state) {
          final bin =
              state.selectedBin ??
              context.select((BinBloc bloc) => bloc.state.selectedBin);

          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              title: const Text('Report Issue'),
              leading: Navigator.canPop(context)
                  ? IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                      onPressed: () => Navigator.pop(context),
                    )
                  : null,
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Ward Selection Dropdown
                  Text('Select Ward', style: AppTextStyles.heading3),
                  const SizedBox(height: 8),
                  BlocBuilder<WardBloc, WardState>(
                    builder: (context, wardState) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.divider),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<int>(
                            value: _selectedWardId,
                            hint: Text(
                              'Select Ward',
                              style: AppTextStyles.bodySecondary,
                            ),
                            isExpanded: true,
                            icon: const Icon(
                              Icons.keyboard_arrow_down,
                              color: AppColors.textSecondary,
                            ),
                            items: wardState.wards.map((ward) {
                              return DropdownMenuItem<int>(
                                value: ward.id,
                                child: Text(
                                  ward.name,
                                  style: AppTextStyles.body,
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedWardId = value;
                              });
                            },
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  if (bin != null) ...[
                    Text('Selected Bin', style: AppTextStyles.heading3),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.cardBackground,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.divider),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.primaryLight.withValues(
                                alpha: 0.3,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.delete_outline,
                              color: AppColors.primary,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(bin.id, style: AppTextStyles.heading3),
                                    const SizedBox(width: 8),
                                    StatusBadge(
                                      status: bin.status,
                                      small: true,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  bin.address,
                                  style: AppTextStyles.bodySecondary,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                  Text('Describe the Issue', style: AppTextStyles.heading3),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _ctrl,
                    maxLines: 5,
                    onChanged: (value) => context.read<ReportBloc>().add(
                      ReportDescriptionChanged(value),
                    ),
                    style: AppTextStyles.body,
                    decoration: const InputDecoration(
                      hintText: 'e.g., Bin is overflowing...',
                      alignLabelWithHint: true,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text('Add Photo', style: AppTextStyles.heading3),
                  const SizedBox(height: 8),
                  _buildPhotoSection(state),
                  const SizedBox(height: 20),
                  if (state.hasImage && state.aiLabel.isNotEmpty)
                    _AiLabelChip(label: state.aiLabel),
                  const SizedBox(height: 28),
                  ElevatedButton(
                    onPressed: state.status == ReportStatus.submitting
                        ? null
                        : () {
                            if (_selectedWardId == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text(
                                    'Please select a ward first',
                                  ),
                                  backgroundColor: AppColors.statusFull,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              );
                              return;
                            }
                            FocusScope.of(context).unfocus();
                            context.read<ReportBloc>().add(
                              const ReportSubmitted(),
                            );
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      disabledBackgroundColor: AppColors.primary.withValues(
                        alpha: 0.5,
                      ),
                    ),
                    child: state.status == ReportStatus.submitting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text('Submit Complaint'),
                  ),
                  const SizedBox(height: 16),
                  if (state.status == ReportStatus.error)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.statusFullBg,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: AppColors.statusFull,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              state.errorMessage,
                              style: AppTextStyles.bodySecondary.copyWith(
                                color: AppColors.statusFull,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPhotoSection(ReportState state) {
    if (state.capturedImagePath != null) {
      return _buildCapturedImagePreview(state);
    }

    return GestureDetector(
      onTap: _openCamera,
      child: Container(
        height: 130,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.4),
            style: BorderStyle.solid,
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.add_a_photo_outlined,
              size: 36,
              color: AppColors.primary,
            ),
            const SizedBox(height: 8),
            Text('Tap to take a photo', style: AppTextStyles.bodySecondary),
          ],
        ),
      ),
    );
  }

  Widget _buildCapturedImagePreview(ReportState state) {
    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        image: DecorationImage(
          image: FileImage(File(state.capturedImagePath!)),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: () => context.read<ReportBloc>().add(const ReportImageRemoved()),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 20),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: GestureDetector(
              onTap: _openCamera,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(14),
                    bottomRight: Radius.circular(14),
                  ),
                ),
                child: Center(
                  child: Text(
                    'Retake Photo',
                    style: AppTextStyles.body.copyWith(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AiLabelChip extends StatelessWidget {
  final String label;

  const _AiLabelChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.statusEmptyBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.statusEmpty.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.auto_awesome,
              color: AppColors.statusEmpty,
              size: 16,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTextStyles.body.copyWith(
                color: AppColors.statusEmpty,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.recycling, color: AppColors.statusEmpty, size: 16),
          ],
        ),
      ),
    );
  }
}
