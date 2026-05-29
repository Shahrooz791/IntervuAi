import 'package:flutter/material.dart';
import 'package:intervu_ai/core/constants/app_colors.dart';
import 'package:intervu_ai/core/utils/size_utils.dart';
import 'package:intervu_ai/view/widgets/app_text.dart';

class StatsRow extends StatelessWidget {
  final int sessions;
  final int avgScore;
  final int streak;

  const StatsRow({
    super.key,
    required this.sessions,
    required this.avgScore,
    required this.streak,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _StatCard(label: 'Sessions', value: '$sessions')),
        Gap.h(10),
        Expanded(
          child: _StatCard(
            label: 'Avg Score',
            value: '$avgScore',
            isHighlighted: true,
          ),
        ),
        Gap.h(10),
        Expanded(child: _StatCard(label: 'Streak', value: '$streak')),
      ],
    );
  }
}

class _StatCard extends StatefulWidget {
  final String label;
  final String value;
  final bool isHighlighted;

  const _StatCard({
    required this.label,
    required this.value,
    this.isHighlighted = false,
  });

  @override
  State<_StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<_StatCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _countCtrl;
  late Animation<double> _countAnim;
  bool _pressed = false;

  @override
  void initState() {
    super.initState();
    _countCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..forward();

    _countAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _countCtrl, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _countCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final numVal = int.tryParse(widget.value) ?? 0;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        transform: _pressed
            ? (Matrix4.identity()..scale(0.96))
            : Matrix4.identity(),
        padding: EdgeInsets.symmetric(vertical: 16.v, horizontal: 8.h),
        decoration: BoxDecoration(
          borderRadius: 16.r,
          color: widget.isHighlighted
              ? AppColors.cardSelected
              : AppColors.darkCard,
          border: Border.all(
            color: widget.isHighlighted
                ? AppColors.cardSelectedBorder.withOpacity(0.5)
                : AppColors.darkCardBorder,
          ),
        ),
        child: Column(
          children: [
            AppText(
              text: widget.label,
              fontSize: 12.fSize,
              color: AppColors.textSecondary,
              textAlign: TextAlign.center,
            ),
            Gap.v(4),
            AnimatedBuilder(
              animation: _countAnim,
              builder: (_, __) => AppText(
                text: '${(numVal * _countAnim.value).round()}',
                fontSize: 22.fSize,
                fontWeight: FontWeight.w800,
                color: AppColors.primaryCyan,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
