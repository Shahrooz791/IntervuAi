import 'package:flutter/material.dart';
import 'package:intervu_ai/core/constants/app_colors.dart';
import 'package:intervu_ai/core/utils/size_utils.dart';
import 'package:intervu_ai/view/widgets/app_text.dart';

class AuthDivider extends StatelessWidget {
  final String label;
  const AuthDivider({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            color: AppColors.darkCardBorder,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.h),
          child: AppText(
            text: label,
            fontSize: 12.fSize,
            color: AppColors.textMuted,
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            color: AppColors.darkCardBorder,
          ),
        ),
      ],
    );
  }
}
