import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intervu_ai/controllers/mock_interview_controller.dart';
import 'package:intervu_ai/core/constants/app_colors.dart';
import 'package:intervu_ai/core/utils/size_utils.dart';
import 'package:intervu_ai/view/screens/practice/answer_review/components/review_analysis_bars.dart';
import 'package:intervu_ai/view/screens/practice/answer_review/components/review_answer_section.dart';
import 'package:intervu_ai/view/widgets/app_text.dart';

class AnswerReviewScreen extends StatefulWidget {
  const AnswerReviewScreen({super.key});

  @override
  State<AnswerReviewScreen> createState() => _AnswerReviewScreenState();
}

class _AnswerReviewScreenState extends State<AnswerReviewScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _entryCtrl;
  late List<Animation<double>> _fadeAnims;
  late List<Animation<Offset>> _slideAnims;

  final _ctrl = Get.isRegistered<MockInterviewController>() ? Get.find<MockInterviewController>() : Get.put(MockInterviewController());
  static const int _count = 5;

  @override
  void initState() {
    super.initState();
    _entryCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fadeAnims = List.generate(_count, (i) {
      final s = i * 0.14;
      final e = (s + 0.45).clamp(0.0, 1.0);
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: _entryCtrl, curve: Interval(s, e, curve: Curves.easeOut)),
      );
    });
    _slideAnims = List.generate(_count, (i) {
      final s = i * 0.14;
      final e = (s + 0.45).clamp(0.0, 1.0);
      return Tween<Offset>(
          begin: const Offset(0, 0.2), end: Offset.zero)
          .animate(CurvedAnimation(
          parent: _entryCtrl,
          curve: Interval(s, e, curve: Curves.easeOut)));
    });
    Future.delayed(const Duration(milliseconds: 80), () {
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
                    Gap.v(12),
                    _anim(0, _buildQuestionCard()),
                    Gap.v(16),
                    _anim(1, ReviewAnalysisBars(ctrl: _ctrl)),
                    Gap.v(16),
                    _anim(2, ReviewAnswerSection(ctrl: _ctrl)),
                    Gap.v(16),
                    _anim(3, ReviewFeedbackPoints(ctrl: _ctrl)),
                    Gap.v(16),
                    _anim(4, ReviewModelAnswer(ctrl: _ctrl)),
                    Gap.v(28),
                    _anim(4, _buildNavigation()),
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
              child: Icon(Icons.close_rounded,
                  color: AppColors.textPrimary, size: 18.h),
            ),
          ),
          Gap.h(12),
          AppText(
            text: 'Answer Review',
            fontSize: 16.fSize,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
          const Spacer(),
          Obx(() => Container(
            padding:
            EdgeInsets.symmetric(horizontal: 12.h, vertical: 6.v),
            decoration: BoxDecoration(
              borderRadius: 10.r,
              gradient: AppColors.primaryGradient,
            ),
            child: Row(
              children: [
                AppText(
                  text: 'SCORE ',
                  fontSize: 11.fSize,
                  fontWeight: FontWeight.w700,
                  color: AppColors.white.withOpacity(0.7),
                ),
                AppText(
                  text: '${_ctrl.reviewScore.value}',
                  fontSize: 14.fSize,
                  fontWeight: FontWeight.w800,
                  color: AppColors.white,
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildQuestionCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() => Row(
          children: [
            AppText(
              text:
              'QUESTION ${_ctrl.currentReviewQuestion.value}/${_ctrl.totalReviewQuestions.value}',
              fontSize: 11.fSize,
              fontWeight: FontWeight.w700,
              color: AppColors.textMuted,
            ),
          ],
        )),
        Gap.v(10),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.h),
          decoration: BoxDecoration(
            borderRadius: 16.r,
            color: AppColors.darkCard,
            border: Border.all(color: AppColors.darkCardBorder),
          ),
          child: Obx(() => AppText(
            text: _ctrl.reviewQuestion.value,
            fontSize: 15.fSize,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
            height: 1.5,
          )),
        ),
      ],
    );
  }

  Widget _buildNavigation() {
    return Row(
      children: [
        GestureDetector(
          onTap: _ctrl.onPreviousQuestion,
          child: Container(
            width: 44.h,
            height: 44.h,
            decoration: BoxDecoration(
              borderRadius: 12.r,
              color: AppColors.darkCard,
              border: Border.all(color: AppColors.darkCardBorder),
            ),
            child: Icon(Icons.arrow_back_ios_new_rounded,
                color: AppColors.textSecondary, size: 16.h),
          ),
        ),
        Gap.h(12),
        Expanded(
          child: Obx(() {
            final total = _ctrl.totalReviewQuestions.value;
            final current = _ctrl.currentReviewQuestion.value;
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                total.clamp(0, 8),
                    (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: i == current - 1 ? 20.h : 6.h,
                  height: 6.h,
                  margin: EdgeInsets.symmetric(horizontal: 2.h),
                  decoration: BoxDecoration(
                    borderRadius: 100.r,
                    color: i == current - 1
                        ? AppColors.primaryCyan
                        : AppColors.progressBg,
                  ),
                ),
              ),
            );
          }),
        ),
        Gap.h(12),
        GestureDetector(
          onTap: _ctrl.onNextQuestion,
          child: Container(
            width: 44.h,
            height: 44.h,
            decoration: BoxDecoration(
              borderRadius: 12.r,
              gradient: AppColors.primaryGradient,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryBlue.withOpacity(0.35),
                  blurRadius: 10.h,
                ),
              ],
            ),
            child: Icon(Icons.arrow_forward_ios_rounded,
                color: AppColors.white, size: 16.h),
          ),
        ),
      ],
    );
  }
}
