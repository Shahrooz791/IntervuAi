import 'package:flutter/material.dart';
import 'package:intervu_ai/core/constants/app_colors.dart';
import 'package:intervu_ai/core/constants/images_assets.dart';
import 'package:intervu_ai/core/utils/size_utils.dart';

class AuthLogo extends StatelessWidget {
  const AuthLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72.h,
      height: 72.h,
      decoration: BoxDecoration(
        borderRadius: 18.r,
        gradient: AppColors.logoGradient,
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlue.withOpacity(0.45),
            blurRadius: 28.h,
            spreadRadius: 3.h,
          ),
          BoxShadow(
            color: AppColors.primaryCyan.withOpacity(0.2),
            blurRadius: 50.h,
            spreadRadius: 6.h,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: 18.r,
        child: Image.asset(
          ImagesAssets.appLogo,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Center(
            child: Icon(
              Icons.chat_bubble_rounded,
              color: AppColors.white,
              size: 32.h,
            ),
          ),
        ),
      ),
    );
  }
}
