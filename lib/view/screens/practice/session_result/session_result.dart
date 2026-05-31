import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intervu_ai/controllers/mock_interview_controller.dart';
import 'package:intervu_ai/core/constants/app_colors.dart';
import 'package:intervu_ai/core/utils/size_utils.dart';
import 'package:intervu_ai/view/screens/practice/session_result/components/result_score_ring.dart';
import 'package:intervu_ai/view/widgets/app_button.dart';
import 'package:intervu_ai/view/widgets/app_text.dart';

class SessionResultScreen extends StatefulWidget {
  const SessionResultScreen({super.key});

  @override
  State<SessionResultScreen> createState() => _SessionResultScreenState();
}

class _SessionResultScreenState extends State<SessionResultScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _entryCtrl;
  late List<Animation<double>> _fadeAnims;
  late List<Animation<Offset>> _slideAnims;

  final _ctrl = Get.find<MockInterviewController>();
  static const int _count = 5;

  @override
  void initState() {
    super.initState();
    _entryCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fadeAnims = List.generate(_count, (i) {
      final s = i * 0.14;
      final e = (s + 0.45).clamp(0.0, 1.0);
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _entryCtrl, curve: Interval(s, e, curve: Curves.easeOut)),
      );
    });
    _slideAnims = List.generate(_count, (i) {
      final s = i * 0.14;
      final e = (s + 0.45).clamp(0.0, 1.0);
      return Tween<Offset>(begin: const Offset(0, 0.25), end: Offset.zero).animate(
        CurvedAnimation(parent: _entryCtrl, curve: Interval(s, e, curve: Curves.easeOut)),
      );
    });
    Future.delayed(const Duration(milliseconds: 100), () {
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
                  children: [
                    Gap.v(16),
                    _anim(0, ResultScoreRing(ctrl: _ctrl)),
                    Gap.v(24),
                    _anim(1, _buildSessionStats()),
                    Gap.v(20),
                    _anim(2, ResultStrengthsCard(ctrl: _ctrl)),
                    Gap.v(12),
                    _anim(3, ResultWeakAreasCard(ctrl: _ctrl)),
                    Gap.v(12),
                    _anim(4, ResultAiRecommendations(ctrl: _ctrl)),
                    Gap.v(28),
                    _anim(4, _buildActions()),
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
            text: 'Session Complete',
            fontSize: 18.fSize,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ],
      ),
    );
  }

  Widget _buildSessionStats() {
    return Obx(() => Row(
      children: [
        _StatPill(
          icon: Icons.timer_outlined,
          label: 'DURATION',
          value: '${_ctrl.sessionDuration.value}m',
        ),
        Gap.h(10),
        _StatPill(
          icon: Icons.quiz_outlined,
          label: 'QUESTIONS',
          value: '${_ctrl.questionsAnswered.value}/${_ctrl.totalQuestions.value}',
        ),
        Gap.h(10),
        _StatPill(
          icon: Icons.workspace_premium_rounded,
          label: 'MAX',
          value: 'Product Mgr',
        ),
      ],
    ));
  }

  Widget _buildActions() {
    return Column(
      children: [
        AppButton(
          text: 'Review Answers',
          onTap: _ctrl.onReviewAnswers,
          type: AppButtonType.primary,
        ),
        Gap.v(10),
        AppButton(
          text: 'Try Again',
          onTap: _ctrl.onTryAgain,
          type: AppButtonType.outline,
        ),
        Gap.v(10),
        GestureDetector(
          onTap: _ctrl.onShareResult,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.share_outlined,
                  color: AppColors.textSecondary, size: 16.h),
              Gap.h(6),
              AppText(
                text: 'Share Result',
                fontSize: 14.fSize,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _StatPill({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.v, horizontal: 10.h),
        decoration: BoxDecoration(
          borderRadius: 12.r,
          color: AppColors.darkCard,
          border: Border.all(color: AppColors.darkCardBorder),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primaryCyan, size: 16.h),
            Gap.v(6),
            AppText(
              text: value,
              fontSize: 13.fSize,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
            Gap.v(2),
            AppText(
              text: label,
              fontSize: 9.fSize,
              fontWeight: FontWeight.w700,
              color: AppColors.textMuted,
            ),
          ],
        ),
      ),
    );
  }
}
