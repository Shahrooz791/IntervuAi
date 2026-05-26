import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intervu_ai/core/constants/app_colors.dart';
import 'package:intervu_ai/core/utils/size_utils.dart';
import 'package:intervu_ai/view/widgets/app_text.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen>
    with TickerProviderStateMixin {
  late AnimationController _headerController;
  late AnimationController _gridController;

  late Animation<double> _headerOpacity;
  late Animation<Offset> _headerSlide;

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
      duration: const Duration(milliseconds: 600),
    );

    _headerOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _headerController, curve: Curves.easeIn),
    );
    _headerSlide =
        Tween<Offset>(begin: const Offset(0, -0.2), end: Offset.zero).animate(
          CurvedAnimation(parent: _headerController, curve: Curves.easeOut),
        );

    for (int i = 0; i < _roles.length; i++) {
      final ctrl = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 400),
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
    _headerController.forward();
    for (int i = 0; i < _roles.length; i++) {
      await Future.delayed(Duration(milliseconds: 60 * i + 200));
      if (mounted) _cardControllers[i].forward();
    }
  }

  @override
  void dispose() {
    _headerController.dispose();
    for (final ctrl in _cardControllers) {
      ctrl.dispose();
    }
    super.dispose();
  }

  void _selectRole(String role) {
    setState(() => _selectedRole = role);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: Stack(
        children: [
          _buildGlowBg(),
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
                        Gap.v(24),
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

  Widget _buildGlowBg() {
    return Positioned(
      bottom: -80.v,
      left: -60.h,
      child: Container(
        width: 250.h,
        height: 250.h,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              AppColors.primaryBlue.withOpacity(0.1),
              AppColors.primaryBlue.withOpacity(0.0),
            ],
          ),
        ),
      ),
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
        final isActive = i <= 1;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(horizontal: 3.h),
          width: isActive ? 20.h : 8.h,
          height: 6.h,
          decoration: BoxDecoration(
            borderRadius: 100.r,
            gradient: isActive ? AppColors.primaryGradient : null,
            color: isActive ? null : AppColors.darkCardBorder,
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
                text: 'Step 2 of 3',
                fontSize: 12.fSize,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryCyan,
                height: 1.0,
              ),
              Gap.v(6),
              AppText(
                text: 'What role are you\npreparing for?',
                fontSize: 24.fSize,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
                height: 1.3,
              ),
              Gap.v(8),
              AppText(
                text:
                "We'll tailor your interview questions and AI simulations to match your career path.",
                fontSize: 13.fSize,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ],
          ),
        ),
      ),
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
        childAspectRatio: 1.65,
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
    final isEnabled = _selectedRole != null;
    return GestureDetector(
      onTap: isEnabled ? () => Get.toNamed('/experience-level') : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: double.infinity,
        height: 56.v,
        decoration: BoxDecoration(
          borderRadius: 100.r,
          gradient: isEnabled ? AppColors.primaryGradient : null,
          color: isEnabled ? null : AppColors.darkCard,
          boxShadow: isEnabled
              ? [
            BoxShadow(
              color: AppColors.primaryBlue.withOpacity(0.35),
              blurRadius: 20.h,
              offset: Offset(0, 8.v),
            ),
          ]
              : null,
        ),
        child: Center(
          child: AppText(
            text: 'Continue',
            fontSize: 16.fSize,
            fontWeight: FontWeight.w700,
            color: isEnabled ? AppColors.textPrimary : AppColors.textMuted,
            height: 1.0,
          ),
        ),
      ),
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
      duration: const Duration(milliseconds: 120),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.94).animate(
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
            duration: const Duration(milliseconds: 250),
            padding: EdgeInsets.symmetric(horizontal: 14.h, vertical: 14.v),
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
                  color: AppColors.primaryBlue.withOpacity(0.2),
                  blurRadius: 16.h,
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
                    Container(
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
                            : AppColors.textSecondary,
                        size: 18.h,
                      ),
                    ),
                    if (widget.isSelected)
                      Container(
                        width: 22.h,
                        height: 22.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: AppColors.primaryGradient,
                        ),
                        child: Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 13.h,
                        ),
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