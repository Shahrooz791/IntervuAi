import 'package:flutter/material.dart';
import 'package:intervu_ai/core/constants/app_colors.dart';
import 'package:intervu_ai/core/utils/size_utils.dart';
import 'package:intervu_ai/view/widgets/app_text.dart';

class GreetingCard extends StatefulWidget {
  final String greeting;
  final String userName;
  final int streak;

  const GreetingCard({
    super.key,
    required this.greeting,
    required this.userName,
    required this.streak,
  });

  @override
  State<GreetingCard> createState() => _GreetingCardState();
}

class _GreetingCardState extends State<GreetingCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _shimmerCtrl;
  late Animation<double> _shimmerAnim;

  @override
  void initState() {
    super.initState();
    _shimmerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);

    _shimmerAnim = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _shimmerCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _shimmerCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.h),
      decoration: BoxDecoration(
        borderRadius: 20.r,
        gradient: const LinearGradient(
          colors: [Color(0xFF0F1E3D), Color(0xFF0D2241)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: AppColors.primaryBlue.withOpacity(0.25),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlue.withOpacity(0.1),
            blurRadius: 20.h,
            spreadRadius: 1.h,
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -10.h,
            top: -10.v,
            child: Icon(
              Icons.mic_rounded,
              size: 100.h,
              color: AppColors.primaryCyan.withOpacity(0.07),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStreakBadge(),
              Gap.v(12),
              Row(
                children: [
                  AppText(
                    text: '${widget.greeting} ${widget.userName} ',
                    fontSize: 22.fSize,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                  const Text('👋', style: TextStyle(fontSize: 20)),
                ],
              ),
              Gap.v(6),
              AppText(
                text: "Ready to ace your next big interview? Let's start a quick session.",
                fontSize: 13.fSize,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStreakBadge() {
    return AnimatedBuilder(
      animation: _shimmerAnim,
      builder: (_, __) => Container(
        padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 5.v),
        decoration: BoxDecoration(
          borderRadius: 100.r,
          gradient: LinearGradient(
            colors: [
              AppColors.primaryBlue.withOpacity(0.3),
              AppColors.primaryCyan.withOpacity(0.3),
            ],
          ),
          border: Border.all(
            color: AppColors.primaryBlue.withOpacity(0.4),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppText(
              text: '${widget.streak} DAY STREAK',
              fontSize: 11.fSize,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryCyan,
            ),
            Gap.h(6),
            Icon(
              Icons.local_fire_department_rounded,
              color: AppColors.warningAmber,
              size: 14.h,
            ),
          ],
        ),
      ),
    );
  }
}
