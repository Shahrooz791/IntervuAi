import 'package:flutter/material.dart';
import 'package:intervu_ai/controllers/mock_interview_controller.dart';
import 'package:intervu_ai/core/constants/app_colors.dart';
import 'package:intervu_ai/core/utils/size_utils.dart';
import 'package:intervu_ai/view/widgets/app_text.dart';

class ResultScoreRing extends StatefulWidget {
  final MockInterviewController ctrl;
  const ResultScoreRing({super.key, required this.ctrl});

  @override
  State<ResultScoreRing> createState() => _ResultScoreRingState();
}

class _ResultScoreRingState extends State<ResultScoreRing>
    with SingleTickerProviderStateMixin {
  late AnimationController _ringCtrl;
  late Animation<double> _ringAnim;

  @override
  void initState() {
    super.initState();
    _ringCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();
    _ringAnim =
        CurvedAnimation(parent: _ringCtrl, curve: Curves.easeOutCubic);
  }

  @override
  void dispose() {
    _ringCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedBuilder(
          animation: _ringAnim,
          builder: (_, __) => SizedBox(
            width: 130.h,
            height: 130.h,
            child: CustomPaint(
              painter: _ScoreRingPainter(progress: _ringAnim.value,
                  score: widget.ctrl.sessionScore.value),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppText(
                      text: '${widget.ctrl.sessionScore.value}',
                      fontSize: 36.fSize,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                    AppText(
                      text: '/ ${widget.ctrl.sessionMaxScore.value}',
                      fontSize: 12.fSize,
                      color: AppColors.textMuted,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Gap.v(12),
        AppText(
          text: 'Session Complete',
          fontSize: 20.fSize,
          fontWeight: FontWeight.w800,
          color: AppColors.textPrimary,
        ),
        Gap.v(6),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.h),
          child: AppText(
            text: widget.ctrl.sessionRankMessage.value,
            fontSize: 13.fSize,
            color: AppColors.textSecondary,
            textAlign: TextAlign.center,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

class _ScoreRingPainter extends CustomPainter {
  final double progress;
  final int score;
  const _ScoreRingPainter({required this.progress, required this.score});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - 8;
    const strokeWidth = 8.0;

    final bgPaint = Paint()
      ..color = AppColors.progressBg
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    final fgPaint = Paint()
      ..shader = const LinearGradient(
        colors: [AppColors.btnGradientStart, AppColors.btnGradientEnd],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final sweepAngle = (score / 100) * 2 * 3.14159 * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.14159 / 2,
      sweepAngle,
      false,
      fgPaint,
    );
  }

  @override
  bool shouldRepaint(_ScoreRingPainter old) => old.progress != progress;
}

// ─── Strengths Card ────────────────────────────────────────────

class ResultStrengthsCard extends StatelessWidget {
  final MockInterviewController ctrl;
  const ResultStrengthsCard({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
              Icon(Icons.check_circle_outline_rounded,
                  color: AppColors.successGreen, size: 16.h),
              Gap.h(8),
              AppText(
                text: 'Strengths',
                fontSize: 14.fSize,
                fontWeight: FontWeight.w700,
                color: AppColors.successGreen,
              ),
            ],
          ),
          Gap.v(12),
          ...ctrl.strengths.map(
                (s) => Padding(
              padding: EdgeInsets.only(bottom: 8.v),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 5.v),
                    child: Container(
                      width: 5.h,
                      height: 5.h,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.successGreen,
                      ),
                    ),
                  ),
                  Gap.h(10),
                  Expanded(
                    child: AppText(
                      text: s['text'] as String,
                      fontSize: 13.fSize,
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

// ─── Weak Areas Card ───────────────────────────────────────────

class ResultWeakAreasCard extends StatelessWidget {
  final MockInterviewController ctrl;
  const ResultWeakAreasCard({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
              Icon(Icons.warning_amber_rounded,
                  color: AppColors.warningAmber, size: 16.h),
              Gap.h(8),
              AppText(
                text: 'Weak Areas',
                fontSize: 14.fSize,
                fontWeight: FontWeight.w700,
                color: AppColors.warningAmber,
              ),
            ],
          ),
          Gap.v(12),
          ...ctrl.weakAreas.map(
                (w) => Padding(
              padding: EdgeInsets.only(bottom: 8.v),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 5.v),
                    child: Container(
                      width: 5.h,
                      height: 5.h,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.warningAmber,
                      ),
                    ),
                  ),
                  Gap.h(10),
                  Expanded(
                    child: AppText(
                      text: w['text'] as String,
                      fontSize: 13.fSize,
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

// ─── AI Recommendations ────────────────────────────────────────

class ResultAiRecommendations extends StatelessWidget {
  final MockInterviewController ctrl;
  const ResultAiRecommendations({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
              Icon(Icons.auto_awesome_rounded,
                  color: AppColors.accentPurple, size: 16.h),
              Gap.h(8),
              AppText(
                text: 'AI Recommendations',
                fontSize: 14.fSize,
                fontWeight: FontWeight.w700,
                color: AppColors.accentPurple,
              ),
            ],
          ),
          Gap.v(12),
          AppText(
            text:
            'Focus on concise stakeholder communication modules next. Your tone is highly professional but could benefit from more specific KPIs.',
            fontSize: 13.fSize,
            color: AppColors.textSecondary,
            height: 1.5,
          ),
          Gap.v(14),
          ...ctrl.aiRecommendations.map(
                (rec) => Padding(
              padding: EdgeInsets.only(bottom: 8.v),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 6.v),
                decoration: BoxDecoration(
                  borderRadius: 100.r,
                  color: Color(rec['tagColor'] as int),
                  border: Border.all(
                    color: Color(rec['tagTextColor'] as int).withOpacity(0.4),
                  ),
                ),
                child: AppText(
                  text: rec['title'] as String,
                  fontSize: 11.fSize,
                  fontWeight: FontWeight.w700,
                  color: Color(rec['tagTextColor'] as int),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
