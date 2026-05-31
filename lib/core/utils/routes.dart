

import 'package:get/get.dart';
import 'package:intervu_ai/controllers/mock_interview_controller.dart';
import 'package:intervu_ai/view/screens/auth/forgot_pass/forgot_pass.dart';
import 'package:intervu_ai/view/screens/auth/login/login.dart';
import 'package:intervu_ai/view/screens/auth/signup/signup.dart';
import 'package:intervu_ai/view/screens/home/home/main_shell.dart';
import 'package:intervu_ai/view/screens/notifications/notification.dart';
import 'package:intervu_ai/view/screens/onboarding/experince_level_screen.dart';
import 'package:intervu_ai/view/screens/onboarding/onboarding.dart';
import 'package:intervu_ai/view/screens/onboarding/profile_setup.dart';
import 'package:intervu_ai/view/screens/onboarding/role_section_screen.dart';
import 'package:intervu_ai/view/screens/practice/answer_review/answer_review.dart';
import 'package:intervu_ai/view/screens/practice/company_prep/company_prep.dart';
import 'package:intervu_ai/view/screens/practice/live_session/live_session.dart';
import 'package:intervu_ai/view/screens/practice/mock_interview/mock_interview.dart';
import 'package:intervu_ai/view/screens/practice/resume_prep/resume_prep.dart';
import 'package:intervu_ai/view/screens/practice/session_result/session_result.dart';
import 'package:intervu_ai/view/screens/profile/edit_profile/edit_profile.dart';
import 'package:intervu_ai/view/screens/profile/settings/settings.dart';
import 'package:intervu_ai/view/screens/splash/splash.dart';

/// Binding that lazily registers [MockInterviewController] if not yet present.
class MockInterviewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MockInterviewController>(
      () => MockInterviewController(),
      fenix: true, // recreate if disposed
    );
  }
}

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
  static const String settings = '/settings';
  static const String editProfile = '/edit-profile';

  // Practice flow
  static const String mockInterview = '/mock-interview';
  static const String liveSession = '/live-session';
  static const String sessionResult = '/session-result';
  static const String companyPrep = '/company-prep';
  static const String resumePrep = '/resume-prep';
  static const String answerReview = '/answer-review';

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
    GetPage(
      name: settings,
      page: () => const SettingsScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: editProfile,
      page: () => const EditProfileScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),

    // ─── Practice Flow ────────────────────────────────────────
    GetPage(
      name: mockInterview,
      page: () => const MockInterviewScreen(),
      binding: MockInterviewBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: liveSession,
      page: () => const LiveSessionScreen(),
      binding: MockInterviewBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: sessionResult,
      page: () => const SessionResultScreen(),
      binding: MockInterviewBinding(),
      transition: Transition.upToDown,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: companyPrep,
      page: () => const CompanyPrepScreen(),
      binding: MockInterviewBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: resumePrep,
      page: () => const ResumePrepScreen(),
      binding: MockInterviewBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: answerReview,
      page: () => const AnswerReviewScreen(),
      binding: MockInterviewBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
  ];
}
