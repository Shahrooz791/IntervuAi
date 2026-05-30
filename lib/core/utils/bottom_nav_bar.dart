import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intervu_ai/controllers/bottom_nav_bar_controller.dart';
import 'package:intervu_ai/core/constants/app_colors.dart';
import 'package:intervu_ai/core/utils/size_utils.dart';

class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<NavController>();
    return Obx(() => _NavBarContent(
      currentIndex: ctrl.currentIndex.value,
      onTap: ctrl.changePage,
    ));
  }
}

class _NavBarContent extends StatelessWidget {
  final int currentIndex;
  final void Function(int) onTap;

  const _NavBarContent({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        border: Border(
          top: BorderSide(color: AppColors.darkCardBorder, width: 1),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 72.v,
          child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavItem(
              icon: Icons.home_rounded,
              label: 'Home',
              isActive: currentIndex == 0,
              onTap: () => onTap(0),
            ),
            _NavItem(
              icon: Icons.record_voice_over_rounded,
              label: 'Practice',
              isActive: currentIndex == 1,
              onTap: () => onTap(1),
            ),
            _NavItem(
              icon: Icons.history_rounded,
              label: 'History',
              isActive: currentIndex == 2,
              onTap: () => onTap(2),
            ),
            _NavItem(
              icon: Icons.person_rounded,
              label: 'Profile',
              isActive: currentIndex == 3,
              onTap: () => onTap(3),
            ),
          ],
        ),
      ),
      )
    );
  }
}

class _NavItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _anim;
  late Animation<double> _scale;
  late Animation<double> _indicatorWidth;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _scale = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _anim, curve: Curves.easeOutBack),
    );
    _indicatorWidth = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _anim, curve: Curves.easeOut),
    );

    if (widget.isActive) _anim.forward();
  }

  @override
  void didUpdateWidget(_NavItem old) {
    super.didUpdateWidget(old);
    if (widget.isActive && !old.isActive) {
      _anim.forward();
    } else if (!widget.isActive && old.isActive) {
      _anim.reverse();
    }
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedBuilder(
        animation: _anim,
        builder: (_, __) => SizedBox(
          width: 72.h,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Transform.scale(
                scale: _scale.value,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.all(8.h),
                  decoration: BoxDecoration(
                    borderRadius: 12.r,
                    color: widget.isActive
                        ? AppColors.primaryBlue.withOpacity(0.15)
                        : Colors.transparent,
                  ),
                  child: Icon(
                    widget.icon,
                    size: 22.h,
                    color: widget.isActive
                        ? AppColors.primaryCyan
                        : AppColors.textMuted,
                  ),
                ),
              ),
              Gap.v(4),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(
                  fontSize: 10.fSize,
                  fontFamily: 'Urbanist',
                  fontWeight:
                  widget.isActive ? FontWeight.w700 : FontWeight.w400,
                  color: widget.isActive
                      ? AppColors.primaryCyan
                      : AppColors.textMuted,
                ),
                child: Text(widget.label),
              ),
              Gap.v(4),
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                height: 3.v,
                width: widget.isActive ? 20.h : 0,
                decoration: BoxDecoration(
                  borderRadius: 100.r,
                  gradient: AppColors.primaryGradient,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
