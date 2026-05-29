import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intervu_ai/controllers/auth_controller.dart';
import 'package:intervu_ai/core/constants/app_colors.dart';
import 'package:intervu_ai/core/utils/size_utils.dart';
import 'package:intervu_ai/view/screens/auth/login/components/auth_breakground.dart';
import 'package:intervu_ai/view/screens/auth/signup/components/password_strengt_bar.dart';
import 'package:intervu_ai/view/screens/auth/signup/components/terms_check_box.dart';
import 'package:intervu_ai/view/widgets/app_button.dart';
import 'package:intervu_ai/view/widgets/app_text.dart';
import 'package:intervu_ai/view/widgets/app_textfield.dart';
import '../login/components/auth_logo.dart';
import '../login/components/google_button.dart';
import '../login/components/auth_divider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen>
    with TickerProviderStateMixin {
  late AnimationController _entryController;
  late AnimationController _floatController;
  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<Offset> _formSlide;
  late Animation<double> _formOpacity;
  late Animation<Offset> _titleSlide;
  late Animation<double> _titleOpacity;

  final _ctrl = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _startEntry();
  }

  void _initAnimations() {
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    )..repeat(reverse: true);

    _logoScale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.0, 0.5, curve: Curves.elasticOut),
      ),
    );

    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeIn),
      ),
    );

    _titleSlide =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _entryController,
            curve: const Interval(0.25, 0.65, curve: Curves.easeOut),
          ),
        );

    _titleOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.25, 0.6, curve: Curves.easeIn),
      ),
    );

    _formSlide =
        Tween<Offset>(begin: const Offset(0, 0.6), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _entryController,
            curve: const Interval(0.45, 1.0, curve: Curves.easeOut),
          ),
        );

    _formOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.45, 0.9, curve: Curves.easeIn),
      ),
    );
  }

  Future<void> _startEntry() async {
    await Future.delayed(const Duration(milliseconds: 100));
    _entryController.forward();
  }

  @override
  void dispose() {
    _entryController.dispose();
    _floatController.dispose();
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
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 24.h),
              child: Column(
                children: [
                  Gap.v(40),
                  _buildLogo(),
                  Gap.v(20),
                  _buildTitle(),
                  Gap.v(32),
                  _buildForm(),
                  Gap.v(32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return AnimatedBuilder(
      animation: _entryController,
      builder: (_, __) => Opacity(
        opacity: _logoOpacity.value,
        child: Transform.scale(
          scale: _logoScale.value,
          child: AnimatedBuilder(
            animation: _floatController,
            builder: (_, __) => Transform.translate(
              offset: Offset(
                  0,
                  Tween<double>(begin: -4, end: 4).evaluate(
                      CurvedAnimation(
                          parent: _floatController,
                          curve: Curves.easeInOut))),
              child: const AuthLogo(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return AnimatedBuilder(
      animation: _entryController,
      builder: (_, __) => FadeTransition(
        opacity: _titleOpacity,
        child: SlideTransition(
          position: _titleSlide,
          child: Column(
            children: [
              AppText(
                text: 'Create Account',
                fontSize: 26.fSize,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
              Gap.v(6),
              AppText(
                text: 'Start your interview journey today',
                fontSize: 14.fSize,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return AnimatedBuilder(
      animation: _entryController,
      builder: (_, __) => FadeTransition(
        opacity: _formOpacity,
        child: SlideTransition(
          position: _formSlide,
          child: Container(
            padding: EdgeInsets.all(20.h),
            decoration: BoxDecoration(
              borderRadius: 20.r,
              color: AppColors.darkCard.withOpacity(0.5),
              border: Border.all(color: AppColors.darkCardBorder),
            ),
            child: Form(
              key: _ctrl.signupFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _FieldLabel(label: 'FULL NAME'),
                  Gap.v(8),
                  AppTextField(
                    hint: 'John Doe',
                    controller: _ctrl.signupNameCtrl,
                    textInputAction: TextInputAction.next,
                    validator: _ctrl.validateName,
                    prefixIcon: Icon(
                      Icons.person_outline_rounded,
                      color: AppColors.textMuted,
                      size: 20.h,
                    ),
                  ),
                  Gap.v(16),
                  _FieldLabel(label: 'EMAIL ADDRESS'),
                  Gap.v(8),
                  AppTextField(
                    hint: 'john@example.com',
                    controller: _ctrl.signupEmailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: _ctrl.validateEmail,
                    prefixIcon: Icon(
                      Icons.mail_outline_rounded,
                      color: AppColors.textMuted,
                      size: 20.h,
                    ),
                  ),
                  Gap.v(16),
                  _FieldLabel(label: 'PASSWORD'),
                  Gap.v(8),
                  AppTextField(
                    hint: '••••••••',
                    controller: _ctrl.signupPasswordCtrl,
                    isPassword: true,
                    textInputAction: TextInputAction.next,
                    validator: _ctrl.validatePassword,
                    onChanged: _ctrl.updatePasswordStrength,
                    prefixIcon: Icon(
                      Icons.lock_outline_rounded,
                      color: AppColors.textMuted,
                      size: 20.h,
                    ),
                  ),
                  Gap.v(10),
                  Obx(() => PasswordStrengthBar(
                    strength: _ctrl.passwordStrength.value,
                  )),
                  Gap.v(16),
                  _FieldLabel(label: 'CONFIRM PASSWORD'),
                  Gap.v(8),
                  AppTextField(
                    hint: '••••••••',
                    controller: _ctrl.signupConfirmPasswordCtrl,
                    isPassword: true,
                    textInputAction: TextInputAction.done,
                    validator: _ctrl.validateConfirmPassword,
                    prefixIcon: Icon(
                      Icons.shield_outlined,
                      color: AppColors.textMuted,
                      size: 20.h,
                    ),
                  ),
                  Gap.v(20),
                  Obx(() => TermsCheckbox(
                    value: _ctrl.agreedToTerms.value,
                    onChanged: (val) =>
                    _ctrl.agreedToTerms.value = val ?? false,
                  )),
                  Gap.v(24),
                  Obx(
                        () => AppButton(
                      text: 'Create Account',
                      isLoading: _ctrl.isSignupLoading.value,
                      onTap: _ctrl.signup,
                      suffixIcon: _ctrl.isSignupLoading.value
                          ? null
                          : Icon(
                        Icons.arrow_forward_rounded,
                        color: AppColors.white,
                        size: 20.h,
                      ),
                    ),
                  ),
                  Gap.v(24),
                  const AuthDivider(label: 'OR SIGN UP WITH'),
                  Gap.v(16),
                  const GoogleButton(label: 'Sign up with Google'),
                  Gap.v(24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppText(
                        text: 'Already have an account? ',
                        fontSize: 14.fSize,
                        color: AppColors.textSecondary,
                      ),
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: AppText(
                          text: 'Log in',
                          fontSize: 14.fSize,
                          color: AppColors.primaryBlue,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String label;
  const _FieldLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return AppText(
      text: label,
      fontSize: 11.fSize,
      fontWeight: FontWeight.w700,
      color: AppColors.textMuted,
    );
  }
}
