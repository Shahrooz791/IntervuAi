import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  // ─── User Info ───────────────────────────────────────────────
  final RxString userName = 'Ahmed Khan'.obs;
  final RxString userRole = 'Flutter Developer'.obs;
  final RxString userInitials = 'AK'.obs;
  final RxString experienceLevel = '2-3 YEARS EXP'.obs;
  final RxString bio = ''.obs;
  final RxString linkedinUrl = ''.obs;

  // ─── Stats ───────────────────────────────────────────────────
  final RxInt totalSessions = 12.obs;
  final RxInt avgScore = 78.obs;
  final RxInt dayStreak = 5.obs;
  final RxInt bestScore = 92.obs;
  final RxInt weekSessions = 4.obs;
  final RxInt achievementsUnlocked = 8.obs;
  final RxInt totalAchievements = 20.obs;

  // ─── Settings Preferences ────────────────────────────────────
  final RxString targetRole = 'Flutter Developer'.obs;
  final RxString difficulty = 'Advanced'.obs;
  final RxString sessionLength = '15 mins'.obs;
  final RxString theme = 'Deep Space (Dark)'.obs;

  // ─── Toggles ─────────────────────────────────────────────────
  final RxBool dailyReminder = true.obs;
  final RxBool streakAlert = true.obs;
  final RxBool achievementAlerts = false.obs;

  // ─── Edit Profile State ──────────────────────────────────────
  final RxString selectedPhotoSource = ''.obs;
  final RxString selectedExpLevel = '2-3'.obs;
  final RxString selectedTargetRole = 'Product Design'.obs;
  final RxBool isSaving = false.obs;

  late TextEditingController fullNameCtrl;
  late TextEditingController jobTitleCtrl;
  late TextEditingController bioCtrl;
  late TextEditingController linkedinCtrl;

  final List<String> experienceOptions = ['0-1', '2-3', '4-6', '7+'];
  final List<String> targetRoles = [
    'Product Design',
    'Frontend Dev',
    'Flutter Dev',
    'Backend Dev',
    'Full Stack',
  ];

  final List<Map<String, dynamic>> avatarList = [
    {'id': 1, 'emoji': '👨‍💼'},
    {'id': 2, 'emoji': '👩‍💼'},
    {'id': 3, 'emoji': '👨‍🎤'},
    {'id': 4, 'emoji': '🧑‍💻'},
    {'id': 5, 'emoji': '👩‍🎨'},
    {'id': 6, 'emoji': '👩‍🦰'},
    {'id': 7, 'emoji': '👴'},
    {'id': 8, 'emoji': '👩‍🦳'},
    {'id': 9, 'emoji': '👨‍🦱'},
    {'id': 10, 'emoji': '🧕'},
    {'id': 11, 'emoji': '🧔'},
    {'id': 12, 'emoji': '🧑‍🦲'},
  ];
  final RxInt selectedAvatarId = 1.obs;

  @override
  void onInit() {
    super.onInit();
    fullNameCtrl = TextEditingController(text: userName.value);
    jobTitleCtrl = TextEditingController(text: userRole.value);
    bioCtrl = TextEditingController(text: bio.value);
    linkedinCtrl = TextEditingController(text: linkedinUrl.value);
  }

  @override
  void onClose() {
    fullNameCtrl.dispose();
    jobTitleCtrl.dispose();
    bioCtrl.dispose();
    linkedinCtrl.dispose();
    super.onClose();
  }

  // ─── Profile Actions ─────────────────────────────────────────
  void onEditProfile() => Get.toNamed('/edit-profile');

  void onSettingsTap() => Get.toNamed('/settings');

  void onViewProgressHistory() {
    Get.snackbar(
      'Progress History',
      'Coming soon...',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF1E293B),
      colorText: const Color(0xFFFFFFFF),
    );
  }

  void onLogout() {
    Get.defaultDialog(
      title: 'Log Out',
      middleText: 'Are you sure you want to log out?',
      textConfirm: 'Log Out',
      textCancel: 'Cancel',
      confirmTextColor: const Color(0xFFFFFFFF),
      buttonColor: const Color(0xFFEF4444),
      onConfirm: () {
        Get.back();
        Get.snackbar('Logged Out', 'See you next time!',
            snackPosition: SnackPosition.BOTTOM);
      },
    );
  }

  // ─── Edit Profile Actions ────────────────────────────────────
  void onCameraTap() {
    selectedPhotoSource.value = 'camera';
    Get.snackbar('Camera', 'Camera access coming soon',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF1E293B),
        colorText: const Color(0xFFFFFFFF));
  }

  void onGalleryTap() {
    selectedPhotoSource.value = 'gallery';
    Get.snackbar('Gallery', 'Gallery access coming soon',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF1E293B),
        colorText: const Color(0xFFFFFFFF));
  }

  void onAvatarTap() {
    selectedPhotoSource.value = 'avatar';
  }

  void selectAvatar(int id) => selectedAvatarId.value = id;

  void selectExpLevel(String level) => selectedExpLevel.value = level;

  void selectTargetRole(String role) => selectedTargetRole.value = role;

  Future<void> onSaveChanges() async {
    isSaving.value = true;
    await Future.delayed(const Duration(milliseconds: 1200));
    userName.value = fullNameCtrl.text.trim().isEmpty
        ? userName.value
        : fullNameCtrl.text.trim();
    userRole.value = jobTitleCtrl.text.trim().isEmpty
        ? userRole.value
        : jobTitleCtrl.text.trim();
    bio.value = bioCtrl.text.trim();
    linkedinUrl.value = linkedinCtrl.text.trim();
    _updateInitials();
    isSaving.value = false;
    Get.back();
    Get.snackbar('Profile Updated', 'Your changes have been saved.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF1E293B),
        colorText: const Color(0xFFFFFFFF));
  }

  void _updateInitials() {
    final parts = userName.value.trim().split(' ');
    if (parts.length >= 2) {
      userInitials.value =
          '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    } else if (parts.isNotEmpty && parts[0].isNotEmpty) {
      userInitials.value = parts[0][0].toUpperCase();
    }
  }

  // ─── Settings Actions ────────────────────────────────────────
  void toggleDailyReminder(bool val) => dailyReminder.value = val;
  void toggleStreakAlert(bool val) => streakAlert.value = val;
  void toggleAchievementAlerts(bool val) => achievementAlerts.value = val;

  void onTargetRoleTap() {
    Get.snackbar('Target Role', 'Change your target role',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF1E293B),
        colorText: const Color(0xFFFFFFFF));
  }

  void onDifficultyTap() {
    Get.snackbar('Difficulty', 'Change interview difficulty',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF1E293B),
        colorText: const Color(0xFFFFFFFF));
  }

  void onSessionLengthTap() {
    Get.snackbar('Session Length', 'Change session duration',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF1E293B),
        colorText: const Color(0xFFFFFFFF));
  }

  void onRateApp() {
    Get.snackbar('Rate App', 'Thank you for your support!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF1E293B),
        colorText: const Color(0xFFFFFFFF));
  }

  void onShareApp() {
    Get.snackbar('Share App', 'Sharing IntervuAI...',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF1E293B),
        colorText: const Color(0xFFFFFFFF));
  }

  void onPrivacyPolicy() {
    Get.snackbar('Privacy Policy', 'Opening privacy policy...',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF1E293B),
        colorText: const Color(0xFFFFFFFF));
  }

  void onFaq() {
    Get.snackbar('FAQ', 'Opening FAQ...',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF1E293B),
        colorText: const Color(0xFFFFFFFF));
  }

  void onChangePassword() {
    Get.snackbar('Change Password', 'Opening password change...',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF1E293B),
        colorText: const Color(0xFFFFFFFF));
  }

  void onSettingsLogout() {
    Get.defaultDialog(
      title: 'Log Out',
      middleText: 'Are you sure you want to log out?',
      textConfirm: 'Log Out',
      textCancel: 'Cancel',
      confirmTextColor: const Color(0xFFFFFFFF),
      buttonColor: const Color(0xFFEF4444),
      onConfirm: () {
        Get.back();
        Get.snackbar('Logged Out', 'See you next time!',
            snackPosition: SnackPosition.BOTTOM);
      },
    );
  }

  void onDeleteAccount() {
    Get.defaultDialog(
      title: 'Delete Account',
      middleText: 'This action is permanent and cannot be undone.',
      textConfirm: 'Delete',
      textCancel: 'Cancel',
      confirmTextColor: const Color(0xFFFFFFFF),
      buttonColor: const Color(0xFFEF4444),
      onConfirm: () {
        Get.back();
        Get.snackbar('Account Deleted', 'Your account has been removed.',
            snackPosition: SnackPosition.BOTTOM);
      },
    );
  }
}
