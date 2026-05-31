import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intervu_ai/controllers/profile_controller.dart';
import 'package:intervu_ai/core/constants/app_colors.dart';
import 'package:intervu_ai/core/utils/size_utils.dart';
import 'package:intervu_ai/view/screens/profile/profile/components/profile_achivements_card.dart';
import 'package:intervu_ai/view/screens/profile/profile/components/profile_header.dart';
import 'package:intervu_ai/view/screens/profile/profile/components/profile_stat_card.dart';
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
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOut));

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
                  Gap.v(20),
                  ProfileHeader(ctrl: _ctrl),
                  Gap.v(24),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildStatsRow(),
                        Gap.v(12),
                        _buildTargetRoleCard(),
                        Gap.v(12),
                        _buildScoreRow(),
                        Gap.v(12),
                        ProfileAchievementsCard(ctrl: _ctrl),
                        Gap.v(12),
                        _buildProgressHistoryButton(),
                        Gap.v(20),
                        _buildLogoutButton(),
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
          AppText(
            text: 'Profile',
            fontSize: 22.fSize,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
          const Spacer(),
          GestureDetector(
            onTap: _ctrl.onSettingsTap,
            child: Container(
              width: 40.h,
              height: 40.h,
              decoration: BoxDecoration(
                borderRadius: 12.r,
                color: AppColors.darkCard,
                border: Border.all(color: AppColors.darkCardBorder),
              ),
              child: Icon(Icons.settings_outlined,
                  color: AppColors.textSecondary, size: 20.h),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Obx(() => Row(
      children: [
        ProfileStatCard(
          value: '${_ctrl.totalSessions.value}',
          label: 'SESSIONS',
        ),
        Gap.h(10),
        ProfileStatCard(
          value: '${_ctrl.avgScore.value}',
          label: 'AVG SCORE',
        ),
        Gap.h(10),
        ProfileStatCard(
          value: '${_ctrl.dayStreak.value}',
          label: 'DAY STREAK',
        ),
      ],
    ));
  }

  Widget _buildTargetRoleCard() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 14.v),
      decoration: BoxDecoration(
        borderRadius: 16.r,
        color: AppColors.darkCard,
        border: Border.all(color: AppColors.darkCardBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 36.h,
            height: 36.h,
            decoration: BoxDecoration(
              borderRadius: 10.r,
              color: AppColors.iconBgBlue,
            ),
            child: Icon(Icons.work_outline_rounded,
                color: AppColors.primaryBlue, size: 18.h),
          ),
          Gap.h(12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                text: 'TARGET ROLE',
                fontSize: 10.fSize,
                fontWeight: FontWeight.w700,
                color: AppColors.textMuted,
              ),
              Gap.v(3),
              Obx(() => AppText(
                text: _ctrl.targetRole.value,
                fontSize: 16.fSize,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              )),
            ],
          ),
          const Spacer(),
          Icon(Icons.chevron_right_rounded,
              color: AppColors.textMuted, size: 20.h),
        ],
      ),
    );
  }

  Widget _buildScoreRow() {
    return Obx(() => Row(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.all(14.h),
            decoration: BoxDecoration(
              borderRadius: 16.r,
              color: AppColors.darkCard,
              border: Border.all(color: AppColors.darkCardBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.star_rounded,
                        color: AppColors.warningAmber, size: 14.h),
                    Gap.h(5),
                    AppText(
                      text: 'BEST SCORE',
                      fontSize: 10.fSize,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textMuted,
                    ),
                  ],
                ),
                Gap.v(6),
                AppText(
                  text: '${_ctrl.bestScore.value}',
                  fontSize: 28.fSize,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ],
            ),
          ),
        ),
        Gap.h(10),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(14.h),
            decoration: BoxDecoration(
              borderRadius: 16.r,
              color: AppColors.darkCard,
              border: Border.all(color: AppColors.darkCardBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_today_outlined,
                        color: AppColors.primaryCyan, size: 14.h),
                    Gap.h(5),
                    AppText(
                      text: 'THIS WEEK',
                      fontSize: 10.fSize,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textMuted,
                    ),
                  ],
                ),
                Gap.v(6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    AppText(
                      text: '${_ctrl.weekSessions.value}',
                      fontSize: 28.fSize,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                    Gap.h(4),
                    Padding(
                      padding: EdgeInsets.only(bottom: 4.v),
                      child: AppText(
                        text: 'sessions',
                        fontSize: 12.fSize,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    ));
  }

  Widget _buildProgressHistoryButton() {
    return GestureDetector(
      onTap: _ctrl.onViewProgressHistory,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 14.v),
        decoration: BoxDecoration(
          borderRadius: 16.r,
          color: AppColors.darkCard,
          border: Border.all(color: AppColors.darkCardBorder),
        ),
        child: Row(
          children: [
            Icon(Icons.bar_chart_rounded,
                color: AppColors.primaryCyan, size: 20.h),
            Gap.h(10),
            AppText(
              text: 'View progress history',
              fontSize: 14.fSize,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            const Spacer(),
            Icon(Icons.chevron_right_rounded,
                color: AppColors.textMuted, size: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return GestureDetector(
      onTap: _ctrl.onLogout,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 14.v),
        decoration: BoxDecoration(
          borderRadius: 100.r,
          color: AppColors.errorRed.withOpacity(0.1),
          border: Border.all(color: AppColors.errorRed.withOpacity(0.35)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout_rounded,
                color: AppColors.errorRed, size: 18.h),
            Gap.h(8),
            AppText(
              text: 'Log out',
              fontSize: 15.fSize,
              fontWeight: FontWeight.w700,
              color: AppColors.errorRed,
            ),
          ],
        ),
      ),
    );
  }
}
