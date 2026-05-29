import 'package:flutter/material.dart';

class AppColors {
  // Background Colors
  static const Color darkBg = Color(0xFF080D1A);
  static const Color darkBgSecondary = Color(0xFF0D1526);
  static const Color darkCard = Color(0xFF111827);
  static const Color darkCardBorder = Color(0xFF1E293B);
  static const Color darkSurface = Color(0xFF0F1929);

  // Primary / Accent Colors
  static const Color primaryBlue = Color(0xFF3B82F6);
  static const Color primaryCyan = Color(0xFF06B6D4);
  static const Color accentTeal = Color(0xFF14B8A6);
  static const Color accentPurple = Color(0xFF8B5CF6);

  // Gradient Colors
  static const Color gradientStart = Color(0xFF3B82F6);
  static const Color gradientMid = Color(0xFF06B6D4);
  static const Color gradientEnd = Color(0xFF8B5CF6);

  // Button Gradient
  static const Color btnGradientStart = Color(0xFF2563EB);
  static const Color btnGradientEnd = Color(0xFF06B6D4);

  // Text Colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF64748B);
  static const Color textAccent = Color(0xFF06B6D4);

  // Role Card Colors
  static const Color cardSelected = Color(0xFF1E3A5F);
  static const Color cardSelectedBorder = Color(0xFF3B82F6);
  static const Color cardUnselected = Color(0xFF111827);
  static const Color cardUnselectedBorder = Color(0xFF1E293B);

  // Experience Level Colors
  static const Color expCardSelected = Color(0xFF1A2E4A);
  static const Color expCardSelectedBorder = Color(0xFF2563EB);

  // Step Indicator
  static const Color stepActive = Color(0xFF3B82F6);
  static const Color stepInactive = Color(0xFF1E293B);

  // Icon BG
  static const Color iconBgBlue = Color(0xFF1E3A5F);
  static const Color iconBgPurple = Color(0xFF2D1B69);
  static const Color iconBgTeal = Color(0xFF134E4A);

  // Status Colors
  static const Color errorRed = Color(0xFFEF4444);
  static const Color successGreen = Color(0xFF22C55E);
  static const Color warningAmber = Color(0xFFF59E0B);

  // Misc
  static const Color white = Color(0xFFFFFFFF);
  static const Color overlay = Color(0x80000000);
  static const Color shimmer = Color(0x1AFFFFFF);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [btnGradientStart, btnGradientEnd],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient bgGradient = LinearGradient(
    colors: [darkBg, darkBgSecondary],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient logoGradient = LinearGradient(
    colors: [accentPurple, primaryBlue, primaryCyan],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}