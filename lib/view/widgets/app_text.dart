import 'package:flutter/material.dart';
import 'package:intervu_ai/core/utils/size_utils.dart';

class AppText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final double? height;

  const AppText({
    super.key,
    required this.text,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.textAlign,
    this.maxLines,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: maxLines != null ? TextOverflow.ellipsis : null,
      style: TextStyle(
        fontSize: fontSize ?? 16.fSize,
        fontWeight: fontWeight ?? FontWeight.w400,
        fontFamily: 'Urbanist',
        color: color,
        height: height ?? 1.4,
      ),
    );
  }
}