import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intervu_ai/controllers/auth_controller.dart';
import 'package:intervu_ai/core/constants/app_colors.dart';
import 'package:intervu_ai/core/utils/size_utils.dart';
import 'package:intervu_ai/view/screens/auth/forgot_pass/components/email_send_success.dart';
import 'package:intervu_ai/view/screens/auth/login/components/auth_breakground.dart';
import 'package:intervu_ai/view/widgets/app_button.dart';
import 'package:intervu_ai/view/widgets/app_text.dart';
import 'package:intervu_ai/view/widgets/app_textfield.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
    with TickerProviderStateMixin {
  late AnimationController _entryController;
  late AnimationController _iconController;
  late Animation<double> _entryOpacity;
  late Animation<Offset> _entrySlide;
  late Animation<double> _iconScale;

  final _ctrl = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    _ctrl.resetForgotState();
    _initAnimations();
    _startEntry();
  }

  void _initAnimations() {
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _iconController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _entryOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _entryController, curve: Curves.easeIn),
    );

    _entrySlide =
        Tween<Offset>(begin: const Offset(0, 0.4), end: Offset.zero).animate(
          CurvedAnimation(parent: _entryController, curve: Curves.easeOut),
        );

    _iconScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _iconController, curve: Curves.elasticOut),
    );
  }

  Future<void> _startEntry() async {
    await Future.delayed(const Duration(milliseconds: 100));
    _entryController.forward();
    _iconController.forward();
  }

  @override
  void dispose() {
    _entryController.dispose();
    _iconController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: Stack(
        children: [
          const AuthBackground(),
          SafeArea(
            child: Obx(() => _ctrl.resetEmailSent.value
                ? EmailSentSuccess(
              onDone: () => Get.back(),
            )
                : _buildForgotForm()),
          ),
        ],
      ),
    );
  }

  Widget _buildForgotForm() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 24.h),
      child: AnimatedBuilder(
        animation: _entryController,
        builder: (_, __) => FadeTransition(
          opacity: _entryOpacity,
          child: SlideTransition(
            position: _entrySlide,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Gap.v(24),
                _buildBackButton(),
                Gap.v(36),
                _buildLockIcon(),
                Gap.v(28),
                AppText(
                  text: 'Forgot Password?',
                  fontSize: 26.fSize,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
                Gap.v(10),
                AppText(
                  text:
                  "No worries! Enter your email address and we'll send you a secure reset link.",
                  fontSize: 14.fSize,
                  color: AppColors.textSecondary,
                  height: 1.6,
                ),
                Gap.v(36),
                _buildEmailForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return GestureDetector(
      onTap: () => Get.back(),
      child: Container(
        width: 40.h,
        height: 40.h,
        decoration: BoxDecoration(
          borderRadius: 12.r,
          color: AppColors.darkCard,
          border: Border.all(color: AppColors.darkCardBorder),
        ),
        child: Icon(
          Icons.arrow_back_rounded,
          color: AppColors.textSecondary,
          size: 20.h,
        ),
      ),
    );
  }

  Widget _buildLockIcon() {
    return AnimatedBuilder(
      animation: _iconController,
      builder: (_, __) => Transform.scale(
        scale: _iconScale.value,
        child: Container(
          width: 68.h,
          height: 68.h,
          decoration: BoxDecoration(
            borderRadius: 18.r,
            gradient: const LinearGradient(
              colors: [AppColors.primaryBlue, AppColors.primaryCyan],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryBlue.withOpacity(0.4),
                blurRadius: 20.h,
                spreadRadius: 2.h,
              ),
            ],
          ),
          child: Icon(
            Icons.lock_reset_rounded,
            color: AppColors.white,
            size: 32.h,
          ),
        ),
      ),
    );
  }

  Widget _buildEmailForm() {
    return Form(
      key: _ctrl.forgotFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            text: 'Email Address',
            fontSize: 13.fSize,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
          Gap.v(10),
          AppTextField(
            hint: 'name@company.com',
            controller: _ctrl.forgotEmailCtrl,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            validator: _ctrl.validateEmail,
            prefixIcon: Icon(
              Icons.mail_outline_rounded,
              color: AppColors.textMuted,
              size: 20.h,
            ),
          ),
          Gap.v(28),
          Obx(
                () => AppButton(
              text: 'Send Reset Link',
              isLoading: _ctrl.isForgotLoading.value,
              onTap: _ctrl.sendResetLink,
              suffixIcon: _ctrl.isForgotLoading.value
                  ? null
                  : Icon(
                Icons.arrow_forward_rounded,
                color: AppColors.white,
                size: 20.h,
              ),
            ),
          ),
          Gap.v(20),
          Center(
            child: GestureDetector(
              onTap: () => Get.back(),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.arrow_back_rounded,
                    color: AppColors.primaryBlue,
                    size: 16.h,
                  ),
                  Gap.h(6),
                  AppText(
                    text: 'Back to Login',
                    fontSize: 14.fSize,
                    color: AppColors.primaryBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
