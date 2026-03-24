import 'package:ecosyncai/core/themes/app_color.dart';
import 'package:ecosyncai/core/themes/app_text_styles.dart';
import 'package:ecosyncai/features/home/presentations/providers/bin_provider.dart';
import 'package:ecosyncai/features/home/presentations/widgets/status_badge.dart';
import 'package:ecosyncai/features/report/presentations/providers/report_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    return Consumer<ReportProvider>(
      builder: (context, reportProv, _) {
        // After successful submission, show snackbar once
        if (reportProv.state == ReportState.success) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: AppColors.statusEmpty,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                content: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.white, size: 18),
                    const SizedBox(width: 8),
                    Text('Complaint submitted successfully!',
                        style: AppTextStyles.body.copyWith(color: Colors.white)),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
                      child: const Icon(Icons.close, color: Colors.white70, size: 16),
                    ),
                  ],
                ),
              ),
            );
            Future.delayed(const Duration(milliseconds: 500), () {
              if (context.mounted) {
                reportProv.reset();
                _ctrl.clear();
                Navigator.pop(context);
              }
            });
          });
        }

        final bin = reportProv.selectedBin ??
            context.read<BinProvider>().selectedBin;

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
                // ── Bin info card ─────────────────────────
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
                            color: AppColors.primaryLight.withOpacity(0.3),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.delete_outline,
                              color: AppColors.primary, size: 20),
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
                              Text(bin.address, style: AppTextStyles.bodySecondary,
                                  overflow: TextOverflow.ellipsis),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 20),

                // ── Description ────────────────────────────
                Text('Describe the Issue', style: AppTextStyles.heading3),
                const SizedBox(height: 8),
                TextField(
                  controller: _ctrl,
                  maxLines: 5,
                  onChanged: (v) => reportProv.setDescription(v),
                  style: AppTextStyles.body,
                  decoration: const InputDecoration(
                    hintText: 'e.g., Bin is overflowing...',
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: 20),

                // ── Photo picker ────────────────────────────
                Text('Add Photo (Optional)', style: AppTextStyles.heading3),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () => reportProv.pickMockImage(),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: reportProv.hasImage
                        ? _MockImagePreview(onRemove: reportProv.removeImage)
                        : _PhotoPickerPlaceholder(),
                  ),
                ),
                const SizedBox(height: 16),

                // ── AI Label ───────────────────────────────
                if (reportProv.hasImage && reportProv.aiLabel.isNotEmpty)
                  _AiLabelChip(label: reportProv.aiLabel),
                const SizedBox(height: 28),

                // ── Submit button ──────────────────────────
                ElevatedButton(
                  onPressed: reportProv.state == ReportState.submitting
                      ? null
                      : () {
                          FocusScope.of(context).unfocus();
                          reportProv.submitComplaint();
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    disabledBackgroundColor: AppColors.primary.withOpacity(0.5),
                  ),
                  child: reportProv.state == ReportState.submitting
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

                // ── Error message ─────────────────────────
                if (reportProv.state == ReportState.error)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.statusFullBg,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline,
                            color: AppColors.statusFull, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(reportProv.errorMessage,
                              style: AppTextStyles.bodySecondary
                                  .copyWith(color: AppColors.statusFull)),
                        ),
                      ],
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

// ── Photo Picker Placeholder ─────────────────────────────────────────────────
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
          color: AppColors.primary.withOpacity(0.4),
          style: BorderStyle.solid,
          width: 1.5,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.add_photo_alternate_outlined,
              size: 36, color: AppColors.primary),
          const SizedBox(height: 6),
          Text('Tap to add photo', style: AppTextStyles.bodySecondary),
        ],
      ),
    );
  }
}

// ── Mock Image Preview ──────────────────────────────────────────────────────
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
                  style: AppTextStyles.bodySecondary.copyWith(color: Colors.white70),
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

// ── AI Label Chip ─────────────────────────────────────────────────────────────
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
          border: Border.all(color: AppColors.statusEmpty.withOpacity(0.3)),
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
