import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intervu_ai/controllers/mock_interview_controller.dart';
import 'package:intervu_ai/core/constants/app_colors.dart';
import 'package:intervu_ai/core/utils/size_utils.dart';
import 'package:intervu_ai/view/screens/practice/resume_prep/components/resume_upload_zone.dart';
import 'package:intervu_ai/view/screens/practice/resume_prep/components/resume_question_preview.dart';
import 'package:intervu_ai/view/widgets/app_button.dart';
import 'package:intervu_ai/view/widgets/app_text.dart';

class ResumePrepScreen extends StatefulWidget {
  const ResumePrepScreen({super.key});

  @override
  State<ResumePrepScreen> createState() => _ResumePrepScreenState();
}

class _ResumePrepScreenState extends State<ResumePrepScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _entryCtrl;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  final _ctrl = Get.find<MockInterviewController>();

  @override
  void initState() {
    super.initState();
    _entryCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fade = CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.04),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOut));
    Future.delayed(const Duration(milliseconds: 80), () {
      if (mounted) _entryCtrl.forward();
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
          child: SlideTransition(
            position: _slide,
            child: Column(
              children: [
                _buildTopBar(),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 16.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Gap.v(8),
                        _buildHeroSection(),
                        Gap.v(20),
                        ResumeUploadZone(ctrl: _ctrl),
                        Gap.v(20),
                        Obx(() {
                          if (!_ctrl.hasUploadedResume.value) {
                            return const SizedBox.shrink();
                          }
                          return Column(
                            children: [
                              _buildDetectedSkills(),
                              Gap.v(20),
                              ResumeQuestionPreview(ctrl: _ctrl),
                              Gap.v(20),
                              _buildSessionConfig(),
                              Gap.v(24),
                              AppButton(
                                text: 'Start Resume Session →',
                                onTap: _ctrl.onStartResumeSession,
                                type: AppButtonType.primary,
                              ),
                              Gap.v(32),
                            ],
                          );
                        }),
                        Gap.v(32),
                      ],
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

  Widget _buildTopBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 12.v),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              width: 38.h,
              height: 38.h,
              decoration: BoxDecoration(
                borderRadius: 10.r,
                color: AppColors.darkCard,
                border: Border.all(color: AppColors.darkCardBorder),
              ),
              child: Icon(Icons.arrow_back_ios_new_rounded,
                  color: AppColors.textPrimary, size: 16.h),
            ),
          ),
          Gap.h(12),
          AppText(
            text: 'IntervuAI',
            fontSize: 18.fSize,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
          const Spacer(),
          Container(
            width: 38.h,
            height: 38.h,
            decoration: BoxDecoration(
              borderRadius: 10.r,
              color: AppColors.darkCard,
              border: Border.all(color: AppColors.darkCardBorder),
            ),
            child: Icon(Icons.person_outline_rounded,
                color: AppColors.textSecondary, size: 18.h),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 40.h,
              height: 40.h,
              decoration: BoxDecoration(
                borderRadius: 12.r,
                color: AppColors.iconBgTeal,
              ),
              child: Icon(Icons.document_scanner_outlined,
                  color: AppColors.accentTeal, size: 20.h),
            ),
            Gap.h(12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  text: 'Smart Analysis',
                  fontSize: 18.fSize,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
                AppText(
                  text: 'Upload once, practice forever',
                  fontSize: 12.fSize,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ],
        ),
        Gap.v(12),
        AppText(
          text:
          'Our AI scans your resume to generate hyper-realistic interview questions tailored to your specific tech stack and experience level.',
          fontSize: 13.fSize,
          color: AppColors.textSecondary,
          height: 1.6,
        ),
      ],
    );
  }

  Widget _buildDetectedSkills() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          text: 'DETECTED SKILLS',
          fontSize: 11.fSize,
          fontWeight: FontWeight.w700,
          color: AppColors.textMuted,
        ),
        Gap.v(10),
        Wrap(
          spacing: 8.h,
          runSpacing: 8.v,
          children: _ctrl.detectedSkills.map((skill) {
            Color bg;
            Color fg;
            if (skill == 'Flutter') {
              bg = AppColors.iconBgBlue;
              fg = AppColors.primaryCyan;
            } else if (skill == 'Dart') {
              bg = AppColors.iconBgTeal;
              fg = AppColors.accentTeal;
            } else {
              bg = AppColors.iconBgOrange;
              fg = AppColors.orangeAccent;
            }
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 6.v),
              decoration: BoxDecoration(
                borderRadius: 100.r,
                color: bg,
                border: Border.all(color: fg.withOpacity(0.4)),
              ),
              child: AppText(
                text: skill,
                fontSize: 12.fSize,
                fontWeight: FontWeight.w700,
                color: fg,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSessionConfig() {
    return Container(
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        borderRadius: 16.r,
        color: AppColors.darkCard,
        border: Border.all(color: AppColors.darkCardBorder),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  text: 'DIFFICULTY',
                  fontSize: 10.fSize,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textMuted,
                ),
                Gap.v(6),
                Obx(() => _ConfigChip(
                  label: _ctrl.resumeDifficulty.value,
                  onTap: () {},
                )),
              ],
            ),
          ),
          Container(width: 1, height: 40.v, color: AppColors.divider),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    text: 'LENGTH',
                    fontSize: 10.fSize,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textMuted,
                  ),
                  Gap.v(6),
                  Obx(() => _ConfigChip(
                    label: _ctrl.resumeSessionLength.value,
                    onTap: () {},
                  )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ConfigChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _ConfigChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppText(
            text: label,
            fontSize: 13.fSize,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
          Gap.h(4),
          Icon(Icons.keyboard_arrow_down_rounded,
              color: AppColors.textMuted, size: 16.h),
        ],
      ),
    );
  }
}
