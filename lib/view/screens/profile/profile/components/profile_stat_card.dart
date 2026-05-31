import 'package:flutter/material.dart';
import 'package:intervu_ai/core/constants/app_colors.dart';
import 'package:intervu_ai/core/utils/size_utils.dart';
import 'package:intervu_ai/view/widgets/app_text.dart';

class ProfileStatCard extends StatelessWidget {
  final String value;
  final String label;

  const ProfileStatCard({
    super.key,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14.v),
        decoration: BoxDecoration(
          borderRadius: 14.r,
          color: AppColors.darkCard,
          border: Border.all(color: AppColors.darkCardBorder),
        ),
        child: Column(
          children: [
            AppText(
              text: value,
              fontSize: 22.fSize,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
            Gap.v(4),
            AppText(
              text: label,
              fontSize: 10.fSize,
              fontWeight: FontWeight.w600,
              color: AppColors.textMuted,
            ),
          ],
        ),
      ),
    );
  }
}
