import 'package:flutter/material.dart';
import 'package:intervu_ai/core/constants/app_colors.dart';
import 'package:intervu_ai/core/utils/size_utils.dart';
import 'package:intervu_ai/view/widgets/app_button.dart';
import 'package:intervu_ai/view/widgets/app_text.dart';

class EmailSentSuccess extends StatefulWidget {
  final VoidCallback onDone;
  const EmailSentSuccess({super.key, required this.onDone});

  @override
  State<EmailSentSuccess> createState() => _EmailSentSuccessState();
}

class _EmailSentSuccessState extends State<EmailSentSuccess>
    with TickerProviderStateMixin {
  late AnimationController _iconController;
  late AnimationController _contentController;
  late Animation<double> _iconScale;
  late Animation<double> _iconOpacity;
  late Animation<Offset> _contentSlide;
  late Animation<double> _contentOpacity;
  late AnimationController _ringController;
  late Animation<double> _ringScale;
  late Animation<double> _ringOpacity;

  @override
  void initState() {
    super.initState();
    _iconController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _contentController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _ringController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    _iconScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _iconController, curve: Curves.elasticOut),
    );
    _iconOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _iconController,
          curve: const Interval(0.0, 0.4, curve: Curves.easeIn)),
    );
    _contentSlide =
        Tween<Offset>(begin: const Offset(0, 0.4), end: Offset.zero).animate(
          CurvedAnimation(parent: _contentController, curve: Curves.easeOut),
        );
    _contentOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _contentController, curve: Curves.easeIn),
    );
    _ringScale = Tween<double>(begin: 0.8, end: 1.6).animate(
      CurvedAnimation(parent: _ringController, curve: Curves.easeOut),
    );
    _ringOpacity = Tween<double>(begin: 0.5, end: 0.0).animate(
      CurvedAnimation(parent: _ringController, curve: Curves.easeOut),
    );

    _startSequence();
  }

  Future<void> _startSequence() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _iconController.forward();
    await Future.delayed(const Duration(milliseconds: 400));
    _contentController.forward();
  }

  @override
  void dispose() {
    _iconController.dispose();
    _contentController.dispose();
    _ringController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _iconController,
            builder: (_, __) => Opacity(
              opacity: _iconOpacity.value,
              child: Transform.scale(
                scale: _iconScale.value,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AnimatedBuilder(
                      animation: _ringController,
                      builder: (_, __) => Transform.scale(
                        scale: _ringScale.value,
                        child: Container(
                          width: 80.h,
                          height: 80.h,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.successGreen
                                  .withOpacity(_ringOpacity.value),
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 80.h,
                      height: 80.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.successGreen.withOpacity(0.15),
                        border: Border.all(
                          color: AppColors.successGreen.withOpacity(0.4),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.successGreen.withOpacity(0.3),
                            blurRadius: 24.h,
                            spreadRadius: 4.h,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.check_circle_outline_rounded,
                        color: AppColors.successGreen,
                        size: 40.h,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Gap.v(32),
          AnimatedBuilder(
            animation: _contentController,
            builder: (_, __) => FadeTransition(
              opacity: _contentOpacity,
              child: SlideTransition(
                position: _contentSlide,
                child: Column(
                  children: [
                    AppText(
                      text: 'Check your inbox!',
                      fontSize: 24.fSize,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                      textAlign: TextAlign.center,
                    ),
                    Gap.v(12),
                    AppText(
                      text:
                      "We've sent password reset instructions to the email provided. Please check your junk folder if you don't see it.",
                      fontSize: 14.fSize,
                      color: AppColors.textSecondary,
                      textAlign: TextAlign.center,
                      height: 1.6,
                    ),
                    Gap.v(40),
                    AppButton(
                      text: 'Done',
                      onTap: widget.onDone,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
