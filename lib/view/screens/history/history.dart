import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intervu_ai/controllers/history_controller.dart';
import 'package:intervu_ai/core/constants/app_colors.dart';
import 'package:intervu_ai/core/utils/size_utils.dart';
import 'package:intervu_ai/view/widgets/app_text.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _entryCtrl;
  late Animation<double> _headerFade;
  late Animation<Offset> _headerSlide;

  final _ctrl = Get.put(HistoryController());

  @override
  void initState() {
    super.initState();
    _entryCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _headerFade =
        CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOut);
    _headerSlide = Tween<Offset>(
        begin: const Offset(0, -0.15), end: Offset.zero)
        .animate(
        CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOut));
    Future.delayed(const Duration(milliseconds: 80), () {
      if (mounted) _entryCtrl.forward();
    });
  }

  @override
  void dispose() {
    _entryCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: SafeArea(
        child: Column(
          children: [
            FadeTransition(
              opacity: _headerFade,
              child: SlideTransition(
                position: _headerSlide,
                child: Column(
                  children: [
                    _buildTopBar(),
                    _buildSummaryRow(),
                    Gap.v(16),
                    _buildFilterChips(),
                    Gap.v(16),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Obx(() {
                final sessions = _ctrl.filteredSessions;
                if (sessions.isEmpty) {
                  return Center(
                    child: AppText(
                      text: 'No sessions found',
                      color: AppColors.textMuted,
                      fontSize: 14.fSize,
                    ),
                  );
                }
                return ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  padding:
                  EdgeInsets.symmetric(horizontal: 16.h).copyWith(bottom: 24.v),
                  itemCount: sessions.length,
                  separatorBuilder: (_, __) => Gap.v(12),
                  itemBuilder: (_, i) => _SessionCard(
                    data: sessions[i],
                    index: i,
                    onTap: () => _ctrl.onSessionTap(sessions[i]),
                    onRetry: () => _ctrl.onRetrySession(sessions[i]),
                  ),
                );
              }),
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(children: [
                    TextSpan(
                      text: 'Intervu',
                      style: TextStyle(
                        fontSize: 18.fSize,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Urbanist',
                        color: AppColors.textPrimary,
                      ),
                    ),
                    TextSpan(
                      text: 'AI',
                      style: TextStyle(
                        fontSize: 18.fSize,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'Urbanist',
                        foreground: Paint()
                          ..shader = const LinearGradient(
                            colors: [
                              AppColors.primaryBlue,
                              AppColors.primaryCyan
                            ],
                          ).createShader(Rect.fromLTWH(0, 0, 40, 24)),
                      ),
                    ),
                  ]),
                ),
                AppText(
                  text: 'Session History',
                  fontSize: 24.fSize,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ],
            ),
          ),
          Container(
            width: 38.h,
            height: 38.h,
            decoration: BoxDecoration(
              borderRadius: 10.r,
              color: AppColors.darkCard,
              border: Border.all(color: AppColors.darkCardBorder),
            ),
            child: Icon(Icons.search_rounded,
                color: AppColors.textSecondary, size: 18.h),
          ),
          Gap.h(8),
          Container(
            width: 38.h,
            height: 38.h,
            decoration: BoxDecoration(
              borderRadius: 10.r,
              color: AppColors.darkCard,
              border: Border.all(color: AppColors.darkCardBorder),
            ),
            child: Icon(Icons.tune_rounded,
                color: AppColors.textSecondary, size: 18.h),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.h),
      child: Obx(() => Row(
        children: [
          Expanded(
            flex: 2,
            child: _SummaryChip(
              label: 'TOTAL',
              value: '${_ctrl.totalSessions.value} Sessions',
              isLarge: true,
            ),
          ),
          Gap.h(12),
          Expanded(
            child: _SummaryChip(label: 'AVG', value: '${_ctrl.avgScore.value}'),
          ),
          Gap.h(12),
          Expanded(
            child: _SummaryChip(label: 'BEST', value: '${_ctrl.bestScore.value}'),
          ),
        ],
      )),
    );
  }

  Widget _buildFilterChips() {
    return Obx(() {
      final selected = _ctrl.selectedFilter.value;
      return SizedBox(
        height: 36.v,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 16.h),
          itemCount: _ctrl.filters.length,
          separatorBuilder: (_, __) => Gap.h(8),
          itemBuilder: (_, i) {
            final f = _ctrl.filters[i];
            final isActive = selected == f;
            return GestureDetector(
              onTap: () => _ctrl.selectFilter(f),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding:
                EdgeInsets.symmetric(horizontal: 14.h, vertical: 6.v),
                decoration: BoxDecoration(
                  borderRadius: 100.r,
                  color: isActive
                      ? AppColors.primaryBlue
                      : AppColors.darkCard,
                  border: Border.all(
                    color: isActive
                        ? AppColors.primaryBlue
                        : AppColors.darkCardBorder,
                  ),
                ),
                child: AppText(
                  text: f,
                  fontSize: 12.fSize,
                  fontWeight:
                  isActive ? FontWeight.w700 : FontWeight.w500,
                  color:
                  isActive ? AppColors.white : AppColors.textSecondary,
                ),
              ),
            );
          },
        ),
      );
    });
  }
}

class _SummaryChip extends StatelessWidget {
  final String label;
  final String value;
  final bool isLarge;

  const _SummaryChip({
    required this.label,
    required this.value,
    this.isLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          text: label,
          fontSize: 10.fSize,
          fontWeight: FontWeight.w700,
          color: AppColors.textMuted,
        ),
        Gap.v(2),
        AppText(
          text: value,
          fontSize: isLarge ? 16.fSize : 20.fSize,
          fontWeight: FontWeight.w800,
          color: AppColors.textPrimary,
        ),
      ],
    );
  }
}

class _SessionCard extends StatefulWidget {
  final Map<String, dynamic> data;
  final int index;
  final VoidCallback onTap;
  final VoidCallback onRetry;

  const _SessionCard({
    required this.data,
    required this.index,
    required this.onTap,
    required this.onRetry,
  });

  @override
  State<_SessionCard> createState() => _SessionCardState();
}

class _SessionCardState extends State<_SessionCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _anim;
  late Animation<double> _fade;
  late Animation<Offset> _slide;
  bool _pressed = false;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400 + widget.index * 80),
    );
    _fade = CurvedAnimation(parent: _anim, curve: Curves.easeOut);
    _slide =
        Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
          CurvedAnimation(parent: _anim, curve: Curves.easeOut),
        );
    Future.delayed(Duration(milliseconds: 100 + widget.index * 60), () {
      if (mounted) _anim.forward();
    });
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final score = widget.data['score'] as int;
    final scoreColor =
    Color(Get.find<HistoryController>().getScoreColor(score));
    final tagColor = Color(widget.data['tagColor'] as int);
    final tagTextColor = Color(widget.data['tagTextColor'] as int);

    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: GestureDetector(
          onTap: widget.onTap,
          onTapDown: (_) => setState(() => _pressed = true),
          onTapUp: (_) => setState(() => _pressed = false),
          onTapCancel: () => setState(() => _pressed = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            transform: _pressed
                ? (Matrix4.identity()..scale(0.98))
                : Matrix4.identity(),
            padding: EdgeInsets.all(16.h),
            decoration: BoxDecoration(
              borderRadius: 18.r,
              color: AppColors.darkCard,
              border: Border.all(color: AppColors.darkCardBorder),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.h, vertical: 4.v),
                      decoration: BoxDecoration(
                        borderRadius: 100.r,
                        color: tagColor,
                      ),
                      child: AppText(
                        text: widget.data['tag'] as String,
                        fontSize: 11.fSize,
                        fontWeight: FontWeight.w700,
                        color: tagTextColor,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      width: 44.h,
                      height: 44.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: scoreColor.withOpacity(0.15),
                        border: Border.all(
                            color: scoreColor.withOpacity(0.4), width: 2),
                      ),
                      child: Center(
                        child: AppText(
                          text: '$score',
                          fontSize: 15.fSize,
                          fontWeight: FontWeight.w800,
                          color: scoreColor,
                        ),
                      ),
                    ),
                  ],
                ),
                Gap.v(10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            text: widget.data['title'] as String,
                            fontSize: 16.fSize,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                          Gap.v(4),
                          AppText(
                            text:
                            '${widget.data['date']} · ${widget.data['time']} · ${widget.data['mode']} · ${widget.data['duration']}',
                            fontSize: 11.fSize,
                            color: AppColors.textMuted,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Gap.v(12),
                _SkillBars(
                  technical: widget.data['technical'] as int,
                  behavioral: widget.data['behavioral'] as int,
                  culture: widget.data['culture'] as int,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SkillBars extends StatefulWidget {
  final int technical;
  final int behavioral;
  final int culture;

  const _SkillBars({
    required this.technical,
    required this.behavioral,
    required this.culture,
  });

  @override
  State<_SkillBars> createState() => _SkillBarsState();
}

class _SkillBarsState extends State<_SkillBars>
    with SingleTickerProviderStateMixin {
  late AnimationController _barCtrl;
  late Animation<double> _barAnim;

  @override
  void initState() {
    super.initState();
    _barCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
    _barAnim =
        CurvedAnimation(parent: _barCtrl, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _barCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _barAnim,
      builder: (_, __) => Row(
        children: [
          _SkillLabel(
              label: 'TECHNICAL',
              value: widget.technical,
              progress: _barAnim.value,
              color: AppColors.progressTechnical),
          Gap.h(4),
          _SkillLabel(
              label: 'BEHAVIORAL',
              value: widget.behavioral,
              progress: _barAnim.value,
              color: AppColors.progressBehavioral),
          Gap.h(4),
          _SkillLabel(
              label: 'CULTURE',
              value: widget.culture,
              progress: _barAnim.value,
              color: AppColors.progressHR),
        ],
      ),
    );
  }
}

class _SkillLabel extends StatelessWidget {
  final String label;
  final int value;
  final double progress;
  final Color color;

  const _SkillLabel({
    required this.label,
    required this.value,
    required this.progress,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: AppText(
                  text: label,
                  fontSize: 9.fSize,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textMuted,
                  maxLines: 1,
                ),
              ),
              Gap.h(2),
              AppText(
                text: '${(value * progress).round()}%',
                fontSize: 10.fSize,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ],
          ),
          Gap.v(4),
          ClipRRect(
            borderRadius: 100.r,
            child: LinearProgressIndicator(
              value: (value / 100) * progress,
              minHeight: 4.v,
              backgroundColor: AppColors.progressBg,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }
}
