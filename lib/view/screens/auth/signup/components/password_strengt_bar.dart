import 'package:flutter/material.dart';
import 'package:intervu_ai/core/constants/app_colors.dart';
import 'package:intervu_ai/core/utils/size_utils.dart';
import 'package:intervu_ai/view/widgets/app_text.dart';

class PasswordStrengthBar extends StatelessWidget {
  final int strength;
  const PasswordStrengthBar({super.key, required this.strength});

  Color get _barColor {
    switch (strength) {
      case 1:
        return AppColors.errorRed;
      case 2:
        return AppColors.warningAmber;
      case 3:
        return AppColors.primaryBlue;
      case 4:
        return AppColors.successGreen;
      default:
        return AppColors.darkCardBorder;
    }
  }

  String get _label {
    switch (strength) {
      case 1:
        return 'Weak';
      case 2:
        return 'Fair';
      case 3:
        return 'Good';
      case 4:
        return 'Strong';
      default:
        return '-';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(4, (i) {
            final filled = i < strength;
            return Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: EdgeInsets.only(right: i < 3 ? 4.h : 0),
                height: 3.v,
                decoration: BoxDecoration(
                  borderRadius: 100.r,
                  color: filled ? _barColor : AppColors.darkCardBorder,
                  boxShadow: filled
                      ? [
                    BoxShadow(
                      color: _barColor.withOpacity(0.4),
                      blurRadius: 4.h,
                    ),
                  ]
                      : null,
                ),
              ),
            );
          }),
        ),
        Gap.v(6),
        AppText(
          text: 'Strength: $_label',
          fontSize: 12.fSize,
          color: strength == 0 ? AppColors.textMuted : _barColor,
          fontWeight: FontWeight.w500,
        ),
      ],
    );
  }
}
