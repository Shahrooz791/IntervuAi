import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intervu_ai/controllers/profile_controller.dart';
import 'package:intervu_ai/core/constants/app_colors.dart';
import 'package:intervu_ai/core/utils/size_utils.dart';
import 'package:intervu_ai/view/screens/profile/settings/components/settings_component.dart';
import 'package:intervu_ai/view/widgets/app_text.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _entryCtrl;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  final _ctrl = Get.find<ProfileController>();

  @override
  void initState() {
    super.initState();
    _entryCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fade = CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.04),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOut));

    Future.delayed(const Duration(milliseconds: 60), () {
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
                        const SettingsSectionLabel(label: 'PREFERENCES'),
                        Gap.v(10),
                        _buildPreferences(),
                        Gap.v(24),
                        const SettingsSectionLabel(label: 'NOTIFICATIONS'),
                        Gap.v(10),
                        _buildNotifications(),
                        Gap.v(24),
                        const SettingsSectionLabel(label: 'SUPPORT'),
                        Gap.v(10),
                        _buildSupport(),
                        Gap.v(24),
                        const SettingsSectionLabel(label: 'ACCOUNT'),
                        Gap.v(10),
                        _buildAccount(),
                        Gap.v(28),
                        _buildFooter(),
                        Gap.v(32),
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
              padding: EdgeInsets.symmetric(horizontal: 14.h, vertical: 7.v),
              decoration: BoxDecoration(
                borderRadius: 10.r,
                gradient: AppColors.primaryGradient,
              ),
              child: AppText(
                text: 'Edit profile',
                fontSize: 12.fSize,
                fontWeight: FontWeight.w700,
                color: AppColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreferences() {
    return SettingsGroup(items: [
      Obx(() => SettingsRow(
        icon: Icons.work_outline_rounded,
        iconBg: AppColors.iconBgBlue,
        iconColor: AppColors.primaryBlue,
        title: 'Target role',
        trailing: _ctrl.targetRole.value,
        onTap: _ctrl.onTargetRoleTap,
      )),
      Obx(() => SettingsRow(
        icon: Icons.bolt_rounded,
        iconBg: AppColors.iconBgPurple,
        iconColor: AppColors.accentPurple,
        title: 'Difficulty',
        trailing: _ctrl.difficulty.value,
        onTap: _ctrl.onDifficultyTap,
      )),
      Obx(() => SettingsRow(
        icon: Icons.timer_outlined,
        iconBg: AppColors.iconBgBlue,
        iconColor: AppColors.primaryCyan,
        title: 'Session length',
        trailing: _ctrl.sessionLength.value,
        onTap: _ctrl.onSessionLengthTap,
        isLast: true,
      )),
    ]);
  }

  Widget _buildNotifications() {
    return SettingsGroup(items: [
      Obx(() => SettingsToggleRow(
        icon: Icons.alarm_rounded,
        iconBg: AppColors.iconBgBlue,
        iconColor: AppColors.primaryBlue,
        title: 'Daily reminder',
        value: _ctrl.dailyReminder.value,
        onChanged: _ctrl.toggleDailyReminder,
      )),
      Obx(() => SettingsToggleRow(
        icon: Icons.trending_up_rounded,
        iconBg: AppColors.iconBgOrange,
        iconColor: AppColors.orangeAccent,
        title: 'Streak alert',
        value: _ctrl.streakAlert.value,
        onChanged: _ctrl.toggleStreakAlert,
      )),
      Obx(() => SettingsToggleRow(
        icon: Icons.notifications_outlined,
        iconBg: AppColors.iconBgTeal,
        iconColor: AppColors.accentTeal,
        title: 'Achievement alerts',
        value: _ctrl.achievementAlerts.value,
        onChanged: _ctrl.toggleAchievementAlerts,
        isLast: true,
      )),
    ]);
  }

  Widget _buildSupport() {
    return SettingsGroup(items: [
      SettingsRow(
        icon: Icons.star_border_rounded,
        iconBg: AppColors.iconBgOrange,
        iconColor: AppColors.warningAmber,
        title: 'Rate App',
        onTap: _ctrl.onRateApp,
        showExternal: true,
      ),
      SettingsRow(
        icon: Icons.share_outlined,
        iconBg: AppColors.iconBgBlue,
        iconColor: AppColors.primaryBlue,
        title: 'Share App',
        onTap: _ctrl.onShareApp,
      ),
      SettingsRow(
        icon: Icons.shield_outlined,
        iconBg: AppColors.iconBgTeal,
        iconColor: AppColors.accentTeal,
        title: 'Privacy',
        onTap: _ctrl.onPrivacyPolicy,
      ),
      SettingsRow(
        icon: Icons.help_outline_rounded,
        iconBg: AppColors.iconBgPurple,
        iconColor: AppColors.accentPurple,
        title: 'FAQ',
        onTap: _ctrl.onFaq,
        isLast: true,
      ),
    ]);
  }

  Widget _buildAccount() {
    return SettingsGroup(items: [
      SettingsRow(
        icon: Icons.lock_outline_rounded,
        iconBg: AppColors.iconBgBlue,
        iconColor: AppColors.primaryCyan,
        title: 'Change password',
        onTap: _ctrl.onChangePassword,
      ),
      SettingsRow(
        icon: Icons.logout_rounded,
        iconBg: const Color(0xFF1C1C1C),
        iconColor: AppColors.textSecondary,
        title: 'Log out',
        onTap: _ctrl.onSettingsLogout,
        titleColor: AppColors.textSecondary,
      ),
      SettingsRow(
        icon: Icons.delete_outline_rounded,
        iconBg: const Color(0xFF7F1D1D),
        iconColor: AppColors.errorRed,
        title: 'Delete account',
        onTap: _ctrl.onDeleteAccount,
        titleColor: AppColors.errorRed,
        isLast: true,
      ),
    ]);
  }

  Widget _buildFooter() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 22.h,
              height: 22.h,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppColors.logoGradient,
              ),
              child: Center(
                child: Icon(Icons.psychology_rounded,
                    color: AppColors.white, size: 13.h),
              ),
            ),
            Gap.h(6),
            AppText(
              text: 'IntervuAI v1.0.0',
              fontSize: 12.fSize,
              fontWeight: FontWeight.w600,
              color: AppColors.textMuted,
            ),
          ],
        ),
        Gap.v(4),
        AppText(
          text: 'POWERED BY ANTHROPIC AI',
          fontSize: 10.fSize,
          fontWeight: FontWeight.w700,
          color: AppColors.textMuted,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
