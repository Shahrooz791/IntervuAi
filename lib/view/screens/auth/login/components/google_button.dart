import 'package:flutter/material.dart';
import 'package:intervu_ai/core/constants/app_colors.dart';
import 'package:intervu_ai/core/utils/size_utils.dart';
import 'package:intervu_ai/view/widgets/app_text.dart';

class GoogleButton extends StatefulWidget {
  final String label;
  const GoogleButton({super.key, required this.label});

  @override
  State<GoogleButton> createState() => _GoogleButtonState();
}

class _GoogleButtonState extends State<GoogleButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _pressCtrl;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _pressCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _pressCtrl, curve: Curves.easeIn),
    );
  }

  @override
  void dispose() {
    _pressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _pressCtrl.forward(),
      onTapUp: (_) => _pressCtrl.reverse(),
      onTapCancel: () => _pressCtrl.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnim,
        builder: (_, __) => Transform.scale(
          scale: _scaleAnim.value,
          child: Container(
            width: double.infinity,
            height: 56.v,
            decoration: BoxDecoration(
              borderRadius: 100.r,
              color: AppColors.darkCard,
              border: Border.all(color: AppColors.darkCardBorder),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _GoogleIcon(),
                Gap.h(10),
                AppText(
                  text: widget.label,
                  fontSize: 15.fSize,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GoogleIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 22.h,
      height: 22.h,
      child: CustomPaint(painter: _GoogleLogoPainter()),
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width / 2;

    final redPaint = Paint()..color = const Color(0xFFEA4335);
    final bluePaint = Paint()..color = const Color(0xFF4285F4);
    final greenPaint = Paint()..color = const Color(0xFF34A853);
    final yellowPaint = Paint()..color = const Color(0xFFFBBC05);

    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: r),
      -1.57,
      3.14,
      false,
      redPaint..style = PaintingStyle.stroke ..strokeWidth = size.width * 0.22,
    );
    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: r),
      1.57,
      1.05,
      false,
      greenPaint..style = PaintingStyle.stroke ..strokeWidth = size.width * 0.22,
    );
    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: r),
      2.62,
      1.05,
      false,
      yellowPaint..style = PaintingStyle.stroke ..strokeWidth = size.width * 0.22,
    );

    final rectPaint = Paint()..color = const Color(0xFF4285F4);
    canvas.drawRect(
      Rect.fromLTWH(cx, cy - size.height * 0.14, r + 2, size.height * 0.28),
      rectPaint,
    );
    canvas.drawRect(
      Rect.fromLTWH(cx - r * 0.3, cy - size.height * 0.14, r * 1.3, size.height * 0.28),
      rectPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
