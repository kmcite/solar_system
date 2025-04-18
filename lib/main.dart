export 'package:flutter/material.dart';
export 'package:forui/forui.dart';
// export 'package:manager/manager.dart';
import 'package:solar_system/domain/apis/dark_repository.dart';
import 'package:solar_system/domain/apis/flow_repository.dart';
import 'package:solar_system/domain/apis/panels_repository.dart';
import 'package:solar_system/domain/apis/utility_repository.dart';
import 'package:solar_system/domain/models/battery.dart';
import 'package:solar_system/domain/models/inverter.dart';
import 'package:solar_system/navigator.dart';
import 'package:solar_system/objectbox.g.dart';
import 'package:solar_system/features/home/home_page.dart';
export 'package:states_rebuilder/states_rebuilder.dart';

import 'domain/apis/loads_repository.dart';
import 'main.dart';
export 'dart:convert';
export 'package:flutter/foundation.dart';
export 'package:uuid/uuid.dart';

void main() async {
  await openStore(directory: 'solar_system');
  runApp(App());
}

mixin AppBloc {
  bool get dark => darkRepository.dark;
}

class App extends GUI with AppBloc {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigator.navigatorKey,
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return FTheme(
          data: dark ? FThemes.green.dark : FThemes.yellow.light,
          child: child!,
        );
      },
      theme: ThemeData(
        fontFamily: 'Cascadia Code',
      ),
      darkTheme: ThemeData(
        fontFamily: 'Cascadia Code',
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.purple,
          brightness: Brightness.dark,
        ),
      ),
      themeMode: dark ? ThemeMode.dark : ThemeMode.light,
      home: HomePage(),
    );
  }
}

abstract class GUI extends StatefulWidget {
  const GUI({super.key});
  List<Listenable> get listenables => [
        darkRepository,
        battery,
        flowRepository,
        inverter,
        loadsRepository,
        panelsRepository,
        utilityRepository,
      ];

  Widget build(BuildContext context);
  @override
  State<StatefulWidget> createState() => _GUI();
}

class _GUI extends State<GUI> {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge(widget.listenables),
      builder: (context, child) => widget.build(context),
    );
  }
}

extension WidgetX on Widget {
  Widget pad({double? right, double? all}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: this,
    );
  }
}

extension AnyX on dynamic {
  Widget text({TextStyle? style}) => Text(toString(), style: style);
}
