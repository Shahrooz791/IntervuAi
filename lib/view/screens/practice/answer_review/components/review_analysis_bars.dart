import 'package:flutter/material.dart';
import 'package:intervu_ai/controllers/mock_interview_controller.dart';
import 'package:intervu_ai/core/constants/app_colors.dart';
import 'package:intervu_ai/core/utils/size_utils.dart';
import 'package:intervu_ai/view/widgets/app_text.dart';

class ReviewAnalysisBars extends StatefulWidget {
  final MockInterviewController ctrl;
  const ReviewAnalysisBars({super.key, required this.ctrl});

  @override
  State<ReviewAnalysisBars> createState() => _ReviewAnalysisBarsState();
}

class _ReviewAnalysisBarsState extends State<ReviewAnalysisBars>
    with SingleTickerProviderStateMixin {
  late AnimationController _barCtrl;
  late Animation<double> _barAnim;

  @override
  void initState() {
    super.initState();
    _barCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..forward();
    _barAnim = CurvedAnimation(parent: _barCtrl, curve: Curves.easeOutCubic);
  }

  @override
  void dispose() {
    _barCtrl.dispose();
    super.dispose();
  }

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
                  color: AppColors.iconBgPurple,
                ),
                child: Icon(Icons.auto_awesome_rounded,
                    color: AppColors.accentPurple, size: 14.h),
              ),
              Gap.h(10),
              AppText(
                text: 'AI Analysis',
                fontSize: 14.fSize,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ],
          ),
          Gap.v(14),
          AnimatedBuilder(
            animation: _barAnim,
            builder: (_, __) => Column(
              children: widget.ctrl.aiAnalysisMetrics.map((metric) {
                final color = Color(metric['color'] as int);
                final value = metric['value'] as int;
                return Padding(
                  padding: EdgeInsets.only(bottom: 12.v),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: AppText(
                              text: metric['label'] as String,
                              fontSize: 12.fSize,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          AppText(
                            text:
                            '${(value * _barAnim.value).round()}%',
                            fontSize: 12.fSize,
                            fontWeight: FontWeight.w700,
                            color: color,
                          ),
                        ],
                      ),
                      Gap.v(6),
                      ClipRRect(
                        borderRadius: 100.r,
                        child: LinearProgressIndicator(
                          value: (value / 100) * _barAnim.value,
                          minHeight: 6.v,
                          backgroundColor: AppColors.progressBg,
                          valueColor: AlwaysStoppedAnimation<Color>(color),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
