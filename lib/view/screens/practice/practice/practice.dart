import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intervu_ai/controllers/practice_controller.dart';
import 'package:intervu_ai/core/constants/app_colors.dart';
import 'package:intervu_ai/core/utils/size_utils.dart';
import 'package:intervu_ai/view/widgets/app_text.dart';

class PracticeScreen extends StatefulWidget {
  const PracticeScreen({super.key});

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen>
    with TickerProviderStateMixin {
  late AnimationController _entryCtrl;
  late List<Animation<double>> _fadeAnims;
  late List<Animation<Offset>> _slideAnims;

  final _ctrl = Get.put(PracticeController());

  static const int _sectionCount = 5;

  @override
  void initState() {
    super.initState();
    _entryCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fadeAnims = List.generate(_sectionCount, (i) {
      final start = i * 0.15;
      final end = (start + 0.45).clamp(0.0, 1.0);
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: _entryCtrl, curve: Interval(start, end, curve: Curves.easeOut)),
      );
    });
    _slideAnims = List.generate(_sectionCount, (i) {
      final start = i * 0.15;
      final end = (start + 0.45).clamp(0.0, 1.0);
      return Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
          .animate(CurvedAnimation(
          parent: _entryCtrl,
          curve: Interval(start, end, curve: Curves.easeOut)));
    });
    Future.delayed(const Duration(milliseconds: 80), () {
      if (mounted) _entryCtrl.forward();
    });
  }

  @override
  void dispose() {
    _entryCtrl.dispose();
    super.dispose();
  }

  Widget _anim(int i, Widget child) => FadeTransition(
    opacity: _fadeAnims[i],
    child: SlideTransition(position: _slideAnims[i], child: child),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _entryCtrl,
          builder: (_, __) => Column(
            children: [
              _buildTopBar(),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 16.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Gap.v(16),
                      _anim(0, const _DailyChallengeBanner()),
                      Gap.v(24),
                      _anim(1, const _PracticeModesSection()),
                      Gap.v(24),
                      _anim(2, const _PickByRoleSection()),
                      Gap.v(24),
                      _anim(3, const _AiRecommendedSection()),
                      Gap.v(32),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 12.v),
      child: Row(
        children: [
          AppText(
            text: 'Practice',
            fontSize: 22.fSize,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
          const Spacer(),
          _IconBtn(icon: Icons.history_rounded, onTap: () {}),
          Gap.h(10),
          _IconBtn(icon: Icons.person_outline_rounded, onTap: () {}),
        ],
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _IconBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38.h,
        height: 38.h,
        decoration: BoxDecoration(
          borderRadius: 10.r,
          color: AppColors.darkCard,
          border: Border.all(color: AppColors.darkCardBorder),
        ),
        child: Icon(icon, color: AppColors.textSecondary, size: 18.h),
      ),
    );
  }
}

class _DailyChallengeBanner extends StatefulWidget {
  const _DailyChallengeBanner();

  @override
  State<_DailyChallengeBanner> createState() => _DailyChallengeBannerState();
}

class _DailyChallengeBannerState extends State<_DailyChallengeBanner>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseCtrl;
  late Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
    _pulse = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<PracticeController>();
    return AnimatedBuilder(
      animation: _pulse,
      builder: (_, __) => Container(
        width: double.infinity,
        padding: EdgeInsets.all(20.h),
        decoration: BoxDecoration(
          borderRadius: 20.r,
          gradient: AppColors.challengeGradient,
          border: Border.all(
            color: AppColors.primaryBlue
                .withOpacity(0.25 + 0.15 * _pulse.value),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryBlue
                  .withOpacity(0.08 + 0.06 * _pulse.value),
              blurRadius: 20.h,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding:
              EdgeInsets.symmetric(horizontal: 10.h, vertical: 4.v),
              decoration: BoxDecoration(
                borderRadius: 100.r,
                color: AppColors.errorRed.withOpacity(0.2),
                border:
                Border.all(color: AppColors.errorRed.withOpacity(0.5)),
              ),
              child: AppText(
                text: 'DAILY CHALLENGE',
                fontSize: 10.fSize,
                fontWeight: FontWeight.w800,
                color: AppColors.errorRed,
              ),
            ),
            Gap.v(10),
            Obx(() => AppText(
              text: ctrl.dailyChallengeTitle.value,
              fontSize: 18.fSize,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            )),
            Gap.v(6),
            Row(
              children: [
                Icon(Icons.timer_outlined,
                    color: AppColors.textSecondary, size: 14.h),
                Gap.h(4),
                AppText(
                  text: 'Resets in ',
                  fontSize: 12.fSize,
                  color: AppColors.textSecondary,
                ),
                Obx(() => AppText(
                  text: ctrl.dailyChallengeCountdown.value,
                  fontSize: 12.fSize,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryCyan,
                )),
              ],
            ),
            Gap.v(16),
            GestureDetector(
              onTap: ctrl.onStartDailyChallenge,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 14.v),
                decoration: BoxDecoration(
                  borderRadius: 12.r,
                  gradient: AppColors.primaryGradient,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryBlue.withOpacity(0.4),
                      blurRadius: 12.h,
                      offset: Offset(0, 4.v),
                    ),
                  ],
                ),
                child: Center(
                  child: AppText(
                    text: 'Start',
                    fontSize: 15.fSize,
                    fontWeight: FontWeight.w700,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PracticeModesSection extends StatelessWidget {
  const _PracticeModesSection();

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<PracticeController>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          text: 'Practice Modes',
          fontSize: 18.fSize,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        Gap.v(14),
        _MockInterviewCard(onTap: ctrl.onMockInterviewTap),
        Gap.v(12),
        Row(
          children: [
            Expanded(
              child: _ModeCard(
                icon: Icons.description_outlined,
                title: 'Resume Prep',
                subtitle: 'Roast & Refine',
                iconColor: AppColors.primaryCyan,
                iconBg: AppColors.iconBgTeal,
                onTap: ctrl.onResumePrepTap,
              ),
            ),
            Gap.h(12),
            Expanded(
              child: _ModeCard(
                icon: Icons.business_center_outlined,
                title: 'Company Mode',
                subtitle: 'Top-tier Prep',
                iconColor: AppColors.accentPurple,
                iconBg: AppColors.iconBgPurple,
                onTap: ctrl.onCompanyModeTap,
              ),
            ),
          ],
        ),
        Gap.v(12),
        Row(
          children: [
            Expanded(
              child: _ModeCard(
                icon: Icons.bolt_rounded,
                title: 'Quick Quiz',
                subtitle: 'Daily Streaks',
                iconColor: AppColors.warningAmber,
                iconBg: AppColors.iconBgOrange,
                onTap: ctrl.onQuickQuizTap,
              ),
            ),
            Gap.h(12),
            Expanded(
              child: _ModeCard(
                icon: Icons.favorite_border_rounded,
                title: 'Behavioral',
                subtitle: 'Soft Skills',
                iconColor: AppColors.successGreen,
                iconBg: AppColors.iconBgGreen,
                onTap: ctrl.onBehavioralTap,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _MockInterviewCard extends StatefulWidget {
  final VoidCallback onTap;
  const _MockInterviewCard({required this.onTap});

  @override
  State<_MockInterviewCard> createState() => _MockInterviewCardState();
}

class _MockInterviewCardState extends State<_MockInterviewCard>
    with SingleTickerProviderStateMixin {
  bool _pressed = false;
  late AnimationController _arrowCtrl;
  late Animation<Offset> _arrowAnim;

  @override
  void initState() {
    super.initState();
    _arrowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);
    _arrowAnim = Tween<Offset>(
        begin: const Offset(0, 0), end: const Offset(0.3, 0))
        .animate(CurvedAnimation(parent: _arrowCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _arrowCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        transform: _pressed
            ? (Matrix4.identity()..scale(0.97))
            : Matrix4.identity(),
        padding: EdgeInsets.all(18.h),
        decoration: BoxDecoration(
          borderRadius: 18.r,
          gradient: const LinearGradient(
            colors: [Color(0xFF0F1E3D), Color(0xFF0D2241)],
          ),
          border: Border.all(
            color: AppColors.primaryBlue.withOpacity(0.3),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryBlue.withOpacity(0.1),
              blurRadius: 16.h,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 50.h,
              height: 50.h,
              decoration: BoxDecoration(
                borderRadius: 14.r,
                color: AppColors.iconBgBlue,
              ),
              child: Icon(Icons.mic_rounded,
                  color: AppColors.primaryBlue, size: 24.h),
            ),
            Gap.h(16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    text: 'Mock Interview',
                    fontSize: 16.fSize,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                  Gap.v(2),
                  AppText(
                    text: 'Full AI simulation',
                    fontSize: 13.fSize,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),
            SlideTransition(
              position: _arrowAnim,
              child: Icon(Icons.arrow_forward_ios_rounded,
                  color: AppColors.primaryCyan, size: 16.h),
            ),
          ],
        ),
      ),
    );
  }
}

class _ModeCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color iconColor;
  final Color iconBg;
  final VoidCallback onTap;

  const _ModeCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.iconColor,
    required this.iconBg,
    required this.onTap,
  });

  @override
  State<_ModeCard> createState() => _ModeCardState();
}

class _ModeCardState extends State<_ModeCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        transform: _pressed
            ? (Matrix4.identity()..scale(0.96))
            : Matrix4.identity(),
        padding: EdgeInsets.all(16.h),
        decoration: BoxDecoration(
          borderRadius: 16.r,
          color: AppColors.darkCard,
          border: Border.all(color: AppColors.darkCardBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40.h,
              height: 40.h,
              decoration: BoxDecoration(
                borderRadius: 10.r,
                color: widget.iconBg,
              ),
              child:
              Icon(widget.icon, color: widget.iconColor, size: 20.h),
            ),
            Gap.v(12),
            AppText(
              text: widget.title,
              fontSize: 14.fSize,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
            Gap.v(2),
            AppText(
              text: widget.subtitle,
              fontSize: 12.fSize,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}

class _PickByRoleSection extends StatelessWidget {
  const _PickByRoleSection();

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<PracticeController>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          text: 'Pick by Role',
          fontSize: 18.fSize,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        Gap.v(14),
        Obx(() => SizedBox(
          height: 90.v,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: ctrl.roleCards.length,
            separatorBuilder: (_, __) => Gap.h(12),
            itemBuilder: (_, i) {
              final card = ctrl.roleCards[i];
              return _RoleChip(
                role: card['role'] as String,
                badge: card['badge'] as String,
                isBest: card['isBest'] as bool,
                onTap: () => ctrl.onRoleTap(card['role'] as String),
              );
            },
          ),
        )),
      ],
    );
  }
}

class _RoleChip extends StatefulWidget {
  final String role;
  final String badge;
  final bool isBest;
  final VoidCallback onTap;

  const _RoleChip({
    required this.role,
    required this.badge,
    required this.isBest,
    required this.onTap,
  });

  @override
  State<_RoleChip> createState() => _RoleChipState();
}

class _RoleChipState extends State<_RoleChip> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        transform:
        _pressed ? (Matrix4.identity()..scale(0.95)) : Matrix4.identity(),
        width: 100.h,
        padding: EdgeInsets.all(14.h),
        decoration: BoxDecoration(
          borderRadius: 16.r,
          color: AppColors.darkCard,
          border: Border.all(
            color: widget.isBest
                ? AppColors.primaryBlue.withOpacity(0.4)
                : AppColors.darkCardBorder,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppText(
              text: widget.role,
              fontSize: 14.fSize,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
            Gap.v(6),
            Container(
              padding:
              EdgeInsets.symmetric(horizontal: 6.h, vertical: 3.v),
              decoration: BoxDecoration(
                borderRadius: 100.r,
                color: widget.isBest
                    ? AppColors.primaryBlue.withOpacity(0.2)
                    : AppColors.successGreen.withOpacity(0.15),
              ),
              child: AppText(
                text: widget.badge,
                fontSize: 9.fSize,
                fontWeight: FontWeight.w700,
                color: widget.isBest
                    ? AppColors.primaryCyan
                    : AppColors.successGreen,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AiRecommendedSection extends StatelessWidget {
  const _AiRecommendedSection();

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<PracticeController>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          text: 'AI Recommended',
          fontSize: 18.fSize,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        Gap.v(14),
        Container(
          padding: EdgeInsets.all(18.h),
          decoration: BoxDecoration(
            borderRadius: 18.r,
            color: AppColors.darkCard,
            border: Border.all(color: AppColors.darkCardBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 42.h,
                    height: 42.h,
                    decoration: BoxDecoration(
                      borderRadius: 12.r,
                      color: AppColors.iconBgPurple,
                    ),
                    child: Icon(Icons.auto_awesome_rounded,
                        color: AppColors.accentPurple, size: 20.h),
                  ),
                  Gap.h(12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          text: 'State Management Deep Dive',
                          fontSize: 15.fSize,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                        Gap.v(4),
                        AppText(
                          text:
                          'Based on your last interview, you should focus on Redux & Provider patterns.',
                          fontSize: 12.fSize,
                          color: AppColors.textSecondary,
                          height: 1.5,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Gap.v(16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(() => _GlowToggle(
                    value: ctrl.aiRecommendationEnabled.value,
                    onChanged: ctrl.toggleAiRecommendation,
                  )),
                  GestureDetector(
                    onTap: ctrl.onExploreRecommendation,
                    child: Row(
                      children: [
                        AppText(
                          text: 'Explore',
                          fontSize: 13.fSize,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryCyan,
                        ),
                        Gap.h(4),
                        Icon(Icons.arrow_forward_rounded,
                            color: AppColors.primaryCyan, size: 14.h),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _GlowToggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  const _GlowToggle({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: 44.h,
        height: 24.v,
        decoration: BoxDecoration(
          borderRadius: 100.r,
          color: value ? AppColors.toggleActive : AppColors.toggleInactive,
          boxShadow: value
              ? [
            BoxShadow(
              color: AppColors.primaryBlue.withOpacity(0.4),
              blurRadius: 8.h,
            )
          ]
              : [],
        ),
        child: Padding(
          padding: EdgeInsets.all(2.h),
          child: AnimatedAlign(
            duration: const Duration(milliseconds: 250),
            alignment: value ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              width: 20.h,
              height: 20.h,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: AppColors.white),
            ),
          ),
        ),
      ),
    );
  }
}
