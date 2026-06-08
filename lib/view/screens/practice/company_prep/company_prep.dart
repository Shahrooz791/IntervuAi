import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intervu_ai/controllers/mock_interview_controller.dart';
import 'package:intervu_ai/core/constants/app_colors.dart';
import 'package:intervu_ai/core/utils/size_utils.dart';
import 'package:intervu_ai/view/screens/practice/company_prep/components/company_grid.dart';
import 'package:intervu_ai/view/screens/practice/company_prep/components/company_details.dart';
import 'package:intervu_ai/view/widgets/app_button.dart';
import 'package:intervu_ai/view/widgets/app_text.dart';

class CompanyPrepScreen extends StatefulWidget {
  const CompanyPrepScreen({super.key});

  @override
  State<CompanyPrepScreen> createState() => _CompanyPrepScreenState();
}

class _CompanyPrepScreenState extends State<CompanyPrepScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _entryCtrl;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  final _ctrl = Get.isRegistered<MockInterviewController>() ? Get.find<MockInterviewController>() : Get.put(MockInterviewController());

  @override
  void initState() {
    super.initState();
    _entryCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fade = CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.04),
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
            child: Column(
              children: [
                _buildTopBar(),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 16.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Gap.v(8),
                        _buildHeroSection(),
                        Gap.v(20),
                        _buildSectionLabel('Target Companies'),
                        Gap.v(12),
                        CompanyGrid(ctrl: _ctrl),
                        Gap.v(20),
                        CompanyDetails(ctrl: _ctrl),
                        Gap.v(24),
                        _buildStartButton(),
                        Gap.v(16),
                        _buildJoinBanner(),
                        Gap.v(32),
                      ],
                    ),
                  ),
                ),
              ],
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
            text: 'IntervuAI',
            fontSize: 18.fSize,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
          const Spacer(),
          Container(
            width: 38.h,
            height: 38.h,
            decoration: BoxDecoration(
              borderRadius: 10.r,
              color: AppColors.darkCard,
              border: Border.all(color: AppColors.darkCardBorder),
            ),
            child: Icon(Icons.notifications_none_rounded,
                color: AppColors.textSecondary, size: 18.h),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 4.v),
          decoration: BoxDecoration(
            borderRadius: 100.r,
            color: AppColors.iconBgPurple,
            border:
            Border.all(color: AppColors.accentPurple.withOpacity(0.4)),
          ),
          child: AppText(
            text: 'AI COMPANY SIMULATION',
            fontSize: 10.fSize,
            fontWeight: FontWeight.w800,
            color: AppColors.accentPurple,
          ),
        ),
        Gap.v(12),
        AppText(
          text: 'Master the\nGoogle\nExperience.',
          fontSize: 28.fSize,
          fontWeight: FontWeight.w800,
          color: AppColors.textPrimary,
          height: 1.2,
        ),
        Gap.v(8),
        AppText(
          text:
          'Adaptive mock interviews tailored to your target company\'s specific hiring bar and cultural DNA.',
          fontSize: 13.fSize,
          color: AppColors.textSecondary,
          height: 1.5,
        ),
      ],
    );
  }

  Widget _buildSectionLabel(String label) {
    return Row(
      children: [
        AppText(
          text: label,
          fontSize: 16.fSize,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        const Spacer(),
        AppText(
          text: 'View All',
          fontSize: 13.fSize,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryCyan,
        ),
      ],
    );
  }

  Widget _buildStartButton() {
    return AppButton(
      text: 'Start Company Prep →',
      onTap: _ctrl.onStartCompanyPrep,
      type: AppButtonType.primary,
    );
  }

  Widget _buildJoinBanner() {
    return Container(
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        borderRadius: 16.r,
        gradient: AppColors.challengeGradient,
        border: Border.all(color: AppColors.primaryBlue.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  text: 'Join 12k+ Engineers',
                  fontSize: 15.fSize,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
                Gap.v(4),
                AppText(
                  text: 'Practicing for top-tier roles today.',
                  fontSize: 12.fSize,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
          Icon(Icons.groups_rounded,
              color: AppColors.primaryCyan, size: 32.h),
        ],
      ),
    );
  }
}
