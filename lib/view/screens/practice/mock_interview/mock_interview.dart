import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intervu_ai/controllers/mock_interview_controller.dart';
import 'package:intervu_ai/core/constants/app_colors.dart';
import 'package:intervu_ai/core/utils/size_utils.dart';
import 'package:intervu_ai/view/screens/practice/mock_interview/components/setup_question_types.dart';
import 'package:intervu_ai/view/screens/practice/mock_interview/components/setup_selectors.dart';
import 'package:intervu_ai/view/widgets/app_button.dart';
import 'package:intervu_ai/view/widgets/app_text.dart';

class MockInterviewScreen extends StatefulWidget {
  const MockInterviewScreen({super.key});

  @override
  State<MockInterviewScreen> createState() => _MockInterviewScreenState();
}

class _MockInterviewScreenState extends State<MockInterviewScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _entryCtrl;
  late List<Animation<double>> _fadeAnims;
  late List<Animation<Offset>> _slideAnims;

  final _ctrl = Get.put(MockInterviewController());
  static const int _count = 6;

  @override
  void initState() {
    super.initState();
    _entryCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fadeAnims = List.generate(_count, (i) {
      final s = i * 0.12;
      final e = (s + 0.4).clamp(0.0, 1.0);
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _entryCtrl, curve: Interval(s, e, curve: Curves.easeOut)),
      );
    });
    _slideAnims = List.generate(_count, (i) {
      final s = i * 0.12;
      final e = (s + 0.4).clamp(0.0, 1.0);
      return Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
        CurvedAnimation(parent: _entryCtrl, curve: Interval(s, e, curve: Curves.easeOut)),
      );
    });
    Future.delayed(const Duration(milliseconds: 60), () {
      if (mounted) _entryCtrl.forward();
    });
  }

  @override
  void dispose() {
    _entryCtrl.dispose();
    super.dispose();
  }

  Widget _anim(int i, Widget child) => AnimatedBuilder(
    animation: _entryCtrl,
    builder: (_, __) => FadeTransition(
      opacity: _fadeAnims[i],
      child: SlideTransition(position: _slideAnims[i], child: child),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: SafeArea(
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
                    _anim(0, _buildModeTag()),
                    Gap.v(12),
                    _anim(1, _buildHeroTitle()),
                    Gap.v(20),
                    _anim(2, const SetupTargetRoleSelector()),
                    Gap.v(20),
                    _anim(3, const SetupDurationAndLevel()),
                    Gap.v(20),
                    _anim(4, const SetupQuestionTypes()),
                    Gap.v(20),
                    _anim(5, _buildAiNote()),
                    Gap.v(24),
                    _anim(5, _buildStartButton()),
                    Gap.v(32),
                  ],
                ),
              ),
            ),
          ],
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

  Widget _buildModeTag() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 4.v),
      decoration: BoxDecoration(
        borderRadius: 100.r,
        color: AppColors.iconBgBlue,
        border: Border.all(color: AppColors.primaryBlue.withOpacity(0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6.h,
            height: 6.h,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryCyan,
            ),
          ),
          Gap.h(6),
          AppText(
            text: 'MOCK MODE',
            fontSize: 10.fSize,
            fontWeight: FontWeight.w800,
            color: AppColors.primaryCyan,
          ),
        ],
      ),
    );
  }

  Widget _buildHeroTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          text: 'Ready to shine?',
          fontSize: 22.fSize,
          fontWeight: FontWeight.w800,
          color: AppColors.textPrimary,
        ),
        Gap.v(4),
        AppText(
          text: 'Simulate a real-time high-stakes interview environment.',
          fontSize: 13.fSize,
          color: AppColors.textSecondary,
          height: 1.5,
        ),
      ],
    );
  }

  Widget _buildAiNote() {
    return Container(
      padding: EdgeInsets.all(14.h),
      decoration: BoxDecoration(
        borderRadius: 14.r,
        color: AppColors.iconBgPurple,
        border: Border.all(color: AppColors.accentPurple.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.auto_awesome_rounded,
              color: AppColors.accentPurple, size: 16.h),
          Gap.h(10),
          Expanded(
            child: Obx(() => AppText(
              text:
              'AI has prepared 12 questions for you  ·  Est. ${_ctrl.selectedDuration.value}  ·  Max. Product Mgr',
              fontSize: 12.fSize,
              color: AppColors.textSecondary,
              height: 1.5,
            )),
          ),
        ],
      ),
    );
  }

  Widget _buildStartButton() {
    return AppButton(
      text: '⚡  Start Interview',
      onTap: _ctrl.onStartInterview,
      type: AppButtonType.primary,
    );
  }
}
