import 'package:flutter/material.dart';
import 'package:intervu_ai/core/constants/app_colors.dart';
import 'package:intervu_ai/core/utils/size_utils.dart';
import 'package:intervu_ai/view/widgets/app_text.dart';

class TermsCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;

  const TermsCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 20.h,
            height: 20.h,
            decoration: BoxDecoration(
              borderRadius: 5.r,
              color: value ? AppColors.primaryBlue : Colors.transparent,
              border: Border.all(
                color: value
                    ? AppColors.primaryBlue
                    : AppColors.darkCardBorder,
                width: 1.5,
              ),
            ),
            child: value
                ? Icon(
              Icons.check_rounded,
              size: 13.h,
              color: AppColors.white,
            )
                : null,
          ),
          Gap.h(10),
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'I agree to the ',
                    style: TextStyle(
                      fontSize: 13.fSize,
                      fontFamily: 'Urbanist',
                      color: AppColors.textSecondary,
                    ),
                  ),
                  TextSpan(
                    text: 'Terms of Service',
                    style: TextStyle(
                      fontSize: 13.fSize,
                      fontFamily: 'Urbanist',
                      color: AppColors.primaryBlue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(
                    text: ' and ',
                    style: TextStyle(
                      fontSize: 13.fSize,
                      fontFamily: 'Urbanist',
                      color: AppColors.textSecondary,
                    ),
                  ),
                  TextSpan(
                    text: 'Privacy Policy',
                    style: TextStyle(
                      fontSize: 13.fSize,
                      fontFamily: 'Urbanist',
                      color: AppColors.primaryBlue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
