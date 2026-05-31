import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intervu_ai/controllers/profile_controller.dart';
import 'package:intervu_ai/core/constants/app_colors.dart';
import 'package:intervu_ai/core/utils/size_utils.dart';
import 'package:intervu_ai/view/widgets/app_text.dart';

class EditProfilePhotoSection extends StatelessWidget {
  final ProfileController ctrl;
  const EditProfilePhotoSection({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildAvatarPreview(),
        Gap.v(16),
        _buildPhotoSourceRow(),
      ],
    );
  }

  Widget _buildAvatarPreview() {
    return Center(
      child: Stack(
        children: [
          Container(
            width: 88.h,
            height: 88.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppColors.primaryGradient,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryBlue.withOpacity(0.4),
                  blurRadius: 18.h,
                ),
              ],
            ),
            child: Center(
              child: Obx(() => AppText(
                text: ctrl.userInitials.value,
                fontSize: 28.fSize,
                fontWeight: FontWeight.w800,
                color: AppColors.white,
              )),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 26.h,
              height: 26.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppColors.primaryGradient,
                border: Border.all(color: AppColors.darkBg, width: 2),
              ),
              child: Icon(Icons.edit_rounded,
                  color: AppColors.white, size: 13.h),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoSourceRow() {
    return Obx(() => Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _SourceChip(
          icon: Icons.camera_alt_outlined,
          label: 'Camera',
          isSelected: ctrl.selectedPhotoSource.value == 'camera',
          onTap: ctrl.onCameraTap,
        ),
        Gap.h(10),
        _SourceChip(
          icon: Icons.photo_library_outlined,
          label: 'Gallery',
          isSelected: ctrl.selectedPhotoSource.value == 'gallery',
          onTap: ctrl.onGalleryTap,
        ),
        Gap.h(10),
        _SourceChip(
          icon: Icons.face_outlined,
          label: 'Avatar',
          isSelected: ctrl.selectedPhotoSource.value == 'avatar',
          onTap: ctrl.onAvatarTap,
        ),
      ],
    ));
  }
}

class _SourceChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SourceChip({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 14.h, vertical: 8.v),
        decoration: BoxDecoration(
          borderRadius: 100.r,
          color: isSelected
              ? AppColors.iconBgBlue
              : AppColors.darkCard,
          border: Border.all(
            color: isSelected
                ? AppColors.primaryBlue.withOpacity(0.6)
                : AppColors.darkCardBorder,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                size: 14.h,
                color: isSelected
                    ? AppColors.primaryCyan
                    : AppColors.textMuted),
            Gap.h(6),
            AppText(
              text: label,
              fontSize: 12.fSize,
              fontWeight: FontWeight.w600,
              color: isSelected
                  ? AppColors.primaryCyan
                  : AppColors.textMuted,
            ),
          ],
        ),
      ),
    );
  }
}

class EditProfileAvatarGrid extends StatelessWidget {
  final ProfileController ctrl;
  const EditProfileAvatarGrid({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          text: 'CHOOSE ILLUSTRATION',
          fontSize: 11.fSize,
          fontWeight: FontWeight.w700,
          color: AppColors.textMuted,
        ),
        Gap.v(12),
        Obx(() {
          // Register dependency so GridView rebuilds when avatar changes
          ctrl.selectedAvatarId.value;
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 10.h,
              mainAxisSpacing: 10.h,
              childAspectRatio: 1,
            ),
            itemCount: ctrl.avatarList.length,
            itemBuilder: (_, i) {
              final avatar = ctrl.avatarList[i];
              final isSelected =
                  ctrl.selectedAvatarId.value == avatar['id'];
              return GestureDetector(
                onTap: () => ctrl.selectAvatar(avatar['id']),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    borderRadius: 14.r,
                    color: isSelected
                        ? AppColors.iconBgBlue
                        : AppColors.darkCard,
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primaryBlue
                          : AppColors.darkCardBorder,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      avatar['emoji'],
                      style: TextStyle(fontSize: 28.fSize),
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ],
    );
  }
}
