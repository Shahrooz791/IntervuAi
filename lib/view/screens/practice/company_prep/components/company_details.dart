import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intervu_ai/controllers/mock_interview_controller.dart';
import 'package:intervu_ai/core/constants/app_colors.dart';
import 'package:intervu_ai/core/utils/size_utils.dart';
import 'package:intervu_ai/view/widgets/app_text.dart';

class CompanyDetails extends StatelessWidget {
  final MockInterviewController ctrl;
  const CompanyDetails({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInterviewRounds(),
        Gap.v(20),
        _buildInsights(),
      ],
    );
  }

  Widget _buildInterviewRounds() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.route_rounded,
                color: AppColors.primaryCyan, size: 16.h),
            Gap.h(8),
            Obx(() => AppText(
              text: 'Interview Rounds',
              fontSize: 16.fSize,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            )),
          ],
        ),
        Gap.v(12),
        Container(
          decoration: BoxDecoration(
            borderRadius: 16.r,
            color: AppColors.darkCard,
            border: Border.all(color: AppColors.darkCardBorder),
          ),
          child: Column(
            children: ctrl.interviewRounds.asMap().entries.map((e) {
              final i = e.key;
              final round = e.value;
              final isLast = i == ctrl.interviewRounds.length - 1;
              return Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 14.h, vertical: 13.v),
                    child: Row(
                      children: [
                        Container(
                          width: 28.h,
                          height: 28.h,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.iconBgBlue,
                          ),
                          child: Center(
                            child: AppText(
                              text: '${i + 1}',
                              fontSize: 11.fSize,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primaryCyan,
                            ),
                          ),
                        ),
                        Gap.h(12),
                        Expanded(
                          child: AppText(
                            text: round,
                            fontSize: 14.fSize,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Icon(Icons.chevron_right_rounded,
                            color: AppColors.textMuted, size: 18.h),
                      ],
                    ),
                  ),
                  if (!isLast)
                    Container(
                      height: 1,
                      margin: EdgeInsets.only(left: 54.h),
                      color: AppColors.divider,
                    ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildInsights() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.lightbulb_outline_rounded,
                color: AppColors.warningAmber, size: 16.h),
            Gap.h(8),
            AppText(
              text: 'Company Insights',
              fontSize: 16.fSize,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ],
        ),
        Gap.v(12),
        Container(
          padding: EdgeInsets.all(16.h),
          decoration: BoxDecoration(
            borderRadius: 16.r,
            color: AppColors.darkCard,
            border: Border.all(color: AppColors.darkCardBorder),
          ),
          child: Column(
            children: ctrl.companyInsights.asMap().entries.map((e) {
              final isLast = e.key == ctrl.companyInsights.length - 1;
              return Padding(
                padding: EdgeInsets.only(bottom: isLast ? 0 : 12.v),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 5.v),
                      child: Container(
                        width: 5.h,
                        height: 5.h,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primaryCyan,
                        ),
                      ),
                    ),
                    Gap.h(10),
                    Expanded(
                      child: AppText(
                        text: e.value,
                        fontSize: 13.fSize,
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
