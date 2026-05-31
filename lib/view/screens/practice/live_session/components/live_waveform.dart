import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intervu_ai/controllers/mock_interview_controller.dart';
import 'package:intervu_ai/core/constants/app_colors.dart';
import 'package:intervu_ai/core/utils/size_utils.dart';

class LiveWaveform extends StatelessWidget {
  const LiveWaveform({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<MockInterviewController>();
    return Obx(() => SizedBox(
      height: 48.v,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(
          ctrl.waveformBars.length,
              (i) {
            final bar = ctrl.waveformBars[i];
            final isCenter = (i - ctrl.waveformBars.length ~/ 2).abs() < 4;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 100),
              width: 3.h,
              height: (bar * 44).v,
              margin: EdgeInsets.symmetric(horizontal: 1.5.h),
              decoration: BoxDecoration(
                borderRadius: 100.r,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: isCenter
                      ? [AppColors.primaryCyan, AppColors.primaryBlue]
                      : [
                    AppColors.primaryBlue.withOpacity(0.6),
                    AppColors.primaryBlue.withOpacity(0.2),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    ));
  }
}
