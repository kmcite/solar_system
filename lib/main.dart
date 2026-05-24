import 'package:flutter/material.dart';
import 'package:signals/signals.dart';

import 'package:solar_system/business/app.dart';
import 'package:solar_system/business/dark.dart';
import 'package:solar_system/business/navigator.dart';
import 'package:solar_system/screens/game_screen.dart';
import 'package:solar_system/utils/builder.dart';

void main() async {
  SignalsObserver.instance = null;
  runApp(
    listenTo(
      [index, dark],
      (context) {
        final darkState = dark.value;
        return MaterialApp(
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          theme: .light(),
          darkTheme: .dark(),
          themeMode: darkState ? ThemeMode.dark : ThemeMode.light,
          home: gameScreen(),
        );
      },
    ),
  );
}
  // // Start timer-based services
  // startRadiation();
  // startBatteryDischarge();
  // startRevenue();

  // // Wire inter-signal effects (radiation -> panels, radiation -> battery)
  // effect(() {
  //   setPanelRadiation(radiation.value);
  // });

  // effect(() {
  //   updateBatteryRadiation(radiation.value);
  // });

  // // Battery upgrade effect - when currentBatteryUpgrade changes, apply to battery
  // effect(() {
  //   final upgrade = currentBatteryUpgrade.value;
  //   applyBatteryUpgrade(
  //     newMaxCapacity: upgrade.capacityWh,
  //     newVoltage: upgrade.voltage,
  //     newTierName: upgrade.name,
  //     newChargeMultiplier: upgrade.chargeMultiplier,
  //     newEfficiency: upgrade.efficiency,
  //   );
  // });

