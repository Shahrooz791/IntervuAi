import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intervu_ai/controllers/profile_setup_controller.dart';
import 'package:intervu_ai/core/constants/app_colors.dart';
import 'package:intervu_ai/core/utils/size_utils.dart';
import 'package:intervu_ai/view/widgets/app_button.dart';
import 'package:intervu_ai/view/widgets/app_text.dart';
import 'package:intervu_ai/view/widgets/app_textfield.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen>
    with TickerProviderStateMixin {
  late AnimationController _entryCtrl;
  late AnimationController _floatCtrl;
  late AnimationController _glowCtrl;

  late Animation<double> _headerFade;
  late Animation<Offset> _headerSlide;
  late Animation<double> _avatarScale;
  late Animation<double> _avatarFade;
  late Animation<double> _formFade;
  late Animation<Offset> _formSlide;
  late Animation<double> _footerFade;
  late Animation<Offset> _footerSlide;
  late Animation<double> _floatAnim;
  late Animation<double> _glowAnim;

  final _ctrl = Get.put(ProfileSetupController());

  @override
  void initState() {
    super.initState();
    _initAnimations();
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) _entryCtrl.forward();
    });
  }

  void _initAnimations() {
    _entryCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    );

    _floatCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..repeat(reverse: true);

    _glowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _headerFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _entryCtrl,
          curve: const Interval(0.0, 0.4, curve: Curves.easeOut)),
    );
    _headerSlide =
        Tween<Offset>(begin: const Offset(0, -0.3), end: Offset.zero).animate(
          CurvedAnimation(
              parent: _entryCtrl,
              curve: const Interval(0.0, 0.45, curve: Curves.easeOut)),
        );

    _avatarFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _entryCtrl,
          curve: const Interval(0.2, 0.55, curve: Curves.easeOut)),
    );
    _avatarScale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
          parent: _entryCtrl,
          curve: const Interval(0.2, 0.6, curve: Curves.elasticOut)),
    );

    _formFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _entryCtrl,
          curve: const Interval(0.45, 0.85, curve: Curves.easeOut)),
    );
    _formSlide =
        Tween<Offset>(begin: const Offset(0, 0.4), end: Offset.zero).animate(
          CurvedAnimation(
              parent: _entryCtrl,
              curve: const Interval(0.45, 0.85, curve: Curves.easeOut)),
        );

    _footerFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _entryCtrl,
          curve: const Interval(0.7, 1.0, curve: Curves.easeOut)),
    );
    _footerSlide =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
          CurvedAnimation(
              parent: _entryCtrl,
              curve: const Interval(0.7, 1.0, curve: Curves.easeOut)),
        );

    _floatAnim = Tween<double>(begin: -5.0, end: 5.0).animate(
      CurvedAnimation(parent: _floatCtrl, curve: Curves.easeInOut),
    );

    _glowAnim = Tween<double>(begin: 0.3, end: 0.7).animate(
      CurvedAnimation(parent: _glowCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _entryCtrl.dispose();
    _floatCtrl.dispose();
    _glowCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: Stack(
        children: [
          _buildBackground(),
          SafeArea(
            child: Column(
              children: [
                FadeTransition(
                  opacity: _headerFade,
                  child: SlideTransition(
                    position: _headerSlide,
                    child: _buildTopBar(),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 24.h),
                    child: Column(
                      children: [
                        Gap.v(20),
                        _buildAvatarSection(),
                        Gap.v(32),
                        _buildForm(),
                        Gap.v(24),
                        _buildProTip(),
                        Gap.v(24),
                        _buildSaveButton(),
                        Gap.v(32),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return AnimatedBuilder(
      animation: _glowAnim,
      builder: (_, __) => Stack(
        children: [
          Container(color: AppColors.darkBg),
          Positioned(
            top: -120.v,
            left: -80.h,
            child: Container(
              width: 320.h,
              height: 320.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.accentPurple.withOpacity(0.07 * _glowAnim.value),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: -80.v,
            right: -60.h,
            child: Container(
              width: 250.h,
              height: 250.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primaryBlue.withOpacity(0.06 * _glowAnim.value),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.h, vertical: 16.v),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: ShaderMask(
              shaderCallback: (bounds) => AppColors.primaryGradient
                  .createShader(
                  Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
              child: AppText(
                text: 'IntervuAI',
                fontSize: 16.fSize,
                fontWeight: FontWeight.w800,
                color: AppColors.white,
              ),
            ),
          ),
          Gap.v(16),
          Center(
            child: AppText(
              text: 'Setup Your Profile',
              fontSize: 26.fSize,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          Gap.v(6),
          Center(
            child: AppText(
              text: 'Help us personalize your interview experience',
              fontSize: 14.fSize,
              color: AppColors.textSecondary,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarSection() {
    return AnimatedBuilder(
      animation: _entryCtrl,
      builder: (_, __) => FadeTransition(
        opacity: _avatarFade,
        child: Transform.scale(
          scale: _avatarScale.value,
          child: Column(
            children: [
              AnimatedBuilder(
                animation: _floatAnim,
                builder: (_, __) => Transform.translate(
                  offset: Offset(0, _floatAnim.value),
                  child: _AvatarPicker(ctrl: _ctrl),
                ),
              ),
              Gap.v(20),
              _buildPhotoOptions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoOptions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _PhotoOptionChip(
          label: 'Camera',
          icon: Icons.camera_alt_outlined,
          onTap: _ctrl.onCameraTap,
        ),
        Gap.h(10),
        _PhotoOptionChip(
          label: 'Gallery',
          icon: Icons.photo_library_outlined,
          onTap: _ctrl.onGalleryTap,
        ),
        Gap.h(10),
        _PhotoOptionChip(
          label: 'Avatar',
          icon: Icons.face_retouching_natural_rounded,
          onTap: _ctrl.onAvatarTap,
        ),
      ],
    );
  }

  Widget _buildForm() {
    return FadeTransition(
      opacity: _formFade,
      child: SlideTransition(
        position: _formSlide,
        child: Form(
          key: _ctrl.setupFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _FieldLabel(label: 'Display Name'),
              Gap.v(8),
              AppTextField(
                hint: 'e.g. Alex Rivera',
                controller: _ctrl.displayNameCtrl,
                textInputAction: TextInputAction.next,
                validator: _ctrl.validateDisplayName,
                prefixIcon: Icon(
                  Icons.person_outline_rounded,
                  color: AppColors.textMuted,
                  size: 20.h,
                ),
              ),
              Gap.v(20),
              _FieldLabel(label: 'Job Title'),
              Gap.v(8),
              AppTextField(
                hint: 'e.g. Senior Software Engineer',
                controller: _ctrl.jobTitleCtrl,
                textInputAction: TextInputAction.next,
                validator: _ctrl.validateJobTitle,
                prefixIcon: Icon(
                  Icons.work_outline_rounded,
                  color: AppColors.textMuted,
                  size: 20.h,
                ),
              ),
              Gap.v(20),
              _FieldLabel(label: 'Years of Experience'),
              Gap.v(10),
              _ExperienceSelector(ctrl: _ctrl),
              Gap.v(20),
              _FieldLabel(label: 'Target Companies'),
              Gap.v(8),
              AppTextField(
                hint: 'Google, Meta, OpenAI...',
                controller: _ctrl.targetCompaniesCtrl,
                textInputAction: TextInputAction.done,
                prefixIcon: Icon(
                  Icons.business_outlined,
                  color: AppColors.textMuted,
                  size: 20.h,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProTip() {
    return FadeTransition(
      opacity: _formFade,
      child: AnimatedBuilder(
        animation: _glowAnim,
        builder: (_, __) => Container(
          padding: EdgeInsets.all(16.h),
          decoration: BoxDecoration(
            borderRadius: 16.r,
            color: AppColors.iconBgPurple,
            border: Border.all(
              color: AppColors.accentPurple
                  .withOpacity(0.2 + 0.1 * _glowAnim.value),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.accentPurple
                    .withOpacity(0.05 * _glowAnim.value),
                blurRadius: 16.h,
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40.h,
                height: 40.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.accentPurple.withOpacity(0.2),
                ),
                child: Icon(
                  Icons.lightbulb_outline_rounded,
                  color: AppColors.accentPurple,
                  size: 20.h,
                ),
              ),
              Gap.h(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      text: 'Pro Tip',
                      fontSize: 14.fSize,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                    Gap.v(4),
                    AppText(
                      text:
                      'Personalizing your profile helps our AI tailor interview questions to your specific career path and target industry.',
                      fontSize: 12.fSize,
                      color: AppColors.textSecondary,
                      height: 1.55,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return FadeTransition(
      opacity: _footerFade,
      child: SlideTransition(
        position: _footerSlide,
        child: Obx(() => AppButton(
          text: 'Save & Continue',
          isLoading: _ctrl.isSaving.value,
          onTap: _ctrl.saveAndContinue,
          suffixIcon: _ctrl.isSaving.value
              ? null
              : Icon(
            Icons.arrow_forward_rounded,
            color: AppColors.white,
            size: 20.h,
          ),
        )),
      ),
    );
  }
}

// ─── Avatar Picker ────────────────────────────────────────────────────────────

class _AvatarPicker extends StatefulWidget {
  final ProfileSetupController ctrl;
  const _AvatarPicker({required this.ctrl});

  @override
  State<_AvatarPicker> createState() => _AvatarPickerState();
}

class _AvatarPickerState extends State<_AvatarPicker>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseCtrl;
  late Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);
    _pulse = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final hasPhoto = widget.ctrl.hasPhoto.value;
      return AnimatedBuilder(
        animation: _pulse,
        builder: (_, __) => GestureDetector(
          onTap: widget.ctrl.onGalleryTap,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer glow ring
              Container(
                width: 120.h,
                height: 120.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primaryBlue
                        .withOpacity(0.15 + 0.15 * _pulse.value),
                    width: 1.5,
                  ),
                ),
              ),
              // Inner dashed ring with content
              Container(
                width: 104.h,
                height: 104.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.darkCard,
                  border: Border.all(
                    color: hasPhoto
                        ? AppColors.primaryBlue.withOpacity(0.6)
                        : AppColors.darkCardBorder
                        .withOpacity(0.4 + 0.3 * _pulse.value),
                    width: hasPhoto ? 2 : 1.5,
                  ),
                  boxShadow: hasPhoto
                      ? [
                    BoxShadow(
                      color: AppColors.primaryBlue.withOpacity(0.2),
                      blurRadius: 20.h,
                    )
                  ]
                      : null,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      hasPhoto
                          ? Icons.check_circle_rounded
                          : Icons.camera_alt_outlined,
                      color: hasPhoto
                          ? AppColors.primaryCyan
                          : AppColors.textSecondary,
                      size: 28.h,
                    ),
                    Gap.v(4),
                    AppText(
                      text: hasPhoto ? 'Photo Added' : 'Add Photo',
                      fontSize: 11.fSize,
                      fontWeight: FontWeight.w600,
                      color: hasPhoto
                          ? AppColors.primaryCyan
                          : AppColors.textSecondary,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

// ─── Photo Option Chip ────────────────────────────────────────────────────────

class _PhotoOptionChip extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _PhotoOptionChip({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  State<_PhotoOptionChip> createState() => _PhotoOptionChipState();
}

class _PhotoOptionChipState extends State<_PhotoOptionChip> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        transform:
        _pressed ? (Matrix4.identity()..scale(0.94)) : Matrix4.identity(),
        padding: EdgeInsets.symmetric(horizontal: 14.h, vertical: 9.v),
        decoration: BoxDecoration(
          borderRadius: 100.r,
          color: _pressed ? AppColors.primaryBlue.withOpacity(0.15) : AppColors.darkCard,
          border: Border.all(
            color: _pressed
                ? AppColors.primaryBlue.withOpacity(0.5)
                : AppColors.darkCardBorder,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(widget.icon,
                color: _pressed ? AppColors.primaryCyan : AppColors.textSecondary,
                size: 14.h),
            Gap.h(6),
            AppText(
              text: widget.label,
              fontSize: 13.fSize,
              fontWeight: FontWeight.w600,
              color: _pressed ? AppColors.primaryCyan : AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Experience Selector ──────────────────────────────────────────────────────

class _ExperienceSelector extends StatelessWidget {
  final ProfileSetupController ctrl;
  const _ExperienceSelector({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Row(
      children: ctrl.experienceOptions.map((opt) {
        final isSelected = ctrl.selectedExperience.value == opt;
        final isLast = opt == ctrl.experienceOptions.last;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: isLast ? 0 : 8.h),
            child: _ExpChip(
              label: opt,
              isSelected: isSelected,
              onTap: () => ctrl.selectExperience(opt),
            ),
          ),
        );
      }).toList(),
    ));
  }
}

class _ExpChip extends StatefulWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ExpChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_ExpChip> createState() => _ExpChipState();
}

class _ExpChipState extends State<_ExpChip>
    with SingleTickerProviderStateMixin {
  late AnimationController _selectCtrl;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _selectCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 1.06).animate(
      CurvedAnimation(parent: _selectCtrl, curve: Curves.easeOut),
    );
    if (widget.isSelected) _selectCtrl.forward();
  }

  @override
  void didUpdateWidget(_ExpChip old) {
    super.didUpdateWidget(old);
    if (widget.isSelected && !old.isSelected) {
      _selectCtrl.forward();
    } else if (!widget.isSelected && old.isSelected) {
      _selectCtrl.reverse();
    }
  }

  @override
  void dispose() {
    _selectCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _scaleAnim,
        builder: (_, __) => Transform.scale(
          scale: _scaleAnim.value,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            padding: EdgeInsets.symmetric(vertical: 13.v),
            decoration: BoxDecoration(
              borderRadius: 12.r,
              gradient: widget.isSelected ? AppColors.primaryGradient : null,
              color: widget.isSelected ? null : AppColors.darkCard,
              border: Border.all(
                color: widget.isSelected
                    ? Colors.transparent
                    : AppColors.darkCardBorder,
              ),
              boxShadow: widget.isSelected
                  ? [
                BoxShadow(
                  color: AppColors.primaryBlue.withOpacity(0.35),
                  blurRadius: 12.h,
                  offset: Offset(0, 4.v),
                )
              ]
                  : null,
            ),
            child: Center(
              child: AppText(
                text: widget.label,
                fontSize: 14.fSize,
                fontWeight: FontWeight.w700,
                color: widget.isSelected
                    ? AppColors.white
                    : AppColors.textSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Field Label ──────────────────────────────────────────────────────────────

class _FieldLabel extends StatelessWidget {
  final String label;
  const _FieldLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return AppText(
      text: label,
      fontSize: 13.fSize,
      fontWeight: FontWeight.w600,
      color: AppColors.textSecondary,
    );
  }
}
