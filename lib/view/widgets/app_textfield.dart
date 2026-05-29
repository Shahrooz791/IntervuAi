import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intervu_ai/core/constants/app_colors.dart';
import 'package:intervu_ai/core/utils/size_utils.dart';

class AppTextField extends StatefulWidget {
  final String? hint;
  final String? label;
  final TextEditingController? controller;
  final bool isPassword;
  final TextInputType keyboardType;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final int? maxLines;
  final int? maxLength;
  final bool readOnly;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;

  const AppTextField({
    super.key,
    this.hint,
    this.label,
    this.controller,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.maxLines = 1,
    this.maxLength,
    this.readOnly = false,
    this.inputFormatters,
    this.focusNode,
    this.textInputAction,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _obscureText = true;
  bool _isFocused = false;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(() {
      if (mounted) setState(() => _isFocused = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    if (widget.focusNode == null) _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: TextStyle(
              fontSize: 13.fSize,
              fontWeight: FontWeight.w600,
              fontFamily: 'Urbanist',
              color: AppColors.textSecondary,
            ),
          ),
          Gap.v(8),
        ],
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            borderRadius: 14.r,
            color: AppColors.darkCard,
            border: Border.all(
              color: _isFocused
                  ? AppColors.primaryBlue.withOpacity(0.7)
                  : AppColors.darkCardBorder,
              width: _isFocused ? 1.5 : 1,
            ),
            boxShadow: _isFocused
                ? [
              BoxShadow(
                color: AppColors.primaryBlue.withOpacity(0.12),
                blurRadius: 12.h,
                spreadRadius: 1,
              ),
            ]
                : null,
          ),
          child: TextFormField(
            controller: widget.controller,
            focusNode: _focusNode,
            obscureText: widget.isPassword && _obscureText,
            keyboardType: widget.maxLines != null && widget.maxLines! > 1
                ? TextInputType.multiline
                : widget.keyboardType,
            maxLines: widget.isPassword ? 1 : widget.maxLines,
            maxLength: widget.maxLength,
            readOnly: widget.readOnly,
            inputFormatters: widget.inputFormatters,
            textInputAction: widget.textInputAction,
            validator: widget.validator,
            onChanged: widget.onChanged,
            onFieldSubmitted: widget.onSubmitted,
            style: TextStyle(
              fontSize: 15.fSize,
              fontWeight: FontWeight.w500,
              fontFamily: 'Urbanist',
              color: AppColors.textPrimary,
            ),
            cursorColor: AppColors.primaryCyan,
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: TextStyle(
                fontSize: 14.fSize,
                fontWeight: FontWeight.w400,
                fontFamily: 'Urbanist',
                color: AppColors.textMuted,
              ),
              counterText: '',
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.h,
                vertical: 16.v,
              ),
              border: InputBorder.none,
              prefixIcon: widget.prefixIcon != null
                  ? Padding(
                padding: EdgeInsets.only(left: 14.h, right: 10.h),
                child: widget.prefixIcon,
              )
                  : null,
              prefixIconConstraints: BoxConstraints(
                minWidth: 20.h,
                minHeight: 20.h,
              ),
              suffixIcon: widget.isPassword
                  ? GestureDetector(
                onTap: () =>
                    setState(() => _obscureText = !_obscureText),
                child: Padding(
                  padding: EdgeInsets.only(right: 14.h),
                  child: Icon(
                    _obscureText
                        ? Icons.visibility_off_rounded
                        : Icons.visibility_rounded,
                    color: _isFocused
                        ? AppColors.primaryCyan
                        : AppColors.textMuted,
                    size: 20.h,
                  ),
                ),
              )
                  : widget.suffixIcon != null
                  ? Padding(
                padding: EdgeInsets.only(right: 14.h),
                child: widget.suffixIcon,
              )
                  : null,
              suffixIconConstraints: BoxConstraints(
                minWidth: 20.h,
                minHeight: 20.h,
              ),
            ),
          ),
        ),
      ],
    );
  }
}