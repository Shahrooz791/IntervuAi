import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intervu_ai/controllers/mock_interview_controller.dart';
import 'package:intervu_ai/core/constants/app_colors.dart';
import 'package:intervu_ai/core/utils/size_utils.dart';
import 'package:intervu_ai/view/widgets/app_text.dart';

class SetupQuestionTypes extends StatelessWidget {
  const SetupQuestionTypes({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<MockInterviewController>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          text: 'QUESTION TYPES',
          fontSize: 11.fSize,
          fontWeight: FontWeight.w700,
          color: AppColors.textMuted,
        ),
        Gap.v(10),
        Obx(() => GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10.h,
            mainAxisSpacing: 10.h,
            childAspectRatio: 3.2,
          ),
          itemCount: ctrl.questionTypes.length,
          itemBuilder: (_, i) {
            final type = ctrl.questionTypes[i];
            final label = type['label'] as String;
            final icon = type['icon'] as IconData;
            final isSelected = ctrl.selectedQuestionTypes.contains(label);
            return GestureDetector(
              onTap: () => ctrl.toggleQuestionType(label),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(
                    horizontal: 12.h, vertical: 8.v),
                decoration: BoxDecoration(
                  borderRadius: 12.r,
                  color: isSelected
                      ? AppColors.iconBgBlue
                      : AppColors.darkCard,
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primaryBlue.withOpacity(0.6)
                        : AppColors.darkCardBorder,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(icon,
                        size: 16.h,
                        color: isSelected
                            ? AppColors.primaryCyan
                            : AppColors.textMuted),
                    Gap.h(8),
                    AppText(
                      text: label,
                      fontSize: 13.fSize,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? AppColors.primaryCyan
                          : AppColors.textSecondary,
                    ),
                  ],
                ),
              ),
            );
          },
        )),
      ],
    );
  }
}
