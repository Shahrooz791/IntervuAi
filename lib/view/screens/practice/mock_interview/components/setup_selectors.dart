import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intervu_ai/controllers/mock_interview_controller.dart';
import 'package:intervu_ai/core/constants/app_colors.dart';
import 'package:intervu_ai/core/utils/size_utils.dart';
import 'package:intervu_ai/view/widgets/app_text.dart';

class SetupTargetRoleSelector extends StatelessWidget {
  const SetupTargetRoleSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<MockInterviewController>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SetupSectionLabel(label: 'TARGET ROLE'),
        Gap.v(10),
        Obx(() => SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: ctrl.roles.map((role) {
              final isSelected = ctrl.selectedRole.value == role;
              return GestureDetector(
                onTap: () => ctrl.selectRole(role),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: EdgeInsets.only(right: 8.h),
                  padding: EdgeInsets.symmetric(
                      horizontal: 16.h, vertical: 9.v),
                  decoration: BoxDecoration(
                    borderRadius: 100.r,
                    gradient: isSelected ? AppColors.primaryGradient : null,
                    color: isSelected ? null : AppColors.darkCard,
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primaryBlue
                          : AppColors.darkCardBorder,
                    ),
                    boxShadow: isSelected
                        ? [
                      BoxShadow(
                        color: AppColors.primaryBlue.withOpacity(0.3),
                        blurRadius: 10.h,
                      ),
                    ]
                        : [],
                  ),
                  child: AppText(
                    text: role,
                    fontSize: 13.fSize,
                    fontWeight: FontWeight.w700,
                    color: isSelected
                        ? AppColors.white
                        : AppColors.textSecondary,
                  ),
                ),
              );
            }).toList(),
          ),
        )),
      ],
    );
  }
}

class SetupDurationAndLevel extends StatelessWidget {
  const SetupDurationAndLevel({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<MockInterviewController>();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SetupSectionLabel(label: 'SESSION LENGTH'),
              Gap.v(10),
              Obx(() => Row(
                children: ctrl.durations.map((dur) {
                  final isSelected = ctrl.selectedDuration.value == dur;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => ctrl.selectDuration(dur),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: EdgeInsets.only(
                          right: dur != ctrl.durations.last ? 6.h : 0,
                        ),
                        padding: EdgeInsets.symmetric(vertical: 10.v),
                        decoration: BoxDecoration(
                          borderRadius: 10.r,
                          gradient:
                          isSelected ? AppColors.primaryGradient : null,
                          color: isSelected ? null : AppColors.darkCard,
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primaryBlue
                                : AppColors.darkCardBorder,
                          ),
                        ),
                        child: Center(
                          child: AppText(
                            text: dur,
                            fontSize: 13.fSize,
                            fontWeight: FontWeight.w700,
                            color: isSelected
                                ? AppColors.white
                                : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              )),
            ],
          ),
        ),
        Gap.h(16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SetupSectionLabel(label: 'DIFFICULTY'),
              Gap.v(10),
              Obx(() => Row(
                children: ctrl.levels.map((level) {
                  final isSelected = ctrl.selectedLevel.value == level;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => ctrl.selectLevel(level),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: EdgeInsets.only(
                          right: level != ctrl.levels.last ? 6.h : 0,
                        ),
                        padding: EdgeInsets.symmetric(vertical: 10.v),
                        decoration: BoxDecoration(
                          borderRadius: 10.r,
                          gradient:
                          isSelected ? AppColors.primaryGradient : null,
                          color: isSelected ? null : AppColors.darkCard,
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primaryBlue
                                : AppColors.darkCardBorder,
                          ),
                        ),
                        child: Center(
                          child: AppText(
                            text: level,
                            fontSize: 11.fSize,
                            fontWeight: FontWeight.w700,
                            color: isSelected
                                ? AppColors.white
                                : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              )),
            ],
          ),
        ),
      ],
    );
  }
}

class _SetupSectionLabel extends StatelessWidget {
  final String label;
  const _SetupSectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return AppText(
      text: label,
      fontSize: 11.fSize,
      fontWeight: FontWeight.w700,
      color: AppColors.textMuted,
    );
  }
}
