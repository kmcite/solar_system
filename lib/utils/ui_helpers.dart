import 'package:flutter/material.dart';

class AppColors {
  // Backgrounds
  static const Color backgroundDark = Color(0xFF060D1E);
  static const Color backgroundDarkSecondary = Color(0xFF0B1326);
  static const Color cardDark = Color(0xFF111A2E);
  static const Color cardDarkBorder = Color(0xFF1A2540);

  // Primary - Solar Gold
  static const Color solarGold = Color(0xFFFFB800);
  static const Color solarAmber = Color(0xFFFFC640);
  static const Color solarGoldDark = Color(0xFFE3AA00);

  // Secondary - Emerald Green
  static const Color emeraldGreen = Color(0xFF00E68A);
  static const Color emeraldPrimary = Color(0xFF10B981);
  static const Color emeraldDark = Color(0xFF0A8F63);

  // Tertiary - Electric Cyan
  static const Color electricCyan = Color(0xFF00B4D8);
  static const Color cyanLight = Color(0xFF89CEFF);
  static const Color cyanAccent = Color(0xFF23ACF1);

  // Error/Warning
  static const Color coralRed = Color(0xFFFF4757);
  static const Color warningOrange = Color(0xFFFF8C42);

  // Text opacity helpers
  static Color textPrimary(BuildContext context) =>
      Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.87);
  static Color textSecondary(BuildContext context) =>
      Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.60);
  static Color textDisabled(BuildContext context) =>
      Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.38);
}

class AppGradients {
  static const LinearGradient solarGold = LinearGradient(
    colors: [Color(0xFFFFB800), Color(0xFFFFC640)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient emerald = LinearGradient(
    colors: [Color(0xFF00E68A), Color(0xFF10B981)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cyan = LinearGradient(
    colors: [Color(0xFF00B4D8), Color(0xFF89CEFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardDark = LinearGradient(
    colors: [Color(0xFF111A2E), Color(0xFF0B1326)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient coral = LinearGradient(
    colors: [Color(0xFFFF4757), Color(0xFFFF6B81)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Hero card gradients
  static LinearGradient heroSolar = LinearGradient(
    colors: [
      const Color(0xFFFFB800).withValues(alpha: 0.15),
      const Color(0xFFFFC640).withValues(alpha: 0.05),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient heroEmerald = LinearGradient(
    colors: [
      const Color(0xFF00E68A).withValues(alpha: 0.15),
      const Color(0xFF10B981).withValues(alpha: 0.05),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient heroCyan = LinearGradient(
    colors: [
      const Color(0xFF00B4D8).withValues(alpha: 0.15),
      const Color(0xFF89CEFF).withValues(alpha: 0.05),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class AppShadows {
  static List<BoxShadow> glow(
    Color color, {
    double blurRadius = 20,
    double spreadRadius = -2,
  }) => [
    BoxShadow(
      color: color.withValues(alpha: 0.3),
      blurRadius: blurRadius,
      spreadRadius: spreadRadius,
    ),
  ];

  static List<BoxShadow> glowSmall(Color color) => [
    BoxShadow(
      color: color.withValues(alpha: 0.2),
      blurRadius: 12,
      spreadRadius: -4,
    ),
  ];

  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.2),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
  ];
}

class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 32;

  static const double cardRadius = 20;
  static const double cardRadiusSmall = 14;
  static const double cardPadding = 20;
}
