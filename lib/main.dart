import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:signals_flutter/signals_flutter.dart';

import 'package:solar_system/business/app.dart';
import 'package:solar_system/business/battery.dart';
import 'package:solar_system/business/battery_upgrades.dart';
import 'package:solar_system/business/radiation.dart';
import 'package:solar_system/business/panels.dart';
import 'package:solar_system/business/revenue.dart';
import 'package:solar_system/screens/game_screen.dart';
import 'package:solar_system/utils/ui_helpers.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Start timer-based services
  startRadiation();
  startBatteryDischarge();
  startRevenue();

  // Wire inter-signal effects (radiation -> panels, radiation -> battery)
  effect(() {
    setPanelRadiation(radiation.value);
  });

  effect(() {
    updateBatteryRadiation(radiation.value);
  });

  // Battery upgrade effect - when currentBatteryUpgrade changes, apply to battery
  effect(() {
    final upgrade = currentBatteryUpgrade.value;
    applyBatteryUpgrade(
      newMaxCapacity: upgrade.capacityWh,
      newVoltage: upgrade.voltage,
      newTierName: upgrade.name,
      newChargeMultiplier: upgrade.chargeMultiplier,
      newEfficiency: upgrade.efficiency,
    );
  });

  // Initialize app (remove splash screen)
  initializeApp();
  FlutterNativeSplash.remove();

  runApp(const SolarSystem());
}

class SolarSystem extends StatelessWidget {
  const SolarSystem({super.key});

  @override
  Widget build(BuildContext context) {
    return Watch((context) {
      final error = appError.value;
      if (error != null) {
        return MaterialApp(
          home: Scaffold(body: Center(child: Text('Error: $error'))),
        );
      }

      if (appLoading.value) {
        return MaterialApp(
          home: Scaffold(
            backgroundColor: AppColors.backgroundDark,
            body: Center(
              child: CircularProgressIndicator(
                color: AppColors.emeraldPrimary,
              ),
            ),
          ),
        );
      }

      final dark = darkMode.value;
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light(useMaterial3: true).copyWith(
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.emeraldPrimary,
            brightness: Brightness.light,
            primary: AppColors.emeraldPrimary,
            secondary: AppColors.solarGold,
            tertiary: AppColors.electricCyan,
            error: AppColors.coralRed,
          ),
          scaffoldBackgroundColor: const Color(0xFFF8FAFC),
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.white.withValues(alpha: 0.95),
            elevation: 0,
            scrolledUnderElevation: 1,
          ),
          navigationBarTheme: NavigationBarThemeData(
            backgroundColor: Colors.white,
            indicatorColor: AppColors.emeraldPrimary.withValues(alpha: 0.15),
            elevation: 2,
          ),
        ),
        darkTheme: ThemeData.dark(useMaterial3: true).copyWith(
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.emeraldPrimary,
            brightness: Brightness.dark,
            surface: AppColors.backgroundDarkSecondary,
            onSurface: Colors.white,
            surfaceContainer: AppColors.cardDark,
            surfaceContainerLow: AppColors.backgroundDarkSecondary,
            surfaceContainerHighest: const Color(0xFF2D3449),
            primary: AppColors.emeraldGreen,
            primaryContainer: AppColors.emeraldPrimary,
            secondary: AppColors.solarAmber,
            secondaryContainer: AppColors.solarGoldDark,
            tertiary: AppColors.cyanLight,
            tertiaryContainer: AppColors.cyanAccent,
            error: AppColors.coralRed,
            outline: const Color(0xFF86948A),
            outlineVariant: const Color(0xFF3C4A42),
          ),
          scaffoldBackgroundColor: AppColors.backgroundDark,
          appBarTheme: AppBarTheme(
            backgroundColor: AppColors.backgroundDark.withValues(alpha: 0.95),
            elevation: 0,
            scrolledUnderElevation: 0,
          ),
          navigationBarTheme: NavigationBarThemeData(
            backgroundColor: AppColors.backgroundDarkSecondary.withValues(
              alpha: 0.95,
            ),
            indicatorColor: AppColors.emeraldPrimary.withValues(alpha: 0.25),
            elevation: 0,
          ),
        ),
        themeMode: dark ? ThemeMode.dark : ThemeMode.light,
        home: const MainApp(),
      );
    });
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: GameScreen(),
    );
  }
}
