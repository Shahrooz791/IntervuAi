import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intervu_ai/core/utils/routes.dart';

class AuthController extends GetxController {
  // Login
  final loginEmailCtrl = TextEditingController();
  final loginPasswordCtrl = TextEditingController();
  final loginFormKey = GlobalKey<FormState>();
  final RxBool isLoginLoading = false.obs;

  // Signup
  final signupNameCtrl = TextEditingController();
  final signupEmailCtrl = TextEditingController();
  final signupPasswordCtrl = TextEditingController();
  final signupConfirmPasswordCtrl = TextEditingController();
  final signupFormKey = GlobalKey<FormState>();
  final RxBool isSignupLoading = false.obs;
  final RxBool agreedToTerms = false.obs;
  final RxInt passwordStrength = 0.obs;

  // Forgot Password
  final forgotEmailCtrl = TextEditingController();
  final forgotFormKey = GlobalKey<FormState>();
  final RxBool isForgotLoading = false.obs;
  final RxBool resetEmailSent = false.obs;

  void updatePasswordStrength(String password) {
    int strength = 0;
    if (password.length >= 8) strength++;
    if (password.contains(RegExp(r'[A-Z]'))) strength++;
    if (password.contains(RegExp(r'[0-9]'))) strength++;
    if (password.contains(RegExp(r'[!@#\$&*~]'))) strength++;
    passwordStrength.value = strength;
  }

  String? validateEmail(String? val) {
    if (val == null || val.isEmpty) return 'Email is required';
    if (!GetUtils.isEmail(val)) return 'Enter a valid email';
    return null;
  }

  String? validatePassword(String? val) {
    if (val == null || val.isEmpty) return 'Password is required';
    if (val.length < 8) return 'Minimum 8 characters';
    return null;
  }

  String? validateName(String? val) {
    if (val == null || val.isEmpty) return 'Full name is required';
    if (val.trim().length < 2) return 'Enter a valid name';
    return null;
  }

  String? validateConfirmPassword(String? val) {
    if (val == null || val.isEmpty) return 'Please confirm your password';
    if (val != signupPasswordCtrl.text) return 'Passwords do not match';
    return null;
  }

  Future<void> login() async {
    if (!loginFormKey.currentState!.validate()) return;
    isLoginLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 1800));
    isLoginLoading.value = false;
    Get.offAllNamed(AppRoutes.home);
  }

  Future<void> signup() async {
    if (!signupFormKey.currentState!.validate()) return;
    if (!agreedToTerms.value) {
      Get.snackbar('Terms Required', 'Please agree to Terms of Service',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF1E293B),
          colorText: Colors.white);
      return;
    }
    isSignupLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 1800));
    isSignupLoading.value = false;
    Get.offAllNamed(AppRoutes.home);
  }

  Future<void> sendResetLink() async {
    if (!forgotFormKey.currentState!.validate()) return;
    isForgotLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 1600));
    isForgotLoading.value = false;
    resetEmailSent.value = true;
  }

  void resetForgotState() {
    resetEmailSent.value = false;
    forgotEmailCtrl.clear();
  }

  @override
  void onClose() {
    loginEmailCtrl.dispose();
    loginPasswordCtrl.dispose();
    signupNameCtrl.dispose();
    signupEmailCtrl.dispose();
    signupPasswordCtrl.dispose();
    signupConfirmPasswordCtrl.dispose();
    forgotEmailCtrl.dispose();
    super.onClose();
  }
}
