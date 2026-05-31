import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intervu_ai/controllers/profile_controller.dart';
import 'package:intervu_ai/core/constants/app_colors.dart';
import 'package:intervu_ai/core/utils/size_utils.dart';
import 'package:intervu_ai/view/widgets/app_text.dart';

class EditProfileExpSelector extends StatelessWidget {
  final ProfileController ctrl;
  const EditProfileExpSelector({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          text: 'EXPERIENCE LEVEL (YEARS)',
          fontSize: 11.fSize,
          fontWeight: FontWeight.w700,
          color: AppColors.textMuted,
        ),
        Gap.v(10),
        Obx(() => Row(
          children: ctrl.experienceOptions.map((opt) {
            final isSelected = ctrl.selectedExpLevel.value == opt;
            return Expanded(
              child: GestureDetector(
                onTap: () => ctrl.selectExpLevel(opt),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: EdgeInsets.only(
                    right: opt != ctrl.experienceOptions.last ? 8.h : 0,
                  ),
                  padding: EdgeInsets.symmetric(vertical: 10.v),
                  decoration: BoxDecoration(
                    borderRadius: 100.r,
                    color: isSelected
                        ? Colors.transparent
                        : AppColors.darkCard,
                    gradient: isSelected
                        ? AppColors.primaryGradient
                        : null,
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primaryBlue
                          : AppColors.darkCardBorder,
                    ),
                    boxShadow: isSelected
                        ? [
                      BoxShadow(
                        color:
                        AppColors.primaryBlue.withOpacity(0.3),
                        blurRadius: 10.h,
                      ),
                    ]
                        : [],
                  ),
                  child: Center(
                    child: AppText(
                      text: opt,
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
    );
  }
}

class EditProfileRoleSelector extends StatelessWidget {
  final ProfileController ctrl;
  const EditProfileRoleSelector({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          text: 'TARGET ROLE',
          fontSize: 11.fSize,
          fontWeight: FontWeight.w700,
          color: AppColors.textMuted,
        ),
        Gap.v(10),
        Obx(() => Wrap(
          spacing: 8.h,
          runSpacing: 8.v,
          children: ctrl.targetRoles.map((role) {
            final isSelected = ctrl.selectedTargetRole.value == role;
            return GestureDetector(
              onTap: () => ctrl.selectTargetRole(role),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(
                    horizontal: 16.h, vertical: 9.v),
                decoration: BoxDecoration(
                  borderRadius: 100.r,
                  gradient:
                  isSelected ? AppColors.primaryGradient : null,
                  color: isSelected ? null : AppColors.darkCard,
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primaryBlue
                        : AppColors.darkCardBorder,
                  ),
                  boxShadow: isSelected
                      ? [
                    BoxShadow(
                      color: AppColors.primaryBlue
                          .withOpacity(0.3),
                      blurRadius: 10.h,
                    ),
                  ]
                      : [],
                ),
                child: AppText(
                  text: role,
                  fontSize: 13.fSize,
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? AppColors.white
                      : AppColors.textSecondary,
                ),
              ),
            );
          }).toList(),
        )),
      ],
    );
  }
}
