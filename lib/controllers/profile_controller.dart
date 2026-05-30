import 'package:get/get.dart';

class ProfileController extends GetxController {
  final RxString userName = 'Ahmed Khan'.obs;
  final RxString userRole = 'Flutter Developer'.obs;
  final RxString userInitials = 'AK'.obs;

  final RxString targetRole = 'Software Engineering'.obs;
  final RxString targetRoleSub = 'Flutter Dev'.obs;
  final RxString difficulty = 'Intermediate'.obs;
  final RxString language = 'English (US)'.obs;
  final RxString sessionLength = '15 mins'.obs;
  final RxString theme = 'Deep Space (Dark)'.obs;

  final RxBool dailyReminder = true.obs;
  final RxBool streakAlert = true.obs;
  final RxBool resultEmails = false.obs;

  void onEditProfile() {
    Get.snackbar(
      'Edit Profile',
      'Profile editing coming soon...',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void onTargetRoleTap() {
    Get.snackbar(
      'Target Role',
      'Change your target role',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void onDifficultyTap() {
    Get.snackbar(
      'Difficulty',
      'Change interview difficulty',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void onLanguageTap() {
    Get.snackbar(
      'Language',
      'Change language setting',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void onSessionLengthTap() {
    Get.snackbar(
      'Session Length',
      'Change session duration',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void toggleDailyReminder(bool val) => dailyReminder.value = val;
  void toggleStreakAlert(bool val) => streakAlert.value = val;
  void toggleResultEmails(bool val) => resultEmails.value = val;

  void onThemeTap() {
    Get.snackbar('Theme', 'Theme settings', snackPosition: SnackPosition.BOTTOM);
  }

  void onRateApp() {
    Get.snackbar('Rate App', 'Thank you for your support!',
        snackPosition: SnackPosition.BOTTOM);
  }

  void onShareApp() {
    Get.snackbar('Share App', 'Sharing IntervuAI...',
        snackPosition: SnackPosition.BOTTOM);
  }

  void onPrivacyPolicy() {
    Get.snackbar('Privacy Policy', 'Opening privacy policy...',
        snackPosition: SnackPosition.BOTTOM);
  }

  void onChangePassword() {
    Get.snackbar('Change Password', 'Opening password change...',
        snackPosition: SnackPosition.BOTTOM);
  }

  void onLogout() {
    Get.snackbar('Logout', 'Logging out...', snackPosition: SnackPosition.BOTTOM);
  }

  void onDeleteAccount() {
    Get.defaultDialog(
      title: 'Delete Account',
      middleText: 'Are you sure? This action cannot be undone.',
      textConfirm: 'Delete',
      textCancel: 'Cancel',
      onConfirm: () {
        Get.back();
        Get.snackbar('Account Deleted', 'Your account has been removed.',
            snackPosition: SnackPosition.BOTTOM);
      },
    );
  }
}
