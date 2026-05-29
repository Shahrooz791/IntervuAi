import 'package:flutter/material.dart';
import 'package:intervu_ai/core/constants/app_colors.dart';
import 'package:intervu_ai/core/utils/size_utils.dart';

class AuthBackground extends StatefulWidget {
  const AuthBackground({super.key});

  @override
  State<AuthBackground> createState() => _AuthBackgroundState();
}

class _AuthBackgroundState extends State<AuthBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat(reverse: true);

    _pulseAnim = Tween<double>(begin: 0.85, end: 1.15).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseAnim,
      builder: (_, __) => Stack(
        children: [
          Container(
            decoration: const BoxDecoration(gradient: AppColors.bgGradient),
          ),
          Positioned(
            top: -80.v,
            left: -60.h,
            child: Transform.scale(
              scale: _pulseAnim.value,
              child: Container(
                width: 260.h,
                height: 260.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.accentPurple.withOpacity(0.13),
                      AppColors.accentPurple.withOpacity(0.0),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -40.v,
            right: -50.h,
            child: Transform.scale(
              scale: (2.0 - _pulseAnim.value),
              child: Container(
                width: 220.h,
                height: 220.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.primaryBlue.withOpacity(0.12),
                      AppColors.primaryBlue.withOpacity(0.0),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 300.v,
            right: -30.h,
            child: Container(
              width: 160.h,
              height: 160.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primaryCyan.withOpacity(0.08),
                    AppColors.primaryCyan.withOpacity(0.0),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
