import 'package:get/get.dart';

class PracticeController extends GetxController {
  final RxString dailyChallengeTitle = 'Backend Dev — Hard Mode'.obs;
  final RxString dailyChallengeCountdown = '08:42:10'.obs;
  final RxBool aiRecommendationEnabled = false.obs;

  final RxList<Map<String, dynamic>> roleCards = <Map<String, dynamic>>[
    {
      'role': 'Flutter',
      'badge': '98% BEST',
      'isBest': true,
      'icon': 'phone_android',
    },
    {
      'role': 'Backend',
      'badge': '85% BEST',
      'isBest': true,
      'icon': 'dns',
    },
    {
      'role': 'Frontend',
      'badge': 'NEW',
      'isBest': false,
      'icon': 'web',
    },
  ].obs;

  final RxList<Map<String, dynamic>> practiceModes = <Map<String, dynamic>>[
    {
      'icon': 'mic_rounded',
      'title': 'Mock Interview',
      'subtitle': 'Full AI simulation',
      'isFeatured': true,
    },
    {
      'icon': 'description_outlined',
      'title': 'Resume Prep',
      'subtitle': 'Roast & Refine',
      'isFeatured': false,
    },
    {
      'icon': 'business_outlined',
      'title': 'Company Mode',
      'subtitle': 'Top-tier Prep',
      'isFeatured': false,
    },
    {
      'icon': 'bolt',
      'title': 'Quick Quiz',
      'subtitle': 'Daily Streaks',
      'isFeatured': false,
    },
    {
      'icon': 'psychology',
      'title': 'Behavioral',
      'subtitle': 'Soft Skills',
      'isFeatured': false,
    },
  ].obs;

  void onStartDailyChallenge() {
    Get.snackbar(
      'Daily Challenge',
      'Starting Backend Dev Hard Mode...',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void onMockInterviewTap() {
    Get.snackbar(
      'Mock Interview',
      'Starting AI voice session...',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void onResumePrepTap() {
    Get.snackbar(
      'Resume Prep',
      'Upload your resume to get feedback',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void onCompanyModeTap() {
    Get.snackbar(
      'Company Mode',
      'Preparing company-specific questions...',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void onQuickQuizTap() {
    Get.snackbar(
      'Quick Quiz',
      'Daily brain warm-up starting...',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void onBehavioralTap() {
    Get.snackbar(
      'Behavioral',
      'Soft skills practice starting...',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void onRoleTap(String role) {
    Get.snackbar(
      role,
      'Loading $role questions...',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void onExploreRecommendation() {
    Get.snackbar(
      'AI Recommendation',
      'Exploring State Management Deep Dive...',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void toggleAiRecommendation(bool val) {
    aiRecommendationEnabled.value = val;
  }
}
