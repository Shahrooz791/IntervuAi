import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intervu_ai/controllers/home_controller.dart';
import 'package:intervu_ai/core/constants/app_colors.dart';
import 'package:intervu_ai/core/utils/size_utils.dart';
import 'package:intervu_ai/view/widgets/app_button.dart';
import 'package:intervu_ai/view/widgets/app_text.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen>
    with TickerProviderStateMixin {
  late AnimationController _headerController;
  late AnimationController _badgeController;

  late Animation<double> _headerOpacity;
  late Animation<Offset> _headerSlide;
  late Animation<double> _badgeScale;

  final List<Animation<double>> _cardAnimations = [];
  final List<AnimationController> _cardControllers = [];

  String? _selectedRole;

  final List<_RoleItem> _roles = const [
    _RoleItem(title: 'Flutter Dev', icon: Icons.phone_android_rounded),
    _RoleItem(title: 'Backend Dev', icon: Icons.storage_rounded),
    _RoleItem(title: 'Frontend Dev', icon: Icons.code_rounded),
    _RoleItem(title: 'Data Scientist', icon: Icons.bar_chart_rounded),
    _RoleItem(title: 'Product Manager', icon: Icons.view_kanban_rounded),
    _RoleItem(title: 'UI/UX Designer', icon: Icons.brush_rounded),
    _RoleItem(title: 'DevOps Eng', icon: Icons.settings_ethernet_rounded),
    _RoleItem(title: 'Full Stack Dev', icon: Icons.layers_rounded),
  ];

  @override
  void initState() {
    super.initState();

    _headerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );
    _badgeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _headerOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _headerController, curve: Curves.easeIn),
    );
    _headerSlide =
        Tween<Offset>(begin: const Offset(0, 0.25), end: Offset.zero).animate(
          CurvedAnimation(parent: _headerController, curve: Curves.easeOutCubic),
        );
    _badgeScale = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _badgeController, curve: Curves.elasticOut),
    );

    for (int i = 0; i < _roles.length; i++) {
      final ctrl = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 420),
      );
      final anim = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: ctrl, curve: Curves.easeOutBack),
      );
      _cardControllers.add(ctrl);
      _cardAnimations.add(anim);
    }

    _startAnimations();
  }

  Future<void> _startAnimations() async {
    _badgeController.forward();
    await Future.delayed(const Duration(milliseconds: 100));
    _headerController.forward();
    for (int i = 0; i < _roles.length; i++) {
      await Future.delayed(Duration(milliseconds: 55 * i + 200));
      if (mounted) _cardControllers[i].forward();
    }
  }

  @override
  void dispose() {
    _headerController.dispose();
    _badgeController.dispose();
    for (final ctrl in _cardControllers) {
      ctrl.dispose();
    }
    super.dispose();
  }

  void _selectRole(String role) => setState(() => _selectedRole = role);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: Stack(
        children: [
          _buildGlowOrb(
            top: -80.v,
            right: -60.h,
            color: AppColors.accentPurple,
            size: 260.h,
            opacity: 0.10,
          ),
          _buildGlowOrb(
            bottom: -100.v,
            left: -50.h,
            color: AppColors.primaryBlue,
            size: 220.h,
            opacity: 0.09,
          ),
          _buildGlowOrb(
            top: 300.v,
            right: -40.h,
            color: AppColors.primaryCyan,
            size: 160.h,
            opacity: 0.07,
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
                      children: [
                        Expanded(child: _buildRoleGrid()),
                        Gap.v(16),
                        _buildContinueButton(),
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
                      text: 'What role are you\npreparing for?',
                      fontSize: 26.fSize,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                      height: 1.3,
                    ),
                    Gap.v(10),
                    AppText(
                      text:
                      "We'll tailor your questions and AI simulations to match your career path.",
                      fontSize: 13.fSize,
                      color: AppColors.textSecondary,
                      height: 1.55,
                    ),
                    Gap.v(20),
                    _buildProgressBar(),
                    Gap.v(20),
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
            AppColors.primaryBlue.withOpacity(0.18),
            AppColors.primaryCyan.withOpacity(0.12),
          ],
        ),
        border: Border.all(
          color: AppColors.primaryCyan.withOpacity(0.35),
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
              color: AppColors.primaryCyan,
            ),
          ),
          Gap.h(7),
          AppText(
            text: 'AI POWERED',
            fontSize: 11.fSize,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryCyan,
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
              text: 'Select your role',
              fontSize: 11.fSize,
              fontWeight: FontWeight.w600,
              color: AppColors.textMuted,
              height: 1.0,
            ),
            AppText(
              text: '1 of 2',
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
            FractionallySizedBox(
              widthFactor: 0.5,
              child: Container(
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
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRoleGrid() {
    return GridView.builder(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12.v,
        crossAxisSpacing: 12.h,
        childAspectRatio: 1.6,
      ),
      itemCount: _roles.length,
      itemBuilder: (_, index) {
        final role = _roles[index];
        final isSelected = _selectedRole == role.title;
        return AnimatedBuilder(
          animation: _cardAnimations[index],
          builder: (_, __) => Transform.scale(
            scale: _cardAnimations[index].value,
            child: Opacity(
              opacity: _cardAnimations[index].value.clamp(0.0, 1.0),
              child: _RoleCard(
                role: role,
                isSelected: isSelected,
                onTap: () => _selectRole(role.title),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContinueButton() {
    return AppButton(
      text: 'Continue',
      onTap: _selectedRole != null
          ? () {
              Get.find<HomeController>().selectedRole.value = _selectedRole!;
              Get.toNamed('/experience-level');
            }
          : null,
    );
  }
}

class _RoleCard extends StatefulWidget {
  final _RoleItem role;
  final bool isSelected;
  final VoidCallback onTap;

  const _RoleCard({
    required this.role,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_RoleCard> createState() => _RoleCardState();
}

class _RoleCardState extends State<_RoleCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _tapCtrl;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _tapCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 110),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.93).animate(
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
            duration: const Duration(milliseconds: 240),
            padding: EdgeInsets.all(14.h),
            decoration: BoxDecoration(
              borderRadius: 16.r,
              color: widget.isSelected
                  ? AppColors.cardSelected
                  : AppColors.cardUnselected,
              border: Border.all(
                color: widget.isSelected
                    ? AppColors.cardSelectedBorder
                    : AppColors.cardUnselectedBorder,
                width: widget.isSelected ? 1.5 : 1,
              ),
              boxShadow: widget.isSelected
                  ? [
                BoxShadow(
                  color: AppColors.primaryBlue.withOpacity(0.22),
                  blurRadius: 18.h,
                  spreadRadius: 1.h,
                ),
              ]
                  : null,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 240),
                      width: 36.h,
                      height: 36.h,
                      decoration: BoxDecoration(
                        borderRadius: 10.r,
                        color: widget.isSelected
                            ? AppColors.primaryBlue.withOpacity(0.2)
                            : AppColors.darkCardBorder,
                      ),
                      child: Icon(
                        widget.role.icon,
                        color: widget.isSelected
                            ? AppColors.primaryCyan
                            : AppColors.textMuted,
                        size: 18.h,
                      ),
                    ),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      transitionBuilder: (child, anim) => ScaleTransition(
                        scale: anim,
                        child: child,
                      ),
                      child: widget.isSelected
                          ? Container(
                        key: const ValueKey('check'),
                        width: 20.h,
                        height: 20.h,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: AppColors.primaryGradient,
                        ),
                        child: Icon(
                          Icons.check_rounded,
                          color: AppColors.white,
                          size: 12.h,
                        ),
                      )
                          : const SizedBox.shrink(key: ValueKey('empty')),
                    ),
                  ],
                ),
                AppText(
                  text: widget.role.title,
                  fontSize: 13.fSize,
                  fontWeight: FontWeight.w600,
                  color: widget.isSelected
                      ? AppColors.textPrimary
                      : AppColors.textSecondary,
                  height: 1.2,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RoleItem {
  final String title;
  final IconData icon;
  const _RoleItem({required this.title, required this.icon});
}