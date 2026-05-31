import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intervu_ai/controllers/profile_controller.dart';
import 'package:intervu_ai/core/constants/app_colors.dart';
import 'package:intervu_ai/core/utils/size_utils.dart';
import 'package:intervu_ai/view/widgets/app_button.dart';
import 'package:intervu_ai/view/widgets/app_text.dart';

class ProfileHeader extends StatelessWidget {
  final ProfileController ctrl;

  const ProfileHeader({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildAvatar(),
        Gap.v(14),
        Obx(() => AppText(
          text: ctrl.userName.value,
          fontSize: 22.fSize,
          fontWeight: FontWeight.w800,
          color: AppColors.textPrimary,
        )),
        Gap.v(4),
        Obx(() => AppText(
          text: ctrl.userRole.value,
          fontSize: 14.fSize,
          color: AppColors.textSecondary,
        )),
        Gap.v(10),
        Obx(() => Container(
          padding:
          EdgeInsets.symmetric(horizontal: 12.h, vertical: 5.v),
          decoration: BoxDecoration(
            borderRadius: 100.r,
            color: AppColors.iconBgBlue,
            border: Border.all(
                color: AppColors.primaryBlue.withOpacity(0.4)),
          ),
          child: AppText(
            text: ctrl.experienceLevel.value,
            fontSize: 11.fSize,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryCyan,
          ),
        )),
        Gap.v(18),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.h),
          child: AppButton(
            text: 'Edit Profile',
            type: AppButtonType.outline,
            height: 46.v,
            onTap: ctrl.onEditProfile,
          ),
        ),
      ],
    );
  }

  Widget _buildAvatar() {
    return Stack(
      children: [
        Container(
          width: 88.h,
          height: 88.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: AppColors.primaryGradient,
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryBlue.withOpacity(0.45),
                blurRadius: 20.h,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Center(
            child: Obx(() => AppText(
              text: ctrl.userInitials.value,
              fontSize: 28.fSize,
              fontWeight: FontWeight.w800,
              color: AppColors.white,
            )),
          ),
        ),
        Positioned(
          bottom: 2,
          right: 2,
          child: Container(
            width: 22.h,
            height: 22.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.successGreen,
              border: Border.all(color: AppColors.darkBg, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
