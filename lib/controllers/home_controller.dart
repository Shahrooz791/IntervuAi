import 'package:get/get.dart';

class HomeController extends GetxController {
  final RxString userName = 'Ahmed'.obs;
  final RxString userInitials = 'AK'.obs;
  final RxInt sessions = 12.obs;
  final RxInt avgScore = 78.obs;
  final RxInt streak = 5.obs;

  final RxString selectedRole = ''.obs;
  final RxString selectedLevel = ''.obs;

  final RxList<Map<String, dynamic>> recentSessions = <Map<String, dynamic>>[
    {
      'title': 'Product Manager',
      'company': 'GOOGLE',
      'time': 'Yesterday',
      'score': 84,
      'color': 0xFF3B82F6,
    },
    {
      'title': 'Frontend Dev',
      'company': 'AMAZON',
      'time': '3 days ago',
      'score': 60,
      'color': 0xFFEF4444,
    },
    {
      'title': 'Data Scientist',
      'company': 'META',
      'time': '1 week ago',
      'score': 91,
      'color': 0xFF22C55E,
    },
  ].obs;

  String get greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning,';
    if (hour < 17) return 'Good afternoon,';
    return 'Good evening,';
  }

  void onMockInterviewTap() {
    Get.snackbar('Mock Interview', 'Starting AI voice session...',
        snackPosition: SnackPosition.BOTTOM);
  }

  void onResumeUploadTap() {
    Get.snackbar('Resume Upload', 'Upload your resume for tailored questions',
        snackPosition: SnackPosition.BOTTOM);
  }

  void onCompanyPrepTap() {
    Get.snackbar('Company Prep', 'Choose a company to target',
        snackPosition: SnackPosition.BOTTOM);
  }

  void onQuickQuizTap() {
    Get.snackbar('Quick Quiz', 'Daily brain warm-up starting...',
        snackPosition: SnackPosition.BOTTOM);
  }

  void onSessionTap(Map<String, dynamic> session) {
    Get.snackbar('Session Details', '${session['title']} at ${session['company']}',
        snackPosition: SnackPosition.BOTTOM);
  }

  void onSeeAllTap() {
    Get.snackbar('All Sessions', 'Coming soon...',
        snackPosition: SnackPosition.BOTTOM);
  }

  void onNotificationTap() {
    Get.snackbar('Notifications', 'No new notifications',
        snackPosition: SnackPosition.BOTTOM);
  }
}
