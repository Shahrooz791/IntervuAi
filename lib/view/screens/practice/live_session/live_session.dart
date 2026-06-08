import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intervu_ai/controllers/mock_interview_controller.dart';
import 'package:intervu_ai/core/constants/app_colors.dart';
import 'package:intervu_ai/core/utils/size_utils.dart';
import 'package:intervu_ai/view/screens/practice/live_session/components/live_waveform.dart';
import 'package:intervu_ai/view/widgets/app_text.dart';

class LiveSessionScreen extends StatefulWidget {
  const LiveSessionScreen({super.key});

  @override
  State<LiveSessionScreen> createState() => _LiveSessionScreenState();
}

class _LiveSessionScreenState extends State<LiveSessionScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _entryCtrl;
  late Animation<double> _fade;

  final _ctrl = Get.isRegistered<MockInterviewController>() ? Get.find<MockInterviewController>() : Get.put(MockInterviewController());

  @override
  void initState() {
    super.initState();
    _entryCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fade = CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOut);
    Future.delayed(const Duration(milliseconds: 80), () {
      if (mounted) {
        _entryCtrl.forward();
        _ctrl.startSession();
      }
    });
  }

  @override
  void dispose() {
    _entryCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fade,
          child: Stack(
            children: [
              _buildBgGlow(),
              Column(
                children: [
                  _buildTopBar(),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 16.h),
                      child: Column(
                        children: [
                          Gap.v(16),
                          _buildAvatarSection(),
                          Gap.v(24),
                          _buildQuestionCard(),
                          Gap.v(24),
                          const LiveWaveform(),
                          Gap.v(28),
                          _buildControls(),
                          Gap.v(32),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBgGlow() {
    return Positioned(
      top: -60,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          width: 200.h,
          height: 200.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                AppColors.primaryBlue.withOpacity(0.12),
                AppColors.primaryBlue.withOpacity(0.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 12.v),
      child: Row(
        children: [
          Obx(() => Container(
            padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 5.v),
            decoration: BoxDecoration(
              borderRadius: 100.r,
              color: AppColors.errorRed.withOpacity(0.15),
              border: Border.all(
                  color: AppColors.errorRed.withOpacity(0.5)),
            ),
            child: Row(
              children: [
                Container(
                  width: 6.h,
                  height: 6.h,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: AppColors.errorRed),
                ),
                Gap.h(6),
                AppText(
                  text: 'LIVE',
                  fontSize: 10.fSize,
                  fontWeight: FontWeight.w800,
                  color: AppColors.errorRed,
                ),
                Gap.h(8),
                Icon(Icons.timer_outlined,
                    color: AppColors.textSecondary, size: 12.h),
                Gap.h(4),
                AppText(
                  text: _ctrl.elapsedTime.value,
                  fontSize: 12.fSize,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ],
            ),
          )),
          const Spacer(),
          GestureDetector(
            onTap: () => _showEndConfirm(),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 7.v),
              decoration: BoxDecoration(
                borderRadius: 100.r,
                color: AppColors.errorRed.withOpacity(0.12),
                border: Border.all(
                    color: AppColors.errorRed.withOpacity(0.4)),
              ),
              child: Row(
                children: [
                  Icon(Icons.close_rounded,
                      color: AppColors.errorRed, size: 14.h),
                  Gap.h(4),
                  AppText(
                    text: 'End',
                    fontSize: 12.fSize,
                    fontWeight: FontWeight.w700,
                    color: AppColors.errorRed,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarSection() {
    return Column(
      children: [
        _PulsingAvatar(),
        Gap.v(14),
        AppText(
          text: 'AI SENIOR ARCHITECT',
          fontSize: 11.fSize,
          fontWeight: FontWeight.w700,
          color: AppColors.textMuted,
        ),
        Gap.v(4),
        AppText(
          text: 'Symmetry-7',
          fontSize: 18.fSize,
          fontWeight: FontWeight.w800,
          color: AppColors.textPrimary,
        ),
        Gap.v(10),
        Obx(() => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding:
              EdgeInsets.symmetric(horizontal: 10.h, vertical: 4.v),
              decoration: BoxDecoration(
                borderRadius: 100.r,
                color: AppColors.iconBgBlue,
                border: Border.all(
                    color: AppColors.primaryBlue.withOpacity(0.4)),
              ),
              child: AppText(
                text:
                'QUESTION ${_ctrl.currentQuestion.value} / ${_ctrl.totalQuestions.value}',
                fontSize: 10.fSize,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryCyan,
              ),
            ),
          ],
        )),
      ],
    );
  }

  Widget _buildQuestionCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.h),
      decoration: BoxDecoration(
        borderRadius: 20.r,
        color: AppColors.darkCard,
        border: Border.all(color: AppColors.darkCardBorder),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlue.withOpacity(0.06),
            blurRadius: 20.h,
          ),
        ],
      ),
      child: Obx(() => AppText(
        text: _ctrl.currentQuestionText.value,
        fontSize: 16.fSize,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        textAlign: TextAlign.center,
        height: 1.6,
      )),
    );
  }

  Widget _buildControls() {
    return Obx(() => Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _ControlBtn(
          icon: Icons.skip_previous_rounded,
          size: 36.h,
          onTap: () {},
        ),
        Gap.h(20),
        GestureDetector(
          onTap: _ctrl.toggleRecording,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 68.h,
            height: 68.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: _ctrl.isRecording.value
                  ? AppColors.primaryGradient
                  : null,
              color: _ctrl.isRecording.value
                  ? null
                  : AppColors.darkCard,
              border: Border.all(
                color: _ctrl.isRecording.value
                    ? AppColors.primaryBlue
                    : AppColors.darkCardBorder,
                width: 2,
              ),
              boxShadow: _ctrl.isRecording.value
                  ? [
                BoxShadow(
                  color: AppColors.primaryBlue.withOpacity(0.5),
                  blurRadius: 20.h,
                  spreadRadius: 2,
                ),
              ]
                  : [],
            ),
            child: Icon(
              _ctrl.isRecording.value
                  ? Icons.mic_rounded
                  : Icons.mic_off_rounded,
              color: AppColors.white,
              size: 28.h,
            ),
          ),
        ),
        Gap.h(20),
        _ControlBtn(
          icon: Icons.skip_next_rounded,
          size: 36.h,
          onTap: () {},
        ),
      ],
    ));
  }

  void _showEndConfirm() {
    Get.defaultDialog(
      title: 'End Session?',
      middleText: 'Your progress will be saved and results will be shown.',
      textConfirm: 'End Session',
      textCancel: 'Continue',
      confirmTextColor: AppColors.white,
      buttonColor: AppColors.errorRed,
      onConfirm: () {
        Get.back();
        _ctrl.onEndSession();
      },
    );
  }
}

class _PulsingAvatar extends StatefulWidget {
  @override
  State<_PulsingAvatar> createState() => _PulsingAvatarState();
}

class _PulsingAvatarState extends State<_PulsingAvatar>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulse;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
    _scale = Tween<double>(begin: 1.0, end: 1.06)
        .animate(CurvedAnimation(parent: _pulse, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scale,
      builder: (_, __) => Transform.scale(
        scale: _scale.value,
        child: Container(
          width: 90.h,
          height: 90.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: AppColors.primaryGradient,
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryBlue
                    .withOpacity(0.35 + 0.1 * (_scale.value - 1) / 0.06),
                blurRadius: 24.h,
                spreadRadius: 4,
              ),
            ],
          ),
          child: Center(
            child: Icon(Icons.person_rounded,
                color: AppColors.white, size: 42.h),
          ),
        ),
      ),
    );
  }
}

class _ControlBtn extends StatefulWidget {
  final IconData icon;
  final double size;
  final VoidCallback onTap;
  const _ControlBtn({required this.icon, required this.size, required this.onTap});

  @override
  State<_ControlBtn> createState() => _ControlBtnState();
}

class _ControlBtnState extends State<_ControlBtn> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        width: widget.size,
        height: widget.size,
        transform: _pressed ? (Matrix4.identity()..scale(0.9)) : Matrix4.identity(),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.darkCard,
          border: Border.all(color: AppColors.darkCardBorder),
        ),
        child: Icon(widget.icon, color: AppColors.textSecondary, size: 18.h),
      ),
    );
  }
}
