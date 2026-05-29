import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intervu_ai/controllers/home_controller.dart';
import 'package:intervu_ai/core/constants/app_colors.dart';
import 'package:intervu_ai/core/utils/size_utils.dart';
import 'package:intervu_ai/view/widgets/app_button.dart';
import 'package:intervu_ai/view/widgets/app_text.dart';

class ExperienceLevelScreen extends StatefulWidget {
  const ExperienceLevelScreen({super.key});

  @override
  State<ExperienceLevelScreen> createState() => _ExperienceLevelScreenState();
}

class _ExperienceLevelScreenState extends State<ExperienceLevelScreen>
  with TickerProviderStateMixin {
  late AnimationController _headerController;
  late AnimationController _badgeController;
  late AnimationController _cardsController;
  late AnimationController _buttonController;

  late Animation<double> _headerOpacity;
  late Animation<Offset> _headerSlide;
  late Animation<double> _badgeScale;
  late Animation<double> _cardsOpacity;
  late Animation<Offset> _cardsSlide;
  late Animation<double> _buttonOpacity;
  late Animation<Offset> _buttonSlide;

  String _selectedLevel = 'Intermediate';

  final List<_ExperienceLevel> _levels = const [
    _ExperienceLevel(
      title: 'Beginner',
      subtitle: 'Looking for my first role',
      icon: Icons.school_rounded,
      description: 'Fresh start with guided fundamentals and easy questions.',
    ),
    _ExperienceLevel(
      title: 'Intermediate',
      subtitle: '2-5 years of experience',
      icon: Icons.rocket_launch_rounded,
      description: 'Mid-level challenges with real-world problem scenarios.',
    ),
    _ExperienceLevel(
      title: 'Expert',
      subtitle: 'Senior lead or manager',
      icon: Icons.bolt_rounded,
      description: 'Advanced system design, leadership and architecture topics.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initControllers();
    _startAnimations();
  }

  void _initControllers() {
    _headerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _badgeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _cardsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _buttonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _headerOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _headerController, curve: Curves.easeIn),
    );
    _headerSlide =
        Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
          CurvedAnimation(parent: _headerController, curve: Curves.easeOutCubic),
        );
    _badgeScale = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _badgeController, curve: Curves.elasticOut),
    );
    _cardsOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _cardsController, curve: Curves.easeIn),
    );
    _cardsSlide =
        Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero).animate(
          CurvedAnimation(parent: _cardsController, curve: Curves.easeOutCubic),
        );
    _buttonOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.easeIn),
    );
    _buttonSlide =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _buttonController, curve: Curves.easeOut),
        );
  }

  Future<void> _startAnimations() async {
    _badgeController.forward();
    await Future.delayed(const Duration(milliseconds: 100));
    if (mounted) _headerController.forward();
    await Future.delayed(const Duration(milliseconds: 220));
    if (mounted) _cardsController.forward();
    await Future.delayed(const Duration(milliseconds: 350));
    if (mounted) _buttonController.forward();
  }

  @override
  void dispose() {
    _headerController.dispose();
    _badgeController.dispose();
    _cardsController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  void _selectLevel(String level) => setState(() => _selectedLevel = level);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: Stack(
        children: [
          _buildGlowOrb(
            top: -100.v,
            right: -80.h,
            color: AppColors.primaryBlue,
            size: 300.h,
            opacity: 0.08,
          ),
          _buildGlowOrb(
            bottom: -60.v,
            left: -40.h,
            color: AppColors.primaryCyan,
            size: 220.h,
            opacity: 0.07,
          ),
          _buildGlowOrb(
            top: 200.v,
            left: -30.h,
            color: AppColors.accentPurple,
            size: 150.h,
            opacity: 0.06,
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLevelCards(),
                        const Spacer(),
                        _buildInfoBanner(),
                        Gap.v(16),
                        _buildBottomSection(),
                        Gap.v(24),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlowOrb({
    double? top,
    double? bottom,
    double? left,
    double? right,
    required Color color,
    required double size,
    required double opacity,
  }) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              color.withOpacity(opacity),
              color.withOpacity(0.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.fromLTRB(24.h, 28.v, 24.h, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedBuilder(
            animation: _badgeController,
            builder: (_, __) => Transform.scale(
              scale: _badgeScale.value,
              alignment: Alignment.centerLeft,
              child: _buildAiBadge(),
            ),
          ),
          Gap.v(16),
          AnimatedBuilder(
            animation: _headerController,
            builder: (_, __) => FadeTransition(
              opacity: _headerOpacity,
              child: SlideTransition(
                position: _headerSlide,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      text: "What's your current\nexperience level?",
                      fontSize: 26.fSize,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                      height: 1.3,
                    ),
                    Gap.v(10),
                    AppText(
                      text:
                      'Your level helps us calibrate question difficulty and pacing for best results.',
                      fontSize: 13.fSize,
                      color: AppColors.textSecondary,
                      height: 1.55,
                    ),
                    Gap.v(20),
                    _buildProgressBar(),
                    Gap.v(24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAiBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.h, vertical: 7.v),
      decoration: BoxDecoration(
        borderRadius: 100.r,
        gradient: LinearGradient(
          colors: [
            AppColors.accentPurple.withOpacity(0.18),
            AppColors.primaryBlue.withOpacity(0.12),
          ],
        ),
        border: Border.all(
          color: AppColors.accentPurple.withOpacity(0.35),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6.h,
            height: 6.h,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.accentPurple,
            ),
          ),
          Gap.h(7),
          AppText(
            text: 'PERSONALIZED FOR YOU',
            fontSize: 11.fSize,
            fontWeight: FontWeight.w700,
            color: AppColors.accentPurple,
            height: 1.0,
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText(
              text: 'Choose your level',
              fontSize: 11.fSize,
              fontWeight: FontWeight.w600,
              color: AppColors.textMuted,
              height: 1.0,
            ),
            AppText(
              text: '2 of 2',
              fontSize: 11.fSize,
              fontWeight: FontWeight.w600,
              color: AppColors.textMuted,
              height: 1.0,
            ),
          ],
        ),
        Gap.v(8),
        Stack(
          children: [
            Container(
              height: 3.v,
              decoration: BoxDecoration(
                borderRadius: 100.r,
                color: AppColors.darkCardBorder,
              ),
            ),
            Container(
              height: 3.v,
              decoration: BoxDecoration(
                borderRadius: 100.r,
                gradient: AppColors.primaryGradient,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryCyan.withOpacity(0.4),
                    blurRadius: 6.h,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLevelCards() {
    return AnimatedBuilder(
      animation: _cardsController,
      builder: (_, __) => FadeTransition(
        opacity: _cardsOpacity,
        child: SlideTransition(
          position: _cardsSlide,
          child: Column(
            children: _levels.asMap().entries.map((entry) {
              final index = entry.key;
              final level = entry.value;
              final isSelected = _selectedLevel == level.title;
              return Padding(
                padding: EdgeInsets.only(
                  bottom: index < _levels.length - 1 ? 12.v : 0,
                ),
                child: _ExperienceLevelCard(
                  level: level,
                  isSelected: isSelected,
                  onTap: () => _selectLevel(level.title),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoBanner() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 12.v),
      decoration: BoxDecoration(
        borderRadius: 14.r,
        color: AppColors.primaryBlue.withOpacity(0.07),
        border: Border.all(
          color: AppColors.primaryBlue.withOpacity(0.18),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline_rounded,
            color: AppColors.primaryCyan,
            size: 16.h,
          ),
          Gap.h(10),
          Expanded(
            child: AppText(
              text: 'You can change these settings anytime from your profile.',
              fontSize: 12.fSize,
              color: AppColors.textSecondary,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSection() {
    return AnimatedBuilder(
      animation: _buttonController,
      builder: (_, __) => FadeTransition(
        opacity: _buttonOpacity,
        child: SlideTransition(
          position: _buttonSlide,
          child: AppButton(
            text: "Let's Begin 🚀",
            onTap: () {
              Get.find<HomeController>().selectedLevel.value = _selectedLevel;
              Get.offAllNamed('/home');
            },
          ),
        ),
      ),
    );
  }
}

class _ExperienceLevelCard extends StatefulWidget {
  final _ExperienceLevel level;
  final bool isSelected;
  final VoidCallback onTap;

  const _ExperienceLevelCard({
    required this.level,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_ExperienceLevelCard> createState() => _ExperienceLevelCardState();
}

class _ExperienceLevelCardState extends State<_ExperienceLevelCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _tapCtrl;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _tapCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _tapCtrl, curve: Curves.easeIn),
    );
  }

  @override
  void dispose() {
    _tapCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _tapCtrl.forward(),
      onTapUp: (_) {
        _tapCtrl.reverse();
        widget.onTap();
      },
      onTapCancel: () => _tapCtrl.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnim,
        builder: (_, __) => Transform.scale(
          scale: _scaleAnim.value,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 260),
            padding: EdgeInsets.all(16.h),
            decoration: BoxDecoration(
              borderRadius: 18.r,
              color: widget.isSelected
                  ? AppColors.expCardSelected
                  : AppColors.darkCard,
              border: Border.all(
                color: widget.isSelected
                    ? AppColors.expCardSelectedBorder
                    : AppColors.darkCardBorder,
                width: widget.isSelected ? 1.5 : 1,
              ),
              boxShadow: widget.isSelected
                  ? [
                BoxShadow(
                  color: AppColors.primaryBlue.withOpacity(0.20),
                  blurRadius: 22.h,
                  spreadRadius: 1.h,
                ),
              ]
                  : null,
            ),
            child: Row(
              children: [
                _buildIcon(),
                Gap.h(14),
                Expanded(child: _buildLabels()),
                _buildRadio(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 260),
      width: 46.h,
      height: 46.h,
      decoration: BoxDecoration(
        borderRadius: 13.r,
        gradient: widget.isSelected
            ? LinearGradient(
          colors: [
            AppColors.primaryBlue.withOpacity(0.25),
            AppColors.primaryCyan.withOpacity(0.15),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        )
            : null,
        color: widget.isSelected ? null : AppColors.darkCardBorder,
        border: widget.isSelected
            ? Border.all(
          color: AppColors.primaryBlue.withOpacity(0.3),
        )
            : null,
      ),
      child: Icon(
        widget.level.icon,
        color: widget.isSelected
            ? AppColors.primaryCyan
            : AppColors.textMuted,
        size: 22.h,
      ),
    );
  }

  Widget _buildLabels() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          text: widget.level.title,
          fontSize: 15.fSize,
          fontWeight: FontWeight.w700,
          color: widget.isSelected
              ? AppColors.textPrimary
              : AppColors.textSecondary,
          height: 1.2,
        ),
        Gap.v(3),
        AppText(
          text: widget.level.subtitle,
          fontSize: 12.fSize,
          color: widget.isSelected
              ? AppColors.textSecondary
              : AppColors.textMuted,
          height: 1.3,
        ),
        if (widget.isSelected) ...[
          Gap.v(6),
          AppText(
            text: widget.level.description,
            fontSize: 11.fSize,
            color: AppColors.primaryCyan.withOpacity(0.8),
            height: 1.4,
          ),
        ],
      ],
    );
  }

  Widget _buildRadio() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 240),
      width: 22.h,
      height: 22.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: widget.isSelected ? AppColors.primaryGradient : null,
        color: widget.isSelected ? null : Colors.transparent,
        border: widget.isSelected
            ? null
            : Border.all(
          color: AppColors.darkCardBorder,
          width: 2,
        ),
        boxShadow: widget.isSelected
            ? [
          BoxShadow(
            color: AppColors.primaryBlue.withOpacity(0.45),
            blurRadius: 8.h,
          ),
        ]
            : null,
      ),
      child: widget.isSelected
          ? Icon(Icons.check_rounded, color: AppColors.white, size: 13.h)
          : null,
    );
  }
}

class _ExperienceLevel {
  final String title;
  final String subtitle;
  final String description;
  final IconData icon;
  const _ExperienceLevel({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
  });
}