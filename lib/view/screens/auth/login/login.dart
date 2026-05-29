import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intervu_ai/controllers/auth_controller.dart';
import 'package:intervu_ai/core/constants/app_colors.dart';
import 'package:intervu_ai/core/utils/routes.dart';
import 'package:intervu_ai/core/utils/size_utils.dart';
import 'package:intervu_ai/view/screens/auth/login/components/auth_breakground.dart';
import 'package:intervu_ai/view/widgets/app_button.dart';
import 'package:intervu_ai/view/widgets/app_text.dart';
import 'package:intervu_ai/view/widgets/app_textfield.dart';
import 'components/auth_logo.dart';
import 'components/google_button.dart';
import 'components/auth_divider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
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
      duration: const Duration(milliseconds: 2800),
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
            curve: const Interval(0.3, 0.7, curve: Curves.easeOut),
          ),
        );

    _titleOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.3, 0.65, curve: Curves.easeIn),
      ),
    );

    _formSlide =
        Tween<Offset>(begin: const Offset(0, 0.6), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _entryController,
            curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
          ),
        );

    _formOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.5, 0.9, curve: Curves.easeIn),
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
                  Gap.v(48),
                  _buildLogo(),
                  Gap.v(20),
                  _buildTitle(),
                  Gap.v(40),
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
              offset: Offset(0, Tween<double>(begin: -4, end: 4)
                  .evaluate(CurvedAnimation(
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
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Intervu',
                      style: TextStyle(
                        fontSize: 28.fSize,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Urbanist',
                        color: AppColors.textPrimary,
                      ),
                    ),
                    TextSpan(
                      text: 'AI',
                      style: TextStyle(
                        fontSize: 28.fSize,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'Urbanist',
                        foreground: Paint()
                          ..shader = const LinearGradient(
                            colors: [
                              AppColors.primaryBlue,
                              AppColors.primaryCyan,
                            ],
                          ).createShader(Rect.fromLTWH(0, 0, 60.h, 40.h)),
                      ),
                    ),
                  ],
                ),
              ),
              Gap.v(6),
              AppText(
                text: 'Welcome back',
                fontSize: 15.fSize,
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
          child: Form(
            key: _ctrl.loginFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextField(
                  hint: 'Email',
                  controller: _ctrl.loginEmailCtrl,
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
                AppTextField(
                  hint: 'Password',
                  controller: _ctrl.loginPasswordCtrl,
                  isPassword: true,
                  textInputAction: TextInputAction.done,
                  validator: _ctrl.validatePassword,
                  prefixIcon: Icon(
                    Icons.lock_outline_rounded,
                    color: AppColors.textMuted,
                    size: 20.h,
                  ),
                ),
                Gap.v(10),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () => Get.toNamed(AppRoutes.forgotPassword),
                    child: AppText(
                      text: 'Forgot password?',
                      fontSize: 14.fSize,
                      color: AppColors.primaryBlue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Gap.v(24),
                Obx(
                      () => AppButton(
                    text: 'Log In',
                    isLoading: _ctrl.isLoginLoading.value,
                    onTap: _ctrl.login,
                    suffixIcon: _ctrl.isLoginLoading.value
                        ? null
                        : Icon(
                      Icons.arrow_forward_rounded,
                      color: AppColors.white,
                      size: 20.h,
                    ),
                  ),
                ),
                Gap.v(24),
                const AuthDivider(label: 'or continue with'),
                Gap.v(16),
                const GoogleButton(label: 'Google'),
                Gap.v(32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppText(
                      text: "Don't have an account? ",
                      fontSize: 14.fSize,
                      color: AppColors.textSecondary,
                    ),
                    GestureDetector(
                      onTap: () => Get.toNamed(AppRoutes.signup),
                      child: AppText(
                        text: 'Sign up',
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
    );
  }
}
