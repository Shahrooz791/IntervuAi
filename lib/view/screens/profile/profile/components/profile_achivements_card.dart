import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intervu_ai/controllers/profile_controller.dart';
import 'package:intervu_ai/core/constants/app_colors.dart';
import 'package:intervu_ai/core/utils/size_utils.dart';
import 'package:intervu_ai/view/widgets/app_text.dart';

class ProfileAchievementsCard extends StatelessWidget {
  final ProfileController ctrl;

  const ProfileAchievementsCard({super.key, required this.ctrl});

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
              Container(
                width: 36.h,
                height: 36.h,
                decoration: BoxDecoration(
                  borderRadius: 10.r,
                  color: AppColors.iconBgOrange,
                ),
                child: Icon(Icons.emoji_events_rounded,
                    color: AppColors.warningAmber, size: 18.h),
              ),
              Gap.h(10),
              AppText(
                text: 'Achievements',
                fontSize: 15.fSize,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
              Gap.h(8),
              const Icon(Icons.verified_rounded,
                  color: AppColors.primaryCyan, size: 16),
              const Icon(Icons.emoji_events_outlined,
                  color: AppColors.warningAmber, size: 16),
              const Icon(Icons.star_rounded,
                  color: AppColors.accentPurple, size: 16),
              const Spacer(),
              Obx(() => AppText(
                text:
                '${ctrl.achievementsUnlocked.value} / ${ctrl.totalAchievements.value} BADGES',
                fontSize: 11.fSize,
                fontWeight: FontWeight.w600,
                color: AppColors.textMuted,
              )),
            ],
          ),
          Gap.v(14),
          Obx(() {
            final progress = ctrl.achievementsUnlocked.value /
                ctrl.totalAchievements.value;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: 100.r,
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 6.v,
                    backgroundColor: AppColors.progressBg,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.primaryCyan),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}
