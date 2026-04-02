import 'package:flutter/material.dart';

class AppColors {
  // iOS System Colors
  static const Color iosBlue = Color(0xFF007AFF);
  static const Color iosGreen = Color(0xFF34C759);
  static const Color iosIndigo = Color(0xFF5856D6);
  static const Color iosOrange = Color(0xFFFF9500);
  static const Color iosPink = Color(0xFFFF2D55);
  static const Color iosPurple = Color(0xFFAF52DE);
  static const Color iosRed = Color(0xFFFF3B30);
  static const Color iosTeal = Color(0xFF5AC8FA);
  static const Color iosYellow = Color(0xFFFFCC00);
  static const Color iosGray = Color(0xFF8E8E93);
  static const Color iosGray2 = Color(0xFFAEAEB2);
  static const Color iosGray3 = Color(0xFFC7C7CC);
  static const Color iosGray4 = Color(0xFFD1D1D6);
  static const Color iosGray5 = Color(0xFFE5E5EA);
  static const Color iosGray6 = Color(0xFFF2F2F7);

  // iOS Background Colors
  static const Color iosLightBackground = Color(0xFFF2F2F7);
  static const Color iosDarkBackground = Color(0xFF000000);
  static const Color iosLightText = Color(0xFF000000);
  static const Color iosDarkText = Color(0xFFFFFFFF);
  static const Color iosSecondaryLightText = Color(0xFF8E8E93);
  static const Color iosSecondaryDarkText = Color(0xFF8E8E93);

  // Legacy terminal colors (kept for reference)
  static const Color terminalBlack = Color(0xFF000000);
  static const Color terminalDarkGray = Color(0xFF1E1E1E);
  static const Color terminalMediumGray = Color(0xFF2D2D2D);
  static const Color terminalLightGray = Color(0xFF3C3C3C);
  static const Color terminalBackground = Color(0xFF0C0C0C);
  static const Color terminalGreen = Color(0xFF00FF00);
  static const Color terminalBrightGreen = Color(0xFF00FF41);
  static const Color terminalAmber = Color(0xFFFFB000);
  static const Color terminalYellow = Color(0xFFFFFF00);
  static const Color terminalRed = Color(0xFFFF0000);
  static const Color terminalBrightRed = Color(0xFFFF4444);
  static const Color terminalCyan = Color(0xFF00FFFF);
  static const Color terminalBlue = Color(0xFF0080FF);
  static const Color terminalMagenta = Color(0xFFFF00FF);
  static const Color terminalWhite = Color(0xFFFFFFFF);
  static const Color terminalGray = Color(0xFF808080);

  // iOS semantic colors for the app
  static const Color backgroundDark = iosDarkBackground;
  static const Color backgroundDarkSecondary = Color(0xFF1C1C1E);
  static const Color cardDark = Color(0xFF2C2C2E);
  static const Color cardDarkBorder = Color(0xFF3A3A3C);
  static const Color solarGold = iosOrange;
  static const Color solarAmber = iosYellow;
  static const Color solarGoldDark = iosOrange;
  static const Color emeraldGreen = iosGreen;
  static const Color emeraldPrimary = iosGreen;
  static const Color emeraldDark = iosGreen;
  static const Color electricCyan = iosTeal;
  static const Color cyanLight = iosTeal;
  static const Color cyanAccent = iosTeal;
  static const Color coralRed = iosRed;
  static const Color warningOrange = iosOrange;

  // Text opacity helpers
  static Color textPrimary(BuildContext context) =>
      Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.87);
  static Color textSecondary(BuildContext context) =>
      Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.60);
  static Color textDisabled(BuildContext context) =>
      Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.38);
}

class AppGradients {
  // Terminal-style gradients (subtle, monochrome with accent colors)
  static const LinearGradient terminalGreen = LinearGradient(
    colors: [Color(0xFF00FF00), Color(0xFF00CC00)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient terminalAmber = LinearGradient(
    colors: [Color(0xFFFFB000), Color(0xFFFF8800)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient terminalRed = LinearGradient(
    colors: [Color(0xFFFF0000), Color(0xFFCC0000)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient terminalCyan = LinearGradient(
    colors: [Color(0xFF00FFFF), Color(0xFF00CCCC)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient terminalDark = LinearGradient(
    colors: [Color(0xFF1E1E1E), Color(0xFF0C0C0C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Legacy gradients for compatibility
  static const LinearGradient solarGold = terminalAmber;
  static const LinearGradient emerald = terminalGreen;
  static const LinearGradient cyan = terminalCyan;
  static const LinearGradient cardDark = terminalDark;
  static const LinearGradient coral = terminalRed;

  // Terminal-style hero gradients
  static LinearGradient heroSolar = LinearGradient(
    colors: [
      AppColors.terminalAmber.withValues(alpha: 0.15),
      AppColors.terminalYellow.withValues(alpha: 0.05),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient heroEmerald = LinearGradient(
    colors: [
      AppColors.terminalGreen.withValues(alpha: 0.15),
      AppColors.terminalBrightGreen.withValues(alpha: 0.05),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient heroCyan = LinearGradient(
    colors: [
      AppColors.terminalCyan.withValues(alpha: 0.15),
      AppColors.terminalCyan.withValues(alpha: 0.05),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class AppShadows {
  // Terminal-style shadows (subtle, no glow effects)
  static List<BoxShadow> terminal = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.5),
      blurRadius: 2,
      offset: const Offset(1, 1),
    ),
  ];

  static List<BoxShadow> terminalInset = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.3),
      blurRadius: 2,
      offset: const Offset(-1, -1),
    ),
    BoxShadow(
      color: AppColors.terminalWhite.withValues(alpha: 0.1),
      blurRadius: 2,
      offset: const Offset(1, 1),
    ),
  ];

  // Legacy shadows for compatibility
  static List<BoxShadow> glow(
    Color color, {
    double blurRadius = 20,
    double spreadRadius = -2,
  }) {
    return terminal;
  }

  static List<BoxShadow> glowSmall(Color color) {
    return terminal;
  }

  static List<BoxShadow> cardShadow() {
    return terminal;
  }
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
