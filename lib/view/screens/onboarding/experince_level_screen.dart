import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intervu_ai/core/constants/app_colors.dart';
import 'package:intervu_ai/core/utils/size_utils.dart';
import 'package:intervu_ai/view/widgets/app_text.dart';

class ExperienceLevelScreen extends StatefulWidget {
  const ExperienceLevelScreen({super.key});

  @override
  State<ExperienceLevelScreen> createState() => _ExperienceLevelScreenState();
}

class _ExperienceLevelScreenState extends State<ExperienceLevelScreen>
    with TickerProviderStateMixin {
  late AnimationController _headerController;
  late AnimationController _cardsController;
  late AnimationController _buttonController;

  late Animation<double> _headerOpacity;
  late Animation<Offset> _headerSlide;
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
    ),
    _ExperienceLevel(
      title: 'Intermediate',
      subtitle: '2-5 years of experience',
      icon: Icons.rocket_launch_rounded,
    ),
    _ExperienceLevel(
      title: 'Expert',
      subtitle: 'Senior lead or manager',
      icon: Icons.bolt_rounded,
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
      duration: const Duration(milliseconds: 550),
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
        Tween<Offset>(begin: const Offset(0, -0.2), end: Offset.zero).animate(
          CurvedAnimation(parent: _headerController, curve: Curves.easeOut),
        );

    _cardsOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _cardsController, curve: Curves.easeIn),
    );
    _cardsSlide =
        Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero).animate(
          CurvedAnimation(parent: _cardsController, curve: Curves.easeOut),
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
    _headerController.forward();
    await Future.delayed(const Duration(milliseconds: 200));
    if (mounted) _cardsController.forward();
    await Future.delayed(const Duration(milliseconds: 300));
    if (mounted) _buttonController.forward();
  }

  @override
  void dispose() {
    _headerController.dispose();
    _cardsController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  void _selectLevel(String level) {
    setState(() => _selectedLevel = level);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: Stack(
        children: [
          _buildGlowEffects(),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTopBar(),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Gap.v(12),
                        _buildHeader(),
                        Gap.v(32),
                        _buildLevelCards(),
                        const Spacer(),
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

  Widget _buildGlowEffects() {
    return Stack(
      children: [
        Positioned(
          top: -100.v,
          right: -80.h,
          child: Container(
            width: 300.h,
            height: 300.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.primaryBlue.withOpacity(0.08),
                  AppColors.primaryBlue.withOpacity(0.0),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -60.v,
          left: -40.h,
          child: Container(
            width: 200.h,
            height: 200.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.primaryCyan.withOpacity(0.07),
                  AppColors.primaryCyan.withOpacity(0.0),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 14.v),
      child: Row(
        children: [
          _buildBackBtn(),
          const Spacer(),
          _buildStepIndicator(),
          const Spacer(),
          _buildBrandName(),
        ],
      ),
    );
  }

  Widget _buildBackBtn() {
    return GestureDetector(
      onTap: () => Get.back(),
      child: Container(
        width: 36.h,
        height: 36.h,
        decoration: BoxDecoration(
          color: AppColors.shimmer,
          borderRadius: 10.r,
          border: Border.all(color: AppColors.darkCardBorder),
        ),
        child: Icon(
          Icons.arrow_back_ios_new_rounded,
          color: AppColors.textPrimary,
          size: 16.h,
        ),
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Row(
      children: List.generate(3, (i) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(horizontal: 3.h),
          width: i == 2 ? 24.h : (i < 2 ? 14.h : 8.h),
          height: 6.h,
          decoration: BoxDecoration(
            borderRadius: 100.r,
            gradient: i <= 2 ? AppColors.primaryGradient : null,
            color: i > 2 ? AppColors.darkCardBorder : null,
          ),
        );
      }),
    );
  }

  Widget _buildBrandName() {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: 'ê',
            style: TextStyle(
              fontSize: 16.fSize,
              fontWeight: FontWeight.w700,
              fontFamily: 'Urbanist',
              color: AppColors.textPrimary,
            ),
          ),
          TextSpan(
            text: 'kip',
            style: TextStyle(
              fontSize: 16.fSize,
              fontWeight: FontWeight.w400,
              fontFamily: 'Urbanist',
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return AnimatedBuilder(
      animation: _headerController,
      builder: (_, __) => FadeTransition(
        opacity: _headerOpacity,
        child: SlideTransition(
          position: _headerSlide,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                text: 'STEP 3 OF 3',
                fontSize: 11.fSize,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryCyan,
                height: 1.0,
              ),
              Gap.v(8),
              AppText(
                text: "What's your current\nexperience level?",
                fontSize: 24.fSize,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
                height: 1.3,
              ),
            ],
          ),
        ),
      ),
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
                  animationDelay: index * 80,
                ),
              );
            }).toList(),
          ),
        ),
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
          child: Column(
            children: [
              _buildBeginButton(),
              Gap.v(14),
              AppText(
                text: 'You can change these settings later in profile',
                fontSize: 12.fSize,
                color: AppColors.textMuted,
                textAlign: TextAlign.center,
                height: 1.4,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBeginButton() {
    return GestureDetector(
      onTap: () => Get.offAllNamed('/home'),
      child: Container(
        width: double.infinity,
        height: 56.v,
        decoration: BoxDecoration(
          borderRadius: 100.r,
          gradient: AppColors.primaryGradient,
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryBlue.withOpacity(0.4),
              blurRadius: 24.h,
              offset: Offset(0, 10.v),
            ),
            BoxShadow(
              color: AppColors.primaryCyan.withOpacity(0.15),
              blurRadius: 40.h,
              spreadRadius: 2.h,
            ),
          ],
        ),
        child: Center(
          child: AppText(
            text: "Let's Begin 🚀",
            fontSize: 16.fSize,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
            height: 1.0,
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
  final int animationDelay;

  const _ExperienceLevelCard({
    required this.level,
    required this.isSelected,
    required this.onTap,
    required this.animationDelay,
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
            duration: const Duration(milliseconds: 280),
            padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 16.v),
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
                  color: AppColors.primaryBlue.withOpacity(0.18),
                  blurRadius: 20.h,
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
      duration: const Duration(milliseconds: 280),
      width: 44.h,
      height: 44.h,
      decoration: BoxDecoration(
        borderRadius: 12.r,
        color: widget.isSelected
            ? AppColors.primaryBlue.withOpacity(0.18)
            : AppColors.darkCardBorder,
      ),
      child: Icon(
        widget.level.icon,
        color: widget.isSelected
            ? AppColors.primaryCyan
            : AppColors.textSecondary,
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
      ],
    );
  }

  Widget _buildRadio() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: 22.h,
      height: 22.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: widget.isSelected ? AppColors.primaryGradient : null,
        color: widget.isSelected ? null : Colors.transparent,
        border: Border.all(
          color: widget.isSelected
              ? Colors.transparent
              : AppColors.darkCardBorder,
          width: 2,
        ),
        boxShadow: widget.isSelected
            ? [
          BoxShadow(
            color: AppColors.primaryBlue.withOpacity(0.4),
            blurRadius: 8.h,
          ),
        ]
            : null,
      ),
      child: widget.isSelected
          ? Icon(Icons.check_rounded, color: Colors.white, size: 13.h)
          : null,
    );
  }
}

class _ExperienceLevel {
  final String title;
  final String subtitle;
  final IconData icon;
  const _ExperienceLevel({
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}