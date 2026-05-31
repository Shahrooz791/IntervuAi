import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intervu_ai/controllers/profile_controller.dart';
import 'package:intervu_ai/core/constants/app_colors.dart';
import 'package:intervu_ai/core/utils/size_utils.dart';
import 'package:intervu_ai/view/screens/profile/edit_profile/components/edit_photo_section.dart';
import 'package:intervu_ai/view/screens/profile/edit_profile/components/edit_selectors.dart';
import 'package:intervu_ai/view/widgets/app_button.dart';
import 'package:intervu_ai/view/widgets/app_text.dart';
import 'package:intervu_ai/view/widgets/app_textfield.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _entryCtrl;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  final _ctrl = Get.put(ProfileController());

  @override
  void initState() {
    super.initState();
    _entryCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fade = CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.04),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOut));

    Future.delayed(const Duration(milliseconds: 60), () {
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
                        Gap.v(20),
                        EditProfilePhotoSection(ctrl: _ctrl),
                        Gap.v(20),
                        Obx(() {
                          if (_ctrl.selectedPhotoSource.value == 'avatar') {
                            return Column(
                              children: [
                                EditProfileAvatarGrid(ctrl: _ctrl),
                                Gap.v(20),
                              ],
                            );
                          }
                          return const SizedBox.shrink();
                        }),
                        _buildFieldLabel('FULL NAME'),
                        Gap.v(8),
                        AppTextField(
                          controller: _ctrl.fullNameCtrl,
                          hint: 'e.g. Ahmed Khan',
                          prefixIcon: Icon(Icons.person_outline_rounded,
                              color: AppColors.textMuted, size: 18.h),
                        ),
                        Gap.v(16),
                        _buildFieldLabel('JOB TITLE'),
                        Gap.v(8),
                        AppTextField(
                          controller: _ctrl.jobTitleCtrl,
                          hint: 'e.g. Senior Product Designer',
                          prefixIcon: Icon(Icons.work_outline_rounded,
                              color: AppColors.textMuted, size: 18.h),
                        ),
                        Gap.v(16),
                        EditProfileExpSelector(ctrl: _ctrl),
                        Gap.v(16),
                        EditProfileRoleSelector(ctrl: _ctrl),
                        Gap.v(16),
                        _buildBioField(),
                        Gap.v(16),
                        _buildFieldLabel('LINKEDIN PROFILE'),
                        Gap.v(8),
                        AppTextField(
                          controller: _ctrl.linkedinCtrl,
                          hint: 'linkedin.com/in/username',
                          keyboardType: TextInputType.url,
                          prefixIcon: Icon(Icons.link_rounded,
                              color: AppColors.textMuted, size: 18.h),
                        ),
                        Gap.v(28),
                        _buildSaveButton(),
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
            text: 'Edit profile',
            fontSize: 20.fSize,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
          const Spacer(),
          Obx(() => GestureDetector(
            onTap:
            _ctrl.isSaving.value ? null : _ctrl.onSaveChanges,
            child: AppText(
              text: 'Save',
              fontSize: 15.fSize,
              fontWeight: FontWeight.w700,
              color: _ctrl.isSaving.value
                  ? AppColors.textMuted
                  : AppColors.primaryCyan,
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return AppText(
      text: label,
      fontSize: 11.fSize,
      fontWeight: FontWeight.w700,
      color: AppColors.textMuted,
    );
  }

  Widget _buildBioField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _buildFieldLabel('BIO'),
            const Spacer(),
            Obx(() => AppText(
              text: '${_ctrl.bio.value.length}/120',
              fontSize: 11.fSize,
              color: AppColors.textMuted,
            )),
          ],
        ),
        Gap.v(8),
        AppTextField(
          controller: _ctrl.bioCtrl,
          hint: 'Tell us about your career goals...',
          maxLines: 4,
          maxLength: 120,
          onChanged: (_) {
            // trigger reactive update for counter
            _ctrl.bio.value = _ctrl.bioCtrl.text;
          },
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return Obx(() => AppButton(
      text: 'Save changes',
      onTap:
      _ctrl.isSaving.value ? null : _ctrl.onSaveChanges,
      isLoading: _ctrl.isSaving.value,
      type: AppButtonType.primary,
    ));
  }
}
