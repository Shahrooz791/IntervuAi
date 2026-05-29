import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:intervu_ai/core/constants/app_colors.dart';
import 'package:intervu_ai/core/utils/size_utils.dart';
import 'package:intervu_ai/view/widgets/app_text.dart';

class RecentSessionsList extends StatelessWidget {
  final List<Map<String, dynamic>> sessions;
  final void Function(Map<String, dynamic>) onSessionTap;

  const RecentSessionsList({
    super.key,
    required this.sessions,
    required this.onSessionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: sessions
          .map(
            (s) => Padding(
          padding: EdgeInsets.only(bottom: 10.v),
          child: _SessionCard(session: s, onTap: () => onSessionTap(s)),
        ),
      )
          .toList(),
    );
  }
}

class _SessionCard extends StatefulWidget {
  final Map<String, dynamic> session;
  final VoidCallback onTap;

  const _SessionCard({required this.session, required this.onTap});

  @override
  State<_SessionCard> createState() => _SessionCardState();
}

class _SessionCardState extends State<_SessionCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _pressCtrl;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _pressCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 110),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _pressCtrl, curve: Curves.easeIn),
    );
  }

  @override
  void dispose() {
    _pressCtrl.dispose();
    super.dispose();
  }

  Color get _scoreColor {
    final score = widget.session['score'] as int;
    if (score >= 80) return AppColors.successGreen;
    if (score >= 60) return AppColors.warningAmber;
    return AppColors.errorRed;
  }

  @override
  Widget build(BuildContext context) {
    final score = widget.session['score'] as int;

    return GestureDetector(
      onTapDown: (_) => _pressCtrl.forward(),
      onTapUp: (_) {
        _pressCtrl.reverse();
        widget.onTap();
      },
      onTapCancel: () => _pressCtrl.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnim,
        builder: (_, __) => Transform.scale(
          scale: _scaleAnim.value,
          child: Container(
            padding: EdgeInsets.all(14.h),
            decoration: BoxDecoration(
              borderRadius: 14.r,
              color: AppColors.darkCard,
              border: Border.all(color: AppColors.darkCardBorder),
            ),
            child: Row(
              children: [
                _ScoreCircle(score: score, color: _scoreColor),
                Gap.h(14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        text: widget.session['title'] as String,
                        fontSize: 14.fSize,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                      Gap.v(4),
                      Row(
                        children: [
                          _CompanyChip(
                              label: widget.session['company'] as String),
                          Gap.h(8),
                          AppText(
                            text: widget.session['time'] as String,
                            fontSize: 12.fSize,
                            color: AppColors.textMuted,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.textMuted,
                  size: 20.h,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ScoreCircle extends StatefulWidget {
  final int score;
  final Color color;
  const _ScoreCircle({required this.score, required this.color});

  @override
  State<_ScoreCircle> createState() => _ScoreCircleState();
}

class _ScoreCircleState extends State<_ScoreCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..forward();
    _anim = Tween<double>(begin: 0.0, end: widget.score / 100).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => SizedBox(
        width: 50.h,
        height: 50.h,
        child: Stack(
          alignment: Alignment.center,
          children: [
            CustomPaint(
              painter: _CircularProgressPainter(
                progress: _anim.value,
                color: widget.color,
                trackColor: AppColors.darkCardBorder,
              ),
              child: const SizedBox.expand(),
            ),
            AppText(
              text: '${(widget.score * _anim.value).round()}%',
              fontSize: 11.fSize,
              fontWeight: FontWeight.w700,
              color: widget.color,
            ),
          ],
        ),
      ),
    );
  }
}

class _CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color trackColor;

  const _CircularProgressPainter({
    required this.progress,
    required this.color,
    required this.trackColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width / 2 - 3;
    const strokeW = 4.0;

    final trackPaint = Paint()
      ..color = trackColor
      ..strokeWidth = strokeW
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(Offset(cx, cy), r, trackPaint);

    final progressPaint = Paint()
      ..color = color
      ..strokeWidth = strokeW
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: r),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _CircularProgressPainter old) =>
      old.progress != progress;
}

class _CompanyChip extends StatelessWidget {
  final String label;
  const _CompanyChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 2.v),
      decoration: BoxDecoration(
        borderRadius: 4.r,
        color: AppColors.darkCardBorder,
      ),
      child: AppText(
        text: label,
        fontSize: 10.fSize,
        fontWeight: FontWeight.w700,
        color: AppColors.textSecondary,
      ),
    );
  }
}
