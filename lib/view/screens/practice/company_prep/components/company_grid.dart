import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intervu_ai/controllers/mock_interview_controller.dart';
import 'package:intervu_ai/core/constants/app_colors.dart';
import 'package:intervu_ai/core/utils/size_utils.dart';
import 'package:intervu_ai/view/widgets/app_text.dart';

class CompanyGrid extends StatelessWidget {
  final MockInterviewController ctrl;
  const CompanyGrid({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Obx(() => GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.h,
        mainAxisSpacing: 10.h,
        childAspectRatio: 2.0,
      ),
      itemCount: ctrl.companies.length,
      itemBuilder: (_, i) {
        final company = ctrl.companies[i];
        final isSelected =
            ctrl.selectedCompany.value == company['name'];
        return _CompanyCard(
          company: company,
          isSelected: isSelected,
          onTap: () => ctrl.selectCompany(company['name'] as String),
        );
      },
    ));
  }
}

class _CompanyCard extends StatefulWidget {
  final Map<String, dynamic> company;
  final bool isSelected;
  final VoidCallback onTap;
  const _CompanyCard({
    required this.company,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_CompanyCard> createState() => _CompanyCardState();
}

class _CompanyCardState extends State<_CompanyCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final diffColor = Color(widget.company['diffColor'] as int);
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        transform: _pressed
            ? (Matrix4.identity()..scale(0.96))
            : Matrix4.identity(),
        padding: EdgeInsets.all(14.h),
        decoration: BoxDecoration(
          borderRadius: 14.r,
          color: AppColors.darkCard,
          border: Border.all(
            color: widget.isSelected
                ? AppColors.primaryBlue.withOpacity(0.7)
                : AppColors.darkCardBorder,
            width: widget.isSelected ? 1.5 : 1,
          ),
          boxShadow: widget.isSelected
              ? [
            BoxShadow(
              color: AppColors.primaryBlue.withOpacity(0.15),
              blurRadius: 12.h,
            ),
          ]
              : [],
        ),
        child: Row(
          children: [
            Container(
              width: 36.h,
              height: 36.h,
              decoration: BoxDecoration(
                borderRadius: 10.r,
                color: AppColors.iconBgBlue,
              ),
              child: Center(
                child: Text(
                  widget.company['icon'] as String,
                  style: TextStyle(fontSize: 18.fSize),
                ),
              ),
            ),
            Gap.h(10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppText(
                    text: widget.company['name'] as String,
                    fontSize: 13.fSize,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    maxLines: 1,
                  ),
                  Gap.v(3),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 6.h, vertical: 2.v),
                    decoration: BoxDecoration(
                      borderRadius: 100.r,
                      color: diffColor.withOpacity(0.15),
                    ),
                    child: AppText(
                      text: widget.company['difficulty'] as String,
                      fontSize: 9.fSize,
                      fontWeight: FontWeight.w700,
                      color: diffColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
