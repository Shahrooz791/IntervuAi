import 'package:flutter/material.dart';
import 'package:intervu_ai/core/constants/app_colors.dart';
import 'package:intervu_ai/core/utils/size_utils.dart';
import 'package:intervu_ai/view/widgets/app_text.dart';

class PracticeGrid extends StatelessWidget {
  final VoidCallback onMockInterview;
  final VoidCallback onResumeUpload;
  final VoidCallback onCompanyPrep;
  final VoidCallback onQuickQuiz;

  const PracticeGrid({
    super.key,
    required this.onMockInterview,
    required this.onResumeUpload,
    required this.onCompanyPrep,
    required this.onQuickQuiz,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _PracticeCard(
                icon: Icons.chat_bubble_outline_rounded,
                title: 'Mock Interview',
                subtitle: 'Real-time AI voice chat',
                iconColor: AppColors.primaryBlue,
                iconBg: AppColors.iconBgBlue,
                onTap: onMockInterview,
              ),
            ),
            Gap.h(12),
            Expanded(
              child: _PracticeCard(
                icon: Icons.description_outlined,
                title: 'Resume Upload',
                subtitle: 'Tailored questions',
                iconColor: AppColors.primaryCyan,
                iconBg: AppColors.iconBgTeal,
                onTap: onResumeUpload,
              ),
            ),
          ],
        ),
        Gap.v(12),
        Row(
          children: [
            Expanded(
              child: _PracticeCard(
                icon: Icons.business_outlined,
                title: 'Company Prep',
                subtitle: 'Specific targets',
                iconColor: AppColors.primaryBlue,
                iconBg: AppColors.iconBgBlue,
                onTap: onCompanyPrep,
              ),
            ),
            Gap.h(12),
            Expanded(
              child: _PracticeCard(
                icon: Icons.bolt_rounded,
                title: 'Quick Quiz',
                subtitle: 'Daily brain warm-up',
                iconColor: AppColors.warningAmber,
                iconBg: const Color(0xFF3D2A00),
                onTap: onQuickQuiz,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _PracticeCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color iconColor;
  final Color iconBg;
  final VoidCallback onTap;

  const _PracticeCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.iconColor,
    required this.iconBg,
    required this.onTap,
  });

  @override
  State<_PracticeCard> createState() => _PracticeCardState();
}

class _PracticeCardState extends State<_PracticeCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _pressCtrl;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _pressCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.95).animate(
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
            padding: EdgeInsets.all(16.h),
            decoration: BoxDecoration(
              borderRadius: 16.r,
              color: AppColors.darkCard,
              border: Border.all(color: AppColors.darkCardBorder),
              boxShadow: [
                BoxShadow(
                  color: AppColors.darkBg.withOpacity(0.5),
                  blurRadius: 8.h,
                  offset: Offset(0, 4.v),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44.h,
                  height: 44.h,
                  decoration: BoxDecoration(
                    borderRadius: 12.r,
                    color: widget.iconBg,
                  ),
                  child: Icon(
                    widget.icon,
                    color: widget.iconColor,
                    size: 22.h,
                  ),
                ),
                Gap.v(12),
                AppText(
                  text: widget.title,
                  fontSize: 14.fSize,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
                Gap.v(3),
                AppText(
                  text: widget.subtitle,
                  fontSize: 12.fSize,
                  color: AppColors.textSecondary,
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
