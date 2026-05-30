import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intervu_ai/controllers/profile_controller.dart';
import 'package:intervu_ai/core/constants/app_colors.dart';
import 'package:intervu_ai/core/utils/size_utils.dart';
import 'package:intervu_ai/view/widgets/app_text.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _entryCtrl;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  final _ctrl = Get.put(ProfileController());

  @override
  void initState() {
    super.initState();
    _entryCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fade = CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOut);
    _slide =
        Tween<Offset>(begin: const Offset(0, 0.05), end: Offset.zero).animate(
          CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOut),
        );
    Future.delayed(const Duration(milliseconds: 80), () {
      if (mounted) _entryCtrl.forward();
    });
  }

  @override
  void dispose() {
    _entryCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fade,
          child: SlideTransition(
            position: _slide,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTopBar(),
                  _buildProfileHeader(),
                  Gap.v(24),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _SectionLabel(label: 'PREFERENCES'),
                        Gap.v(10),
                        _buildPreferences(),
                        Gap.v(24),
                        _SectionLabel(label: 'NOTIFICATIONS'),
                        Gap.v(10),
                        _buildNotifications(),
                        Gap.v(24),
                        _SectionLabel(label: 'APPEARANCE'),
                        Gap.v(10),
                        _buildAppearance(),
                        Gap.v(24),
                        _SectionLabel(label: 'SUPPORT'),
                        Gap.v(10),
                        _buildSupport(),
                        Gap.v(24),
                        _SectionLabel(label: 'ACCOUNT'),
                        Gap.v(10),
                        _buildAccount(),
                        Gap.v(40),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 12.v),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              width: 38.h,
              height: 38.h,
              decoration: BoxDecoration(
                borderRadius: 10.r,
                color: AppColors.darkCard,
                border: Border.all(color: AppColors.darkCardBorder),
              ),
              child: Icon(Icons.arrow_back_ios_new_rounded,
                  color: AppColors.textPrimary, size: 16.h),
            ),
          ),
          Gap.h(12),
          AppText(
            text: 'Settings',
            fontSize: 20.fSize,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
          const Spacer(),
          Container(
            width: 38.h,
            height: 38.h,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppColors.primaryGradient,
            ),
            child: Center(
              child: Obx(() => AppText(
                text: _ctrl.userInitials.value,
                fontSize: 13.fSize,
                fontWeight: FontWeight.w700,
                color: AppColors.white,
              )),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.h),
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        borderRadius: 18.r,
        color: AppColors.darkCard,
        border: Border.all(color: AppColors.darkCardBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 52.h,
            height: 52.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppColors.primaryGradient,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryBlue.withOpacity(0.3),
                  blurRadius: 12.h,
                ),
              ],
            ),
            child: Center(
              child: Obx(() => AppText(
                text: _ctrl.userInitials.value,
                fontSize: 18.fSize,
                fontWeight: FontWeight.w800,
                color: AppColors.white,
              )),
            ),
          ),
          Gap.h(14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() => AppText(
                  text: _ctrl.userName.value,
                  fontSize: 16.fSize,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                )),
                Gap.v(2),
                Obx(() => AppText(
                  text: _ctrl.userRole.value,
                  fontSize: 13.fSize,
                  color: AppColors.textSecondary,
                )),
              ],
            ),
          ),
          GestureDetector(
            onTap: _ctrl.onEditProfile,
            child: Container(
              padding:
              EdgeInsets.symmetric(horizontal: 14.h, vertical: 7.v),
              decoration: BoxDecoration(
                borderRadius: 10.r,
                border: Border.all(color: AppColors.darkCardBorder),
              ),
              child: AppText(
                text: 'Edit',
                fontSize: 13.fSize,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreferences() {
    return _SettingsGroup(items: [
      Obx(() => _SettingsRow(
        icon: Icons.work_outline_rounded,
        iconBg: AppColors.iconBgBlue,
        iconColor: AppColors.primaryBlue,
        title: 'Target Role',
        trailing: '${_ctrl.targetRole.value}\n${_ctrl.targetRoleSub.value}',
        onTap: _ctrl.onTargetRoleTap,
      )),
      Obx(() => _SettingsRow(
        icon: Icons.bolt_rounded,
        iconBg: AppColors.iconBgPurple,
        iconColor: AppColors.accentPurple,
        title: 'Interview Difficulty',
        trailing: _ctrl.difficulty.value,
        onTap: _ctrl.onDifficultyTap,
      )),
      Obx(() => _SettingsRow(
        icon: Icons.language_rounded,
        iconBg: AppColors.iconBgTeal,
        iconColor: AppColors.accentTeal,
        title: 'Language',
        trailing: _ctrl.language.value,
        onTap: _ctrl.onLanguageTap,
      )),
      Obx(() => _SettingsRow(
        icon: Icons.timer_outlined,
        iconBg: AppColors.iconBgBlue,
        iconColor: AppColors.primaryCyan,
        title: 'Session Length',
        trailing: _ctrl.sessionLength.value,
        onTap: _ctrl.onSessionLengthTap,
        isLast: true,
      )),
    ]);
  }

  Widget _buildNotifications() {
    return _SettingsGroup(items: [
      Obx(() => _ToggleRow(
        icon: Icons.alarm_rounded,
        iconBg: AppColors.iconBgBlue,
        iconColor: AppColors.primaryBlue,
        title: 'Daily Reminder',
        subtitle: 'Stay consistent with practice',
        value: _ctrl.dailyReminder.value,
        onChanged: _ctrl.toggleDailyReminder,
      )),
      Obx(() => _ToggleRow(
        icon: Icons.local_fire_department_rounded,
        iconBg: AppColors.iconBgOrange,
        iconColor: AppColors.orangeAccent,
        title: 'Streak Alert',
        value: _ctrl.streakAlert.value,
        onChanged: _ctrl.toggleStreakAlert,
      )),
      Obx(() => _ToggleRow(
        icon: Icons.email_outlined,
        iconBg: AppColors.iconBgGreen,
        iconColor: AppColors.successGreen,
        title: 'Result Emails',
        value: _ctrl.resultEmails.value,
        onChanged: _ctrl.toggleResultEmails,
        isLast: true,
      )),
    ]);
  }

  Widget _buildAppearance() {
    return _SettingsGroup(items: [
      Obx(() => _SettingsRow(
        icon: Icons.dark_mode_outlined,
        iconBg: AppColors.iconBgPurple,
        iconColor: AppColors.accentPurple,
        title: 'Theme',
        trailing: _ctrl.theme.value,
        onTap: _ctrl.onThemeTap,
        isLast: true,
      )),
    ]);
  }

  Widget _buildSupport() {
    return _SettingsGroup(items: [
      _SettingsRow(
        icon: Icons.star_border_rounded,
        iconBg: AppColors.iconBgOrange,
        iconColor: AppColors.warningAmber,
        title: 'Rate App',
        onTap: _ctrl.onRateApp,
        showExternal: true,
      ),
      _SettingsRow(
        icon: Icons.share_outlined,
        iconBg: AppColors.iconBgBlue,
        iconColor: AppColors.primaryBlue,
        title: 'Share App',
        onTap: _ctrl.onShareApp,
      ),
      _SettingsRow(
        icon: Icons.shield_outlined,
        iconBg: AppColors.iconBgTeal,
        iconColor: AppColors.accentTeal,
        title: 'Privacy Policy',
        onTap: _ctrl.onPrivacyPolicy,
        isLast: true,
      ),
    ]);
  }

  Widget _buildAccount() {
    return _SettingsGroup(items: [
      _SettingsRow(
        icon: Icons.lock_outline_rounded,
        iconBg: AppColors.iconBgBlue,
        iconColor: AppColors.primaryCyan,
        title: 'Change Password',
        onTap: _ctrl.onChangePassword,
      ),
      _SettingsRow(
        icon: Icons.logout_rounded,
        iconBg: const Color(0xFF1C1C1C),
        iconColor: AppColors.textSecondary,
        title: 'Logout',
        onTap: _ctrl.onLogout,
        titleColor: AppColors.textSecondary,
      ),
      _SettingsRow(
        icon: Icons.delete_outline_rounded,
        iconBg: Color(0xFF7F1D1D),
        iconColor: AppColors.errorRed,
        title: 'Delete Account',
        onTap: _ctrl.onDeleteAccount,
        titleColor: AppColors.errorRed,
        isLast: true,
      ),
    ]);
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

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

class _SettingsGroup extends StatelessWidget {
  final List<Widget> items;
  const _SettingsGroup({required this.items});

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

class _SettingsRow extends StatefulWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final Color titleColor;
  final String? trailing;
  final VoidCallback onTap;
  final bool isLast;
  final bool showExternal;

  const _SettingsRow({
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
  State<_SettingsRow> createState() => _SettingsRowState();
}

class _SettingsRowState extends State<_SettingsRow> {
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
        color: _pressed
            ? AppColors.shimmer
            : Colors.transparent,
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

class _ToggleRow extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool isLast;

  const _ToggleRow({
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
          padding:
          EdgeInsets.symmetric(horizontal: 14.h, vertical: 13.v),
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
            )
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
