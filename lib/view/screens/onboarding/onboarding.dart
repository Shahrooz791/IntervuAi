import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intervu_ai/core/constants/app_colors.dart';
import 'package:intervu_ai/core/utils/size_utils.dart';
import 'package:intervu_ai/view/widgets/app_button.dart';
import 'package:intervu_ai/view/widgets/app_text.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _dotController;

  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;
  late Animation<double> _dotAnim;

  int _currentPage = 0;

  final List<_OnboardingData> _pages = const [
    _OnboardingData(
      badge: 'AI POWERED',
      title: 'Practice Smarter,\nGet Hired Faster',
      subtitle:
      'IntervuAI uses advanced AI to simulate real job interviews and provide instant personalized feedback.',
    ),
    _OnboardingData(
      badge: 'SMART ANALYSIS',
      title: 'Real-Time\nFeedback & Insights',
      subtitle:
      'Get detailed performance analysis after every session so you know exactly what to improve.',
    ),
    _OnboardingData(
      badge: 'YOUR JOURNEY',
      title: 'Track Progress,\nLand Your Dream Job',
      subtitle:
      'Monitor your growth over time with comprehensive dashboards and personalized improvement plans.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _dotController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );
    _slideAnim =
        Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOut),
        );
    _dotAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _dotController, curve: Curves.easeOut),
    );

    _animateIn();
  }

  void _animateIn() {
    _fadeController.forward(from: 0);
    _slideController.forward(from: 0);
    _dotController.forward(from: 0);
  }

  void _onPageChanged(int index) {
    setState(() => _currentPage = index);
    _animateIn();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      Get.offNamed('/role-selection');
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    _dotController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: Stack(
        children: [
          _buildBackground(),
          Column(
            children: [
              _buildImageSection(),
              _buildContentSection(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Positioned(
      top: -60.v,
      right: -40.h,
      child: Container(
        width: 200.h,
        height: 200.h,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              AppColors.accentPurple.withOpacity(0.15),
              AppColors.accentPurple.withOpacity(0.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return SizedBox(
      height: 380.v,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            itemCount: _pages.length,
            itemBuilder: (_, index) => _OnboardingImageCard(index: index),
          ),
          _buildTopBar(),
          _buildBottomFade(),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 12.v),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildBackButton(),
              _buildBrandName(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return GestureDetector(
      onTap: () {
        if (_currentPage > 0) {
          _pageController.previousPage(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
          );
        }
      },
      child: Container(
        width: 36.h,
        height: 36.h,
        decoration: BoxDecoration(
          color: AppColors.shimmer,
          borderRadius: 10.r,
          border: Border.all(color: AppColors.darkCardBorder),
        ),
        child: Icon(
          Icons.arrow_back_ios_new_rounded,
          color: _currentPage > 0
              ? AppColors.textPrimary
              : AppColors.textMuted,
          size: 16.h,
        ),
      ),
    );
  }

  Widget _buildBrandName() {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: 'ê',
            style: TextStyle(
              fontSize: 16.fSize,
              fontWeight: FontWeight.w700,
              fontFamily: 'Urbanist',
              color: AppColors.textPrimary,
            ),
          ),
          TextSpan(
            text: 'kip',
            style: TextStyle(
              fontSize: 16.fSize,
              fontWeight: FontWeight.w400,
              fontFamily: 'Urbanist',
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomFade() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 100.v,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.darkBg.withOpacity(0.0),
              AppColors.darkBg,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContentSection() {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Gap.v(8),
            _buildPageDots(),
            Gap.v(20),
            AnimatedBuilder(
              animation: _fadeController,
              builder: (_, __) => FadeTransition(
                opacity: _fadeAnim,
                child: SlideTransition(
                  position: _slideAnim,
                  child: Column(
                    children: [
                      _buildBadge(_pages[_currentPage].badge),
                      Gap.v(16),
                      AppText(
                        text: _pages[_currentPage].title,
                        fontSize: 26.fSize,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        textAlign: TextAlign.center,
                        height: 1.3,
                      ),
                      Gap.v(12),
                      AppText(
                        text: _pages[_currentPage].subtitle,
                        fontSize: 14.fSize,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textSecondary,
                        textAlign: TextAlign.center,
                        height: 1.6,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Spacer(),
            _buildGetStartedButton(),
            Gap.v(16),
            _buildLoginLink(),
            Gap.v(32),
          ],
        ),
      ),
    );
  }

  Widget _buildPageDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _pages.length,
            (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(horizontal: 4.h),
          width: _currentPage == index ? 24.h : 8.h,
          height: 8.h,
          decoration: BoxDecoration(
            borderRadius: 100.r,
            gradient: _currentPage == index
                ? AppColors.primaryGradient
                : null,
            color: _currentPage == index ? null : AppColors.darkCardBorder,
            boxShadow: _currentPage == index
                ? [
              BoxShadow(
                color: AppColors.primaryBlue.withOpacity(0.4),
                blurRadius: 6.h,
              ),
            ]
                : null,
          ),
        ),
      ),
    );
  }

  Widget _buildBadge(String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.h, vertical: 6.v),
      decoration: BoxDecoration(
        borderRadius: 100.r,
        border: Border.all(color: AppColors.primaryCyan.withOpacity(0.5)),
        color: AppColors.primaryCyan.withOpacity(0.08),
      ),
      child: AppText(
        text: label,
        fontSize: 11.fSize,
        fontWeight: FontWeight.w600,
        color: AppColors.primaryCyan,
        height: 1.0,
      ),
    );
  }

  Widget _buildGetStartedButton() {
    return GestureDetector(
      onTap: _nextPage,
      child: Container(
        width: double.infinity,
        height: 56.v,
        decoration: BoxDecoration(
          borderRadius: 100.r,
          gradient: AppColors.primaryGradient,
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryBlue.withOpacity(0.35),
              blurRadius: 20.h,
              offset: Offset(0, 8.v),
            ),
          ],
        ),
        child: Center(
          child: AppText(
            text: _currentPage == _pages.length - 1
                ? 'Get Started 🚀'
                : 'Get Ŝtarted',
            fontSize: 16.fSize,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
            height: 1.0,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppText(
          text: 'Already have an account? ',
          fontSize: 14.fSize,
          color: AppColors.textSecondary,
          height: 1.0,
        ),
        GestureDetector(
          onTap: () => Get.toNamed('/login'),
          child: AppText(
            text: 'Log in',
            fontSize: 14.fSize,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
            height: 1.0,
          ),
        ),
      ],
    );
  }
}

class _OnboardingImageCard extends StatelessWidget {
  final int index;
  const _OnboardingImageCard({required this.index});

  static const List<List<Color>> _overlayColors = [
    [Color(0xFF8B5CF6), Color(0xFF3B82F6)],
    [Color(0xFF06B6D4), Color(0xFF3B82F6)],
    [Color(0xFF3B82F6), Color(0xFF14B8A6)],
  ];

  static const List<IconData> _icons = [
    Icons.hub_rounded,
    Icons.analytics_rounded,
    Icons.trending_up_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.darkBg,
                _overlayColors[index][0].withOpacity(0.3),
                _overlayColors[index][1].withOpacity(0.2),
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
        ),
        Center(
          child: _NeuralNetworkIllustration(
            color1: _overlayColors[index][0],
            color2: _overlayColors[index][1],
            icon: _icons[index],
          ),
        ),
      ],
    );
  }
}

class _NeuralNetworkIllustration extends StatefulWidget {
  final Color color1;
  final Color color2;
  final IconData icon;

  const _NeuralNetworkIllustration({
    required this.color1,
    required this.color2,
    required this.icon,
  });

  @override
  State<_NeuralNetworkIllustration> createState() =>
      _NeuralNetworkIllustrationState();
}

class _NeuralNetworkIllustrationState extends State<_NeuralNetworkIllustration>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotateCtrl;

  @override
  void initState() {
    super.initState();
    _rotateCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();
  }

  @override
  void dispose() {
    _rotateCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260.h,
      height: 260.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: _rotateCtrl,
            builder: (_, __) => CustomPaint(
              size: Size(260.h, 260.h),
              painter: _NeuralPainter(
                progress: _rotateCtrl.value,
                color1: widget.color1,
                color2: widget.color2,
              ),
            ),
          ),
          Container(
            width: 72.h,
            height: 72.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [widget.color1, widget.color2],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: widget.color1.withOpacity(0.5),
                  blurRadius: 30.h,
                  spreadRadius: 4.h,
                ),
              ],
            ),
            child: Icon(widget.icon, color: Colors.white, size: 32.h),
          ),
        ],
      ),
    );
  }
}

class _NeuralPainter extends CustomPainter {
  final double progress;
  final Color color1;
  final Color color2;

  const _NeuralPainter({
    required this.progress,
    required this.color1,
    required this.color2,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final nodePaint = Paint()..style = PaintingStyle.fill;
    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Draw orbiting nodes and connections
    for (int i = 0; i < 8; i++) {
      final angle = (i / 8) * 2 * 3.14159 + progress * 2 * 3.14159;
      final nodeX = center.dx + (radius - 20) * 0.65 * _cos(angle);
      final nodeY = center.dy + (radius - 20) * 0.65 * _sin(angle);
      final nodePos = Offset(nodeX, nodeY);

      // Line from center to node
      linePaint.color = color1.withOpacity(0.2 + 0.15 * _sin(angle + progress));
      canvas.drawLine(center, nodePos, linePaint);

      // Node circle
      nodePaint.color = Color.lerp(color1, color2, i / 8)!.withOpacity(0.7);
      canvas.drawCircle(nodePos, 5, nodePaint);

      // Connect to adjacent node
      final nextAngle =
          ((i + 1) / 8) * 2 * 3.14159 + progress * 2 * 3.14159;
      final nextX = center.dx + (radius - 20) * 0.65 * _cos(nextAngle);
      final nextY = center.dy + (radius - 20) * 0.65 * _sin(nextAngle);
      linePaint.color = color2.withOpacity(0.15);
      canvas.drawLine(nodePos, Offset(nextX, nextY), linePaint);
    }

    // Outer ring nodes
    for (int i = 0; i < 5; i++) {
      final angle = (i / 5) * 2 * 3.14159 - progress * 2 * 3.14159 * 0.5;
      final nodeX = center.dx + (radius - 10) * _cos(angle);
      final nodeY = center.dy + (radius - 10) * _sin(angle);
      nodePaint.color = color2.withOpacity(0.5);
      canvas.drawCircle(Offset(nodeX, nodeY), 3, nodePaint);
    }

    // Glow ring
    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..color = color1.withOpacity(0.12);
    canvas.drawCircle(center, radius * 0.65, ringPaint);
    canvas.drawCircle(center, radius * 0.95, ringPaint..color = color2.withOpacity(0.08));
  }

  double _cos(double angle) => math.cos(angle);
  double _sin(double angle) => math.sin(angle);

  @override
  bool shouldRepaint(covariant _NeuralPainter old) =>
      old.progress != progress || old.color1 != color1;
}

class _OnboardingData {
  final String badge;
  final String title;
  final String subtitle;
  const _OnboardingData({
    required this.badge,
    required this.title,
    required this.subtitle,
  });
}