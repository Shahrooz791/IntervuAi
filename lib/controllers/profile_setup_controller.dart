import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intervu_ai/core/utils/routes.dart';

class ProfileSetupController extends GetxController {
  final displayNameCtrl = TextEditingController();
  final jobTitleCtrl = TextEditingController();
  final targetCompaniesCtrl = TextEditingController();
  final setupFormKey = GlobalKey<FormState>();

  final RxString selectedExperience = '0-1'.obs;
  final RxString selectedPhotoSource = ''.obs;
  final RxBool isSaving = false.obs;
  final RxBool hasPhoto = false.obs;

  final List<String> experienceOptions = ['0-1', '2-3', '4-6', '7+'];

  void selectExperience(String value) {
    selectedExperience.value = value;
  }

  void onCameraTap() {
    selectedPhotoSource.value = 'camera';
    hasPhoto.value = true;
    Get.snackbar(
      'Camera',
      'Camera access coming soon',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF1E293B),
      colorText: const Color(0xFFFFFFFF),
    );
  }

  void onGalleryTap() {
    selectedPhotoSource.value = 'gallery';
    hasPhoto.value = true;
    Get.snackbar(
      'Gallery',
      'Gallery access coming soon',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF1E293B),
      colorText: const Color(0xFFFFFFFF),
    );
  }

  void onAvatarTap() {
    selectedPhotoSource.value = 'avatar';
    hasPhoto.value = true;
    Get.snackbar(
      'Avatar',
      'Avatar selection coming soon',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF1E293B),
      colorText: const Color(0xFFFFFFFF),
    );
  }

  String? validateDisplayName(String? val) {
    if (val == null || val.trim().isEmpty) return 'Display name is required';
    if (val.trim().length < 2) return 'Name must be at least 2 characters';
    return null;
  }

  String? validateJobTitle(String? val) {
    if (val == null || val.trim().isEmpty) return 'Job title is required';
    return null;
  }

  Future<void> saveAndContinue() async {
    if (!setupFormKey.currentState!.validate()) return;
    isSaving.value = true;
    await Future.delayed(const Duration(milliseconds: 1600));
    isSaving.value = false;
    Get.offAllNamed(AppRoutes.home);
  }

  @override
  void onClose() {
    displayNameCtrl.dispose();
    jobTitleCtrl.dispose();
    targetCompaniesCtrl.dispose();
    super.onClose();
  }
}
