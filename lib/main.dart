import 'package:flutter/cupertino.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:signals_flutter/signals_flutter.dart';

import 'package:solar_system/business/app.dart';
import 'package:solar_system/business/battery.dart';
import 'package:solar_system/business/battery_upgrades.dart';
import 'package:solar_system/business/radiation.dart';
import 'package:solar_system/business/panels.dart';
import 'package:solar_system/business/revenue.dart';
import 'package:solar_system/screens/game_screen.dart';
import 'package:solar_system/utils/signal_observer.dart';
import 'package:solar_system/utils/ui_helpers.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  SignalsObserver.instance = SignalObserver();

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

  runApp(const SolarSystemApp());
}

class SolarSystemApp extends StatelessWidget {
  const SolarSystemApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Watch((context) {
      final error = appError.value;
      if (error != null) {
        return _buildErrorApp(error);
      }

      if (appLoading.value) {
        return _buildLoadingApp();
      }

      return _buildMainApp();
    });
  }

  CupertinoApp _buildErrorApp(String error) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      home: CupertinoPageScaffold(
        backgroundColor: CupertinoColors.systemRed.withValues(alpha: 0.1),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  CupertinoIcons.exclamationmark_triangle,
                  size: 48,
                  color: CupertinoColors.systemRed,
                ),
                const SizedBox(height: 16),
                Text(
                  'Error',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: CupertinoColors.systemRed,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  error,
                  style: const TextStyle(
                    fontSize: 16,
                    color: CupertinoColors.label,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  CupertinoApp _buildLoadingApp() {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      home: CupertinoPageScaffold(
        backgroundColor: AppColors.iosDarkBackground,
        child: const SafeArea(
          child: Center(
            child: CupertinoActivityIndicator(radius: 20),
          ),
        ),
      ),
    );
  }

  CupertinoApp _buildMainApp() {
    final dark = darkMode.value;
    final brightness = dark ? Brightness.dark : Brightness.light;

    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      theme: CupertinoThemeData(
        brightness: brightness,
        primaryColor: AppColors.iosBlue,
        primaryContrastingColor: dark
            ? CupertinoColors.white
            : CupertinoColors.black,
        scaffoldBackgroundColor: dark
            ? AppColors.iosDarkBackground
            : AppColors.iosLightBackground,
        barBackgroundColor: dark
            ? AppColors.iosDarkBackground
            : AppColors.iosLightBackground,
        textTheme: CupertinoTextThemeData(
          textStyle: TextStyle(
            fontFamily: '.SF Pro Text',
            fontSize: 17,
            color: dark ? AppColors.iosDarkText : AppColors.iosLightText,
          ),
          navLargeTitleTextStyle: const TextStyle(
            fontFamily: '.SF Pro Display',
            fontSize: 34,
            fontWeight: FontWeight.bold,
          ),
          navTitleTextStyle: const TextStyle(
            fontFamily: '.SF Pro Text',
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
          actionTextStyle: TextStyle(
            fontFamily: '.SF Pro Text',
            fontSize: 17,
            color: AppColors.iosBlue,
          ),
          tabLabelTextStyle: const TextStyle(
            fontFamily: '.SF Pro Text',
            fontSize: 10,
          ),
        ),
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      child: GameScreen(),
    );
  }
}
