import 'package:flutter/material.dart';
import 'package:intervu_ai/core/constants/app_colors.dart';
import 'package:intervu_ai/core/utils/size_utils.dart';
import 'package:intervu_ai/view/widgets/app_text.dart';

enum AppButtonType { primary, secondary, outline, danger }

class AppButton extends StatefulWidget {
  final String text;
  final VoidCallback? onTap;
  final AppButtonType type;
  final double? width;
  final double? height;
  final double? fontSize;
  final bool isLoading;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  const AppButton({
    super.key,
    required this.text,
    this.onTap,
    this.type = AppButtonType.primary,
    this.width,
    this.height,
    this.fontSize,
    this.isLoading = false,
    this.prefixIcon,
    this.suffixIcon,
  });

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _pressCtrl;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _pressCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _pressCtrl, curve: Curves.easeIn),
    );
  }

  @override
  void dispose() {
    _pressCtrl.dispose();
    super.dispose();
  }

  bool get _isDisabled => widget.onTap == null || widget.isLoading;

  Gradient? get _gradient {
    if (_isDisabled) return null;
    switch (widget.type) {
      case AppButtonType.primary:
        return AppColors.primaryGradient;
      default:
        return null;
    }
  }

  Color get _bgColor {
    if (_isDisabled) return AppColors.darkCard;
    switch (widget.type) {
      case AppButtonType.primary:
        return Colors.transparent;
      case AppButtonType.secondary:
        return AppColors.darkCardBorder;
      case AppButtonType.outline:
        return Colors.transparent;
      case AppButtonType.danger:
        return AppColors.errorRed.withOpacity(0.15);
    }
  }

  Color get _textColor {
    if (_isDisabled) return AppColors.textMuted;
    switch (widget.type) {
      case AppButtonType.primary:
        return AppColors.textPrimary;
      case AppButtonType.secondary:
        return AppColors.textSecondary;
      case AppButtonType.outline:
        return AppColors.primaryCyan;
      case AppButtonType.danger:
        return AppColors.errorRed;
    }
  }

  Border? get _border {
    switch (widget.type) {
      case AppButtonType.outline:
        return Border.all(
          color: _isDisabled
              ? AppColors.darkCardBorder
              : AppColors.primaryCyan.withOpacity(0.6),
        );
      case AppButtonType.danger:
        return Border.all(color: AppColors.errorRed.withOpacity(0.4));
      default:
        return null;
    }
  }

  List<BoxShadow>? get _shadows {
    if (_isDisabled || widget.type != AppButtonType.primary) return null;
    return [
      BoxShadow(
        color: AppColors.primaryBlue.withOpacity(0.35),
        blurRadius: 20.h,
        offset: Offset(0, 8.v),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _isDisabled ? null : (_) => _pressCtrl.forward(),
      onTapUp: _isDisabled
          ? null
          : (_) {
        _pressCtrl.reverse();
        widget.onTap?.call();
      },
      onTapCancel: () => _pressCtrl.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnim,
        builder: (_, __) => Transform.scale(
          scale: _scaleAnim.value,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: widget.width ?? double.infinity,
            height: widget.height ?? 56.v,
            decoration: BoxDecoration(
              borderRadius: 100.r,
              gradient: _gradient,
              color: _gradient == null ? _bgColor : null,
              border: _border,
              boxShadow: _shadows,
            ),
            child: Center(
              child: widget.isLoading
                  ? SizedBox(
                width: 22.h,
                height: 22.h,
                child: const CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: AppColors.textPrimary,
                ),
              )
                  : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.prefixIcon != null) ...[
                    widget.prefixIcon!,
                    Gap.h(8),
                  ],
                  AppText(
                    text: widget.text,
                    fontSize: widget.fontSize ?? 16.fSize,
                    fontWeight: FontWeight.w700,
                    color: _textColor,
                    height: 1.0,
                  ),
                  if (widget.suffixIcon != null) ...[
                    Gap.h(8),
                    widget.suffixIcon!,
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}