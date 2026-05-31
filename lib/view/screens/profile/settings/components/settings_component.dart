import 'package:flutter/material.dart';
import 'package:intervu_ai/core/constants/app_colors.dart';
import 'package:intervu_ai/core/utils/size_utils.dart';
import 'package:intervu_ai/view/widgets/app_text.dart';

class SettingsSectionLabel extends StatelessWidget {
  final String label;
  const SettingsSectionLabel({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return AppText(
      text: label,
      fontSize: 11.fSize,
      fontWeight: FontWeight.w700,
      color: AppColors.textMuted,
    );
  }
}

class SettingsGroup extends StatelessWidget {
  final List<Widget> items;
  const SettingsGroup({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: 16.r,
        color: AppColors.darkCard,
        border: Border.all(color: AppColors.darkCardBorder),
      ),
      child: Column(children: items),
    );
  }
}

class SettingsRow extends StatefulWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final Color titleColor;
  final String? trailing;
  final VoidCallback onTap;
  final bool isLast;
  final bool showExternal;

  const SettingsRow({
    super.key,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    this.titleColor = AppColors.textPrimary,
    this.trailing,
    required this.onTap,
    this.isLast = false,
    this.showExternal = false,
  });

  @override
  State<SettingsRow> createState() => _SettingsRowState();
}

class _SettingsRowState extends State<SettingsRow> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        decoration: BoxDecoration(
          borderRadius: widget.isLast
              ? BorderRadius.only(
            bottomLeft: Radius.circular(16.h),
            bottomRight: Radius.circular(16.h),
          )
              : null,
          color: _pressed ? AppColors.shimmer : Colors.transparent,
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 14.h, vertical: 13.v),
              child: Row(
                children: [
                  Container(
                    width: 36.h,
                    height: 36.h,
                    decoration: BoxDecoration(
                      borderRadius: 10.r,
                      color: widget.iconBg,
                    ),
                    child: Icon(widget.icon,
                        color: widget.iconColor, size: 18.h),
                  ),
                  Gap.h(12),
                  Expanded(
                    child: AppText(
                      text: widget.title,
                      fontSize: 14.fSize,
                      fontWeight: FontWeight.w600,
                      color: widget.titleColor,
                    ),
                  ),
                  if (widget.trailing != null) ...[
                    AppText(
                      text: widget.trailing!,
                      fontSize: 12.fSize,
                      color: AppColors.textSecondary,
                      textAlign: TextAlign.right,
                    ),
                    Gap.h(6),
                  ],
                  Icon(
                    widget.showExternal
                        ? Icons.open_in_new_rounded
                        : Icons.chevron_right_rounded,
                    color: AppColors.textMuted,
                    size: 18.h,
                  ),
                ],
              ),
            ),
            if (!widget.isLast)
              Container(
                height: 1,
                margin: EdgeInsets.only(left: 62.h),
                color: AppColors.divider,
              ),
          ],
        ),
      ),
    );
  }
}

class SettingsToggleRow extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool isLast;

  const SettingsToggleRow({
    super.key,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.h, vertical: 13.v),
          child: Row(
            children: [
              Container(
                width: 36.h,
                height: 36.h,
                decoration: BoxDecoration(
                  borderRadius: 10.r,
                  color: iconBg,
                ),
                child: Icon(icon, color: iconColor, size: 18.h),
              ),
              Gap.h(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      text: title,
                      fontSize: 14.fSize,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    if (subtitle != null) ...[
                      Gap.v(2),
                      AppText(
                        text: subtitle!,
                        fontSize: 11.fSize,
                        color: AppColors.textMuted,
                      ),
                    ],
                  ],
                ),
              ),
              _GlowToggle(value: value, onChanged: onChanged),
            ],
          ),
        ),
        if (!isLast)
          Container(
            height: 1,
            margin: EdgeInsets.only(left: 62.h),
            color: AppColors.divider,
          ),
      ],
    );
  }
}

class _GlowToggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  const _GlowToggle({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: 44.h,
        height: 24.v,
        decoration: BoxDecoration(
          borderRadius: 100.r,
          color: value ? AppColors.toggleActive : AppColors.toggleInactive,
          boxShadow: value
              ? [
            BoxShadow(
              color: AppColors.primaryBlue.withOpacity(0.4),
              blurRadius: 8.h,
            ),
          ]
              : [],
        ),
        child: Padding(
          padding: EdgeInsets.all(2.h),
          child: AnimatedAlign(
            duration: const Duration(milliseconds: 250),
            alignment: value ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              width: 20.h,
              height: 20.h,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: AppColors.white),
            ),
          ),
        ),
      ),
    );
  }
}
