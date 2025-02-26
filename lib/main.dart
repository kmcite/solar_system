export 'package:flutter/material.dart';
export 'package:solar_system/system/battery/battery_repository.dart';
export 'package:solar_system/system/inverter/inverter_repository.dart';
export 'package:solar_system/system/panel/panel_bloc.dart';
export 'package:forui/forui.dart';
export 'package:manager/manager.dart';
export 'package:solar_system/main.dart';
import 'package:solar_system/navigator.dart';
import 'package:solar_system/system/system_page.dart';

import 'main.dart';
export 'dart:convert';
export 'package:flutter/foundation.dart';
export 'package:solar_system/system/utility/utility.dart';
export 'package:uuid/uuid.dart';
export 'system/load/loads.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await RM.storageInitializer(HiveStorage());
  runApp(App());
}

typedef UI = ReactiveStatelessWidget;

class App extends UI {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigator.navigatorKey,
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return FTheme(
          data:
              systemBloc.dark
                  ? FThemes.green.dark
                  : FThemes.yellow.light,
          child: child!,
        );
      },
      home: SystemPage(),
    );
  }
}
