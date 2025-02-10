export 'package:flutter/material.dart';
export 'package:solar_system/system/battery/battery_bloc.dart';
export 'package:solar_system/system/inverter/inverter_bloc.dart';
export 'package:solar_system/system/panel/panel_bloc.dart';
import 'package:forui/forui.dart';
import 'package:manager/manager.dart';

import 'system/system_page.dart';
export 'dart:convert';
export 'package:flutter/foundation.dart';
export 'package:freezed_annotation/freezed_annotation.dart';
export 'package:solar_system/system/utility/utility.dart';
export 'package:uuid/uuid.dart';
export 'system/load/loads.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await RM.storageInitializer(HiveStorage());
  runApp(App());
}

class App extends UI {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigator.navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Monaspace Krypton',
      ),
      builder: (context, child) => FTheme(
        data: FThemes.yellow.dark,
        child: child!,
      ),
      home: SystemPage(),
    );
  }
}

final navigator = RM.navigate;

class Button extends UI {
  const Button({
    super.key,
    this.onPressed,
    this.child,
  });
  final Widget? child;
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return FButton(
      onPress: onPressed,
      label: child ?? SizedBox(),
    );
  }

  const Button.icon({
    required void Function()? onPressed,
    required Widget icon,
  })  : onPressed = onPressed,
        child = icon;
}
