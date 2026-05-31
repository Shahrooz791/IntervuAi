import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intervu_ai/controllers/mock_interview_controller.dart';
import 'package:intervu_ai/core/constants/app_colors.dart';
import 'package:intervu_ai/core/utils/size_utils.dart';
import 'package:intervu_ai/view/widgets/app_text.dart';

class ResumeUploadZone extends StatefulWidget {
  final MockInterviewController ctrl;
  const ResumeUploadZone({super.key, required this.ctrl});

  @override
  State<ResumeUploadZone> createState() => _ResumeUploadZoneState();
}

class _ResumeUploadZoneState extends State<ResumeUploadZone>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseCtrl;
  late Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
    _pulse = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (widget.ctrl.isUploading.value) return _buildUploading();
      if (widget.ctrl.hasUploadedResume.value) return _buildUploaded();
      return _buildEmpty();
    });
  }

  Widget _buildEmpty() {
    return GestureDetector(
      onTap: widget.ctrl.onBrowseFile,
      child: AnimatedBuilder(
        animation: _pulse,
        builder: (_, __) => Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 32.v),
          decoration: BoxDecoration(
            borderRadius: 20.r,
            color: AppColors.darkCard,
            border: Border.all(
              color: AppColors.primaryBlue
                  .withOpacity(0.2 + 0.15 * _pulse.value),
              style: BorderStyle.solid,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color:
                AppColors.primaryBlue.withOpacity(0.04 + 0.04 * _pulse.value),
                blurRadius: 20.h,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 60.h,
                height: 60.h,
                decoration: BoxDecoration(
                  borderRadius: 16.r,
                  color: AppColors.iconBgBlue,
                ),
                child: Icon(Icons.upload_file_rounded,
                    color: AppColors.primaryCyan, size: 28.h),
              ),
              Gap.v(14),
              AppText(
                text: 'Upload Resume',
                fontSize: 16.fSize,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
              Gap.v(4),
              AppText(
                text: 'PDF or DOCX (Max 5MB)',
                fontSize: 12.fSize,
                color: AppColors.textMuted,
              ),
              Gap.v(16),
              Container(
                padding:
                EdgeInsets.symmetric(horizontal: 20.h, vertical: 10.v),
                decoration: BoxDecoration(
                  borderRadius: 12.r,
                  gradient: AppColors.primaryGradient,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryBlue.withOpacity(0.35),
                      blurRadius: 10.h,
                    ),
                  ],
                ),
                child: AppText(
                  text: 'Browse File',
                  fontSize: 13.fSize,
                  fontWeight: FontWeight.w700,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUploading() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 32.v),
      decoration: BoxDecoration(
        borderRadius: 20.r,
        color: AppColors.darkCard,
        border: Border.all(color: AppColors.darkCardBorder),
      ),
      child: Column(
        children: [
          SizedBox(
            width: 40.h,
            height: 40.h,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColors.primaryCyan),
            ),
          ),
          Gap.v(14),
          AppText(
            text: 'Analyzing your resume...',
            fontSize: 14.fSize,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          Gap.v(4),
          AppText(
            text: 'AI is extracting your skills and experience',
            fontSize: 12.fSize,
            color: AppColors.textMuted,
          ),
        ],
      ),
    );
  }

  Widget _buildUploaded() {
    return Container(
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        borderRadius: 16.r,
        color: AppColors.darkCard,
        border: Border.all(color: AppColors.successGreen.withOpacity(0.4)),
      ),
      child: Row(
        children: [
          Container(
            width: 44.h,
            height: 44.h,
            decoration: BoxDecoration(
              borderRadius: 12.r,
              color: AppColors.successGreen.withOpacity(0.12),
            ),
            child: Icon(Icons.picture_as_pdf_rounded,
                color: AppColors.successGreen, size: 22.h),
          ),
          Gap.h(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() => AppText(
                  text: widget.ctrl.uploadedFileName.value,
                  fontSize: 14.fSize,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                )),
                Gap.v(2),
                Row(
                  children: [
                    Obx(() => AppText(
                      text: widget.ctrl.uploadFileSize.value,
                      fontSize: 11.fSize,
                      color: AppColors.textMuted,
                    )),
                    Gap.h(8),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 6.h, vertical: 2.v),
                      decoration: BoxDecoration(
                        borderRadius: 100.r,
                        color: AppColors.successGreen.withOpacity(0.12),
                      ),
                      child: AppText(
                        text: 'AMAZING',
                        fontSize: 9.fSize,
                        fontWeight: FontWeight.w800,
                        color: AppColors.successGreen,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              widget.ctrl.hasUploadedResume.value = false;
              widget.ctrl.uploadedFileName.value = '';
            },
            child: Container(
              width: 32.h,
              height: 32.h,
              decoration: BoxDecoration(
                borderRadius: 8.r,
                color: AppColors.errorRed.withOpacity(0.1),
              ),
              child: Icon(Icons.close_rounded,
                  color: AppColors.errorRed, size: 16.h),
            ),
          ),
        ],
      ),
    );
  }
}
