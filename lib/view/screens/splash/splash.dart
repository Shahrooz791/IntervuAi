import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intervu_ai/core/constants/app_colors.dart';
import 'package:intervu_ai/core/constants/images_assets.dart';
import 'package:intervu_ai/core/utils/size_utils.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _pulseController;
  late AnimationController _progressController;

  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<double> _textOpacity;
  late Animation<Offset> _textSlide;
  late Animation<double> _pulseAnim;
  late Animation<double> _progressAnim;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _startSequence();
  }

  void _initAnimations() {
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    _logoScale = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );

    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeIn),
    );

    _textSlide =
        Tween<Offset>(begin: const Offset(0, 0.4), end: Offset.zero).animate(
          CurvedAnimation(parent: _textController, curve: Curves.easeOut),
        );

    _pulseAnim = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _progressAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeInOut),
    );
  }

  Future<void> _startSequence() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _logoController.forward();
    await Future.delayed(const Duration(milliseconds: 600));
    _textController.forward();
    _progressController.forward();
    await Future.delayed(const Duration(milliseconds: 2600));
    if (mounted) {
      Get.offNamed('/onboarding');
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _pulseController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: Stack(
        children: [
          _buildParticleBackground(),
          _buildGlowOrb(
            alignment: const Alignment(-0.6, -0.7),
            color: AppColors.accentPurple,
            size: 280.h,
            opacity: 0.12,
          ),
          _buildGlowOrb(
            alignment: const Alignment(0.8, 0.4),
            color: AppColors.primaryBlue,
            size: 220.h,
            opacity: 0.10,
          ),
          _buildGlowOrb(
            alignment: const Alignment(0.0, 0.9),
            color: AppColors.primaryCyan,
            size: 180.h,
            opacity: 0.08,
          ),
          SafeArea(
            child: Column(
              children: [
                const Spacer(),
                _buildLogo(),
                Gap.v(24),
                _buildTitle(),
                Gap.v(8),
                _buildSubtitle(),
                const Spacer(),
                _buildProgressBar(),
                Gap.v(20),
                _buildVersion(),
                Gap.v(32),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParticleBackground() {
    return CustomPaint(
      painter: _StarFieldPainter(),
      child: const SizedBox.expand(),
    );
  }

  Widget _buildGlowOrb({
    required AlignmentGeometry alignment,
    required Color color,
    required double size,
    required double opacity,
  }) {
    return Align(
      alignment: alignment,
      child: AnimatedBuilder(
        animation: _pulseAnim,
        builder: (_, __) => Transform.scale(
          scale: _pulseAnim.value,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  color.withOpacity(opacity),
                  color.withOpacity(0.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return AnimatedBuilder(
      animation: _logoController,
      builder: (_, __) => Opacity(
        opacity: _logoOpacity.value,
        child: Transform.scale(
          scale: _logoScale.value,
          child: Container(
            width: 88.h,
            height: 88.h,
            decoration: BoxDecoration(
              borderRadius: 22.r,
              gradient: AppColors.logoGradient,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryBlue.withOpacity(0.4),
                  blurRadius: 32.h,
                  spreadRadius: 4.h,
                ),
                BoxShadow(
                  color: AppColors.primaryCyan.withOpacity(0.25),
                  blurRadius: 60.h,
                  spreadRadius: 8.h,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: 22.r,
              child: Image.asset(
                ImagesAssets.appLogo,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const _FallbackLogoIcon(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return AnimatedBuilder(
      animation: _textController,
      builder: (_, __) => FadeTransition(
        opacity: _textOpacity,
        child: SlideTransition(
          position: _textSlide,
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Intervu',
                  style: TextStyle(
                    fontSize: 30.fSize,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Urbanist',
                    color: AppColors.textPrimary,
                    letterSpacing: -0.5,
                  ),
                ),
                TextSpan(
                  text: 'AI',
                  style: TextStyle(
                    fontSize: 30.fSize,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'Urbanist',
                    foreground: Paint()
                      ..shader = const LinearGradient(
                        colors: [
                          AppColors.primaryBlue,
                          AppColors.primaryCyan,
                        ],
                      ).createShader(
                        Rect.fromLTWH(0, 0, 60.h, 40.h),
                      ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSubtitle() {
    return AnimatedBuilder(
      animation: _textController,
      builder: (_, __) => FadeTransition(
        opacity: _textOpacity,
        child: SlideTransition(
          position: _textSlide,
          child: Text(
            'Ace Every Interview',
            style: TextStyle(
              fontSize: 14.fSize,
              fontWeight: FontWeight.w400,
              fontFamily: 'Urbanist',
              color: AppColors.textSecondary,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 80.h),
      child: AnimatedBuilder(
        animation: _progressAnim,
        builder: (_, __) => Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 3.v,
                  decoration: BoxDecoration(
                    borderRadius: 100.r,
                    color: AppColors.darkCardBorder,
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: _progressAnim.value,
                  child: Container(
                    height: 3.v,
                    decoration: BoxDecoration(
                      borderRadius: 100.r,
                      gradient: AppColors.primaryGradient,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryCyan.withOpacity(0.5),
                          blurRadius: 6.h,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVersion() {
    return Text(
      'V1.0.0',
      style: TextStyle(
        fontSize: 11.fSize,
        fontFamily: 'Urbanist',
        color: AppColors.textMuted,
        letterSpacing: 1.5,
      ),
    );
  }
}

class _FallbackLogoIcon extends StatelessWidget {
  const _FallbackLogoIcon();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Icon(
        Icons.chat_bubble_rounded,
        color: Colors.white,
        size: 40.h,
      ),
    );
  }
}

class _StarFieldPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.04);
    final List<Offset> stars = [
      Offset(size.width * 0.1, size.height * 0.1),
      Offset(size.width * 0.3, size.height * 0.05),
      Offset(size.width * 0.7, size.height * 0.08),
      Offset(size.width * 0.9, size.height * 0.15),
      Offset(size.width * 0.15, size.height * 0.3),
      Offset(size.width * 0.85, size.height * 0.35),
      Offset(size.width * 0.05, size.height * 0.6),
      Offset(size.width * 0.95, size.height * 0.65),
      Offset(size.width * 0.2, size.height * 0.85),
      Offset(size.width * 0.75, size.height * 0.9),
      Offset(size.width * 0.5, size.height * 0.18),
      Offset(size.width * 0.45, size.height * 0.78),
    ];
    for (final star in stars) {
      canvas.drawCircle(star, 1.5, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}