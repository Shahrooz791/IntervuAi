import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intervu_ai/controllers/bottom_nav_bar_controller.dart';
import 'package:intervu_ai/core/constants/app_colors.dart';
import 'package:intervu_ai/core/utils/bottom_nav_bar.dart';
import 'package:intervu_ai/view/screens/history/history.dart';
import 'package:intervu_ai/view/screens/home/home/home.dart';
import 'package:intervu_ai/view/screens/practice/practice.dart';
import 'package:intervu_ai/view/screens/profile/profile.dart';

class MainShell extends StatelessWidget {
  const MainShell({super.key});

  static final List<Widget> _pages = [
    const HomeScreen(),
    const PracticeScreen(),
    const HistoryScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<NavController>();
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: Obx(() => AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, anim) => FadeTransition(
          opacity: anim,
          child: child,
        ),
        child: KeyedSubtree(
          key: ValueKey(ctrl.currentIndex.value),
          child: _pages[ctrl.currentIndex.value],
        ),
      )),
      bottomNavigationBar: const AppBottomNavBar(),
    );
  }
}
