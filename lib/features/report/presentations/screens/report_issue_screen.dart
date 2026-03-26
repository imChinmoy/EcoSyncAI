import 'package:ecosyncai/core/themes/app_color.dart';
import 'package:ecosyncai/core/themes/app_text_styles.dart';
import 'package:ecosyncai/features/home/presentations/bloc/bin/bin_bloc.dart';
import 'package:ecosyncai/features/home/presentations/widgets/status_badge.dart';
import 'package:ecosyncai/features/report/presentations/bloc/report/report_bloc.dart';
import 'package:ecosyncai/features/report/presentations/bloc/report/report_event.dart';
import 'package:ecosyncai/features/report/presentations/bloc/report/report_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReportIssueScreen extends StatefulWidget {
  const ReportIssueScreen({super.key});

  @override
  State<ReportIssueScreen> createState() => _ReportIssueScreenState();
}

class _ReportIssueScreenState extends State<ReportIssueScreen> {
  final TextEditingController _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
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
                  child: const Icon(Icons.close, color: Colors.white70, size: 16),
                ),
              ],
            ),
          ),
        );
        Future.delayed(const Duration(milliseconds: 500), () {
          if (context.mounted) {
            context.read<ReportBloc>().add(const ReportReset());
            _ctrl.clear();
            Navigator.pop(context);
          }
        });
      },
      child: BlocBuilder<ReportBloc, ReportState>(
        builder: (context, state) {
          final bin =
              state.selectedBin ?? context.select((BinBloc bloc) => bloc.state.selectedBin);

          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              title: const Text('Report Issue'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (bin != null)
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
                              color: AppColors.primaryLight.withValues(alpha: 0.3),
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
                                    StatusBadge(status: bin.status, small: true),
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
                  Text('Describe the Issue', style: AppTextStyles.heading3),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _ctrl,
                    maxLines: 5,
                    onChanged: (value) => context
                        .read<ReportBloc>()
                        .add(ReportDescriptionChanged(value)),
                    style: AppTextStyles.body,
                    decoration: const InputDecoration(
                      hintText: 'e.g., Bin is overflowing...',
                      alignLabelWithHint: true,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text('Add Photo (Optional)', style: AppTextStyles.heading3),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => context
                        .read<ReportBloc>()
                        .add(const ReportMockImagePicked()),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: state.hasImage
                          ? _MockImagePreview(
                              onRemove: () => context
                                  .read<ReportBloc>()
                                  .add(const ReportImageRemoved()),
                            )
                          : _PhotoPickerPlaceholder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (state.hasImage && state.aiLabel.isNotEmpty)
                    _AiLabelChip(label: state.aiLabel),
                  const SizedBox(height: 28),
                  ElevatedButton(
                    onPressed: state.status == ReportStatus.submitting
                        ? null
                        : () {
                            FocusScope.of(context).unfocus();
                            context.read<ReportBloc>().add(const ReportSubmitted());
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      disabledBackgroundColor:
                          AppColors.primary.withValues(alpha: 0.5),
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
}

class _PhotoPickerPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey('placeholder'),
      width: double.infinity,
      height: 130,
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
            Icons.add_photo_alternate_outlined,
            size: 36,
            color: AppColors.primary,
          ),
          const SizedBox(height: 6),
          Text('Tap to add photo', style: AppTextStyles.bodySecondary),
        ],
      ),
    );
  }
}

class _MockImagePreview extends StatelessWidget {
  final VoidCallback onRemove;

  const _MockImagePreview({required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Stack(
      key: const ValueKey('preview'),
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Container(
            width: double.infinity,
            height: 180,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.grey.shade600,
                  Colors.grey.shade400,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.image_outlined, size: 48, color: Colors.white70),
                const SizedBox(height: 6),
                Text(
                  'Mock photo selected',
                  style: AppTextStyles.bodySecondary.copyWith(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: GestureDetector(
            onTap: onRemove,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, color: Colors.white, size: 16),
            ),
          ),
        ),
      ],
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
          border: Border.all(color: AppColors.statusEmpty.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.auto_awesome, color: AppColors.statusEmpty, size: 16),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTextStyles.body.copyWith(
                color: AppColors.statusEmpty,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            const Icon(Icons.recycling, color: AppColors.statusEmpty, size: 16),
          ],
        ),
      ),
    );
  }
}
