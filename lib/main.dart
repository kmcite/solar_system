export 'package:flutter/material.dart';
export 'package:forui/forui.dart';
export 'package:solar_system/utils/navigator.dart';

import 'package:solar_system/v3/home.dart';

import 'main.dart';
import 'v3/colleagues/inverter.dart';
export 'dart:convert';
export 'package:flutter/foundation.dart';
export 'package:uuid/uuid.dart';

void main() async {
  runApp(SolarSystemApp());
}

double get magic => 16.0;

class SolarSystemApp extends UI {
  const SolarSystemApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigator.navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blue,
        ),
        fontFamily: 'Monoid',
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(magic),
          ),
        ),
        dialogTheme: DialogThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(magic),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(magic),
            ),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(magic),
            ),
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(magic),
          ),
        ),
      ),
      darkTheme: ThemeData(
        fontFamily: 'Monoid',
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.purple,
          brightness: Brightness.dark,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(magic),
          ),
        ),
        dialogTheme: DialogThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(magic),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(magic),
            ),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(magic),
            ),
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(magic),
          ),
        ),
      ),
      themeMode: inverter.dark() ? ThemeMode.dark : ThemeMode.light,
      home: HomePage(),
      builder: (context, child) {
        return FTheme(
          data: inverter.dark() ? FThemes.blue.dark : FThemes.green.light,
          child: child!,
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    // appRunner.initState();
  }

  @override
  void dispose() {
    // appRunner.dispose();
    super.dispose();
  }
}
