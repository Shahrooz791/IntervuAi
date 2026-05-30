import 'package:get/get.dart';
import 'package:intervu_ai/view/screens/auth/forgot_pass/forgot_pass.dart';
import 'package:intervu_ai/view/screens/auth/login/login.dart';
import 'package:intervu_ai/view/screens/auth/signup/signup.dart';
import 'package:intervu_ai/view/screens/home/home/main_shell.dart';
import 'package:intervu_ai/view/screens/notifications/notification.dart';
import 'package:intervu_ai/view/screens/onboarding/experince_level_screen.dart';
import 'package:intervu_ai/view/screens/onboarding/onboarding.dart';
import 'package:intervu_ai/view/screens/onboarding/profile_setup.dart';
import 'package:intervu_ai/view/screens/onboarding/role_section_screen.dart';
import 'package:intervu_ai/view/screens/splash/splash.dart';

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String roleSelection = '/role-selection';
  static const String experienceLevel = '/experience-level';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password';
  static const String profileSetup = '/profile-setup';
  static const String home = '/home';
  static const String notifications = '/notifications';

  static final List<GetPage> pages = [
    GetPage(name: splash, page: () => const SplashScreen()),
    GetPage(name: onboarding, page: () => const OnboardingScreen()),
    GetPage(name: roleSelection, page: () => const RoleSelectionScreen()),
    GetPage(name: experienceLevel, page: () => const ExperienceLevelScreen()),
    GetPage(name: login, page: () => const LoginScreen()),
    GetPage(name: signup, page: () => const SignupScreen()),
    GetPage(name: forgotPassword, page: () => const ForgotPasswordScreen()),
    GetPage(
      name: profileSetup,
      page: () => const ProfileSetupScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(name: home, page: () => const MainShell()),
    GetPage(
      name: notifications,
      page: () => const NotificationScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
  ];
}
