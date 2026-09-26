import 'package:flutter/material.dart';

/// VineCare design system colors extracted from Figma prototype
class AppColors {
  AppColors._();

  // Backgrounds
  static const Color background = Color(0xFF0E1218);
  static const Color surface = Color(0xFF171D25);
  static const Color inputField = Color(0xFF1C232C);
  static const Color divider = Color(0xFF252E39);

  // Primary green
  static const Color primary = Color(0xFF318E52);
  static const Color primaryLight = Color(0xFF56C17C);
  static const Color primaryTint15 = Color(0x26318E52); // 15% opacity
  static const Color primaryTint20 = Color(0x33318E52); // 20% opacity
  static const Color primaryGlow = Color(0x26206138); // splash glow

  // Text
  static const Color textPrimary = Color(0xFFECEFF2);
  static const Color textSecondary = Color(0xFF96A0AD);
  static const Color textMuted = Color(0xFF616B77);
  static const Color textWhite = Colors.white;

  // Accent
  static const Color gold = Color(0xFFE1B444);
  static const Color goldTint = Color(0x26E1B444); // 15% opacity

  // Status colors
  static const Color pending = Color(0xFFEF9E33);
  static const Color pendingTint = Color(0x26EF9E33);
  static const Color error = Color(0xFFE05C5C);
  static const Color errorTint = Color(0x26E05C5C);

  // Bottom nav
  static const Color navActive = Color(0xFF56C17C);
  static const Color navInactive = Color(0xFF616B77);
  static const Color navActiveBg = Color(0x26318E52);
}
