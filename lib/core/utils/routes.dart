import 'package:get/get.dart';
import 'package:intervu_ai/view/screens/onboarding/experince_level_screen.dart';
import 'package:intervu_ai/view/screens/onboarding/onboarding.dart';
import 'package:intervu_ai/view/screens/onboarding/role_section_screen.dart';
import 'package:intervu_ai/view/screens/splash/splash.dart';

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String roleSelection = '/role-selection';
  static const String experienceLevel = '/experience-level';

  static final List<GetPage> pages = [
    GetPage(name: splash, page: () => const SplashScreen()),
    GetPage(name: onboarding, page: () => const OnboardingScreen()),
    GetPage(name: roleSelection, page: () => const RoleSelectionScreen()),
    GetPage(name: experienceLevel, page: () => const ExperienceLevelScreen()),
  ];
}