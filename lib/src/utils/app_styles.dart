import 'package:flutter/material.dart';

/// ─── App Colors ────────────────────────────────────────
class AppColors {
  AppColors._();

  // Primary
  static const Color primary = Color(0xFF1e3a8a);
  static const Color primaryLight = Color(0xFF9fb8fc);
  static const Color primaryMuted = Color(0xFF5c6fa6);
  static const Color primaryDark = Color(0xFF0c215d);

  // Neutrals
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color grey = Colors.grey;
  static const Color greyLight = Color(0xFFBDBDBD);

  // Backgrounds
  static const Color scaffoldBg = Color(0xFFF5F6FA);

  // Shadows
  static Color shadow = Colors.black.withAlpha(38);

  // Background particles (for FinisherBackground)
  static const List<Color> particleColors = [
    primaryLight,
    primaryMuted,
    primaryDark,
  ];

  // Utility
  static const Color inputFill = Color(0xFFFAFAFA);
  static const Color border = Color(0xFFE8E8E8);
  static const Color inputBorder = Color(0xFFEEEEEE);
  static const Color warning = Colors.orange;
  static Color warningBg = Colors.orange.shade50;
  static Color warningIcon = Colors.orange.shade700;
  static const Color error = Colors.red;
  static Color errorLight = Colors.red.shade200;
  static const Color success = Colors.green;
}

/// ─── App Font Sizes ────────────────────────────────────
class AppFontSizes {
  AppFontSizes._();

  static const double xs = 11.0;
  static const double sm = 13.0;
  static const double md = 14.0;
  static const double lg = 16.0;
  static const double xl = 18.0;
  static const double xxl = 22.0;
  static const double xxxl = 28.0;
}

/// ─── App Text Styles ───────────────────────────────────
class AppTextStyles {
  AppTextStyles._();

  // Headings
  static const TextStyle heading = TextStyle(
    fontSize: AppFontSizes.xxl,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
  );

  static const TextStyle subheading = TextStyle(
    fontSize: AppFontSizes.md,
    color: AppColors.grey,
  );

  // Body
  static const TextStyle body = TextStyle(
    fontSize: AppFontSizes.md,
    color: AppColors.black,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: AppFontSizes.sm,
    color: AppColors.grey,
  );

  // Button
  static const TextStyle button = TextStyle(
    fontSize: AppFontSizes.lg,
    fontWeight: FontWeight.w600,
  );

  // Links
  static const TextStyle link = TextStyle(
    color: AppColors.primary,
    fontSize: AppFontSizes.sm,
    fontWeight: FontWeight.w600,
  );
}

/// ─── App Decorations ───────────────────────────────────
class AppDecorations {
  AppDecorations._();

  static BoxDecoration card = BoxDecoration(
    color: AppColors.white,
    borderRadius: BorderRadius.circular(28),
    boxShadow: [
      BoxShadow(
        color: AppColors.shadow,
        blurRadius: 30,
        offset: const Offset(0, 20),
      ),
    ],
  );

  static OutlineInputBorder inputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(14),
  );

  static OutlineInputBorder inputFocusedBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(14),
    borderSide: const BorderSide(color: AppColors.primary, width: 2),
  );
}

/// ─── App Sizes ─────────────────────────────────────────
class AppSizes {
  AppSizes._();

  static const double p4 = 4.0;
  static const double p8 = 8.0;
  static const double p12 = 12.0;
  static const double p16 = 16.0;
  static const double p20 = 20.0;
  static const double p24 = 24.0;
  static const double p32 = 32.0;
  static const double p40 = 40.0;
  static const double p48 = 48.0;

  static const double iconSmall = 20.0;
  static const double iconMedium = 24.0;
  static const double iconLarge = 28.0;
}

/// ─── App Radius ────────────────────────────────────────
class AppRadius {
  AppRadius._();

  static final BorderRadius small = BorderRadius.circular(8);
  static final BorderRadius medium = BorderRadius.circular(12);
  static final BorderRadius large = BorderRadius.circular(16);
  static final BorderRadius xl = BorderRadius.circular(28);
}
