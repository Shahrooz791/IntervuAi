import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intervu_ai/controllers/mock_interview_controller.dart';
import 'package:intervu_ai/core/constants/app_colors.dart';
import 'package:intervu_ai/core/utils/size_utils.dart';
import 'package:intervu_ai/view/widgets/app_text.dart';

class ResumeQuestionPreview extends StatelessWidget {
  final MockInterviewController ctrl;
  const ResumeQuestionPreview({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        borderRadius: 16.r,
        color: AppColors.darkCard,
        border: Border.all(color: AppColors.darkCardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.quiz_outlined,
                  color: AppColors.primaryCyan, size: 16.h),
              Gap.h(8),
              AppText(
                text: 'Question Preview',
                fontSize: 14.fSize,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ],
          ),
          Gap.v(12),
          Container(
            padding: EdgeInsets.all(14.h),
            decoration: BoxDecoration(
              borderRadius: 12.r,
              color: AppColors.iconBgBlue,
              border: Border.all(
                  color: AppColors.primaryBlue.withOpacity(0.25)),
            ),
            child: Obx(() => AppText(
              text: ctrl.resumePreviewQuestion.value,
              fontSize: 13.fSize,
              color: AppColors.textSecondary,
              height: 1.5,
            )),
          ),
          Gap.v(12),
          Container(
            padding: EdgeInsets.all(14.h),
            decoration: BoxDecoration(
              borderRadius: 12.r,
              color: AppColors.darkBg,
              border: Border.all(color: AppColors.darkCardBorder),
            ),
            child: AppText(
              text:
              '"How have you managed state in your recent Dart projects? Tell me about a time you faced a complex state management challenge."',
              fontSize: 13.fSize,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
