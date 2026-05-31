import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intervu_ai/controllers/mock_interview_controller.dart';
import 'package:intervu_ai/core/constants/app_colors.dart';
import 'package:intervu_ai/core/utils/size_utils.dart';
import 'package:intervu_ai/view/widgets/app_text.dart';

// ─── User Answer Section ──────────────────────────────────────

class ReviewAnswerSection extends StatelessWidget {
  final MockInterviewController ctrl;
  const ReviewAnswerSection({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        borderRadius: 16.r,
        color: AppColors.darkCard,
        border: Border.all(color: AppColors.darkCardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            text: 'Your Answer',
            fontSize: 13.fSize,
            fontWeight: FontWeight.w700,
            color: AppColors.textSecondary,
          ),
          Gap.v(10),
          Obx(() => AppText(
            text: ctrl.userAnswer.value,
            fontSize: 13.fSize,
            color: AppColors.textSecondary,
            height: 1.6,
          )),
        ],
      ),
    );
  }
}

// ─── Feedback Points ──────────────────────────────────────────

class ReviewFeedbackPoints extends StatelessWidget {
  final MockInterviewController ctrl;
  const ReviewFeedbackPoints({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _FeedbackCard(
          icon: Icons.check_circle_outline_rounded,
          iconColor: AppColors.successGreen,
          title: 'What you did well',
          titleColor: AppColors.successGreen,
          bgColor: AppColors.successGreen.withOpacity(0.06),
          borderColor: AppColors.successGreen.withOpacity(0.2),
          points: ctrl.didWellPoints,
          dotColor: AppColors.successGreen,
        ),
        Gap.v(10),
        _FeedbackCard(
          icon: Icons.trending_up_rounded,
          iconColor: AppColors.primaryCyan,
          title: 'How to improve',
          titleColor: AppColors.primaryCyan,
          bgColor: AppColors.primaryCyan.withOpacity(0.06),
          borderColor: AppColors.primaryCyan.withOpacity(0.2),
          points: ctrl.improvePoints,
          dotColor: AppColors.primaryCyan,
        ),
      ],
    );
  }
}

class _FeedbackCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final Color titleColor;
  final Color bgColor;
  final Color borderColor;
  final List<String> points;
  final Color dotColor;

  const _FeedbackCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.titleColor,
    required this.bgColor,
    required this.borderColor,
    required this.points,
    required this.dotColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.h),
      decoration: BoxDecoration(
        borderRadius: 14.r,
        color: bgColor,
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 14.h),
              Gap.h(6),
              AppText(
                text: title,
                fontSize: 13.fSize,
                fontWeight: FontWeight.w700,
                color: titleColor,
              ),
            ],
          ),
          Gap.v(10),
          ...points.map(
                (p) => Padding(
              padding: EdgeInsets.only(bottom: 6.v),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 5.v),
                    child: Container(
                      width: 4.h,
                      height: 4.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: dotColor,
                      ),
                    ),
                  ),
                  Gap.h(8),
                  Expanded(
                    child: AppText(
                      text: p,
                      fontSize: 12.fSize,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Model Answer ─────────────────────────────────────────────

class ReviewModelAnswer extends StatefulWidget {
  final MockInterviewController ctrl;
  const ReviewModelAnswer({super.key, required this.ctrl});

  @override
  State<ReviewModelAnswer> createState() => _ReviewModelAnswerState();
}

class _ReviewModelAnswerState extends State<ReviewModelAnswer> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.h),
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
              Container(
                width: 28.h,
                height: 28.h,
                decoration: BoxDecoration(
                  borderRadius: 8.r,
                  color: AppColors.iconBgTeal,
                ),
                child: Icon(Icons.lightbulb_outline_rounded,
                    color: AppColors.accentTeal, size: 14.h),
              ),
              Gap.h(10),
              AppText(
                text: 'Model Answer',
                fontSize: 14.fSize,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ],
          ),
          Gap.v(12),
          Obx(() => AnimatedCrossFade(
            firstChild: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  text: widget.ctrl.modelAnswer.value.length > 200
                      ? '${widget.ctrl.modelAnswer.value.substring(0, 200)}...'
                      : widget.ctrl.modelAnswer.value,
                  fontSize: 13.fSize,
                  color: AppColors.textSecondary,
                  height: 1.6,
                ),
              ],
            ),
            secondChild: AppText(
              text: widget.ctrl.modelAnswer.value,
              fontSize: 13.fSize,
              color: AppColors.textSecondary,
              height: 1.6,
            ),
            crossFadeState: _expanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          )),
          Gap.v(12),
          GestureDetector(
            onTap: () {
              setState(() => _expanded = !_expanded);
              if (!_expanded) widget.ctrl.onReadFullAnalysis();
            },
            child: Row(
              children: [
                AppText(
                  text: _expanded ? 'Collapse' : 'READ FULL ANALYSIS →',
                  fontSize: 12.fSize,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryCyan,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
