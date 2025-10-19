import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:solar_system/domain/battery_repository.dart';
import 'package:solar_system/domain/inverter_repository.dart';
import 'package:solar_system/domain/loads_repository.dart';
import 'package:solar_system/domain/panels_repository.dart';
import 'package:solar_system/domain/settings_repository.dart';
import 'package:solar_system/domain/utility_repository.dart';
import 'package:solar_system/features/dashboard/dashboard.dart';
import 'package:solar_system/main.dart';
export 'package:spark/spark.dart';
export 'package:solar_system/utils/navigator.dart';

import 'domain/flow_repository.dart';
import 'objectbox.g.dart';

export 'dart:convert';

export 'package:flutter/foundation.dart';
export 'package:flutter/material.dart' hide Builder, State;
export 'package:forui/forui.dart';
export 'package:uuid/uuid.dart';

void main() async {
  // Bloc.observer = LogBlocs();
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(SolarSystem());
}

class SolarSystemApp extends Application {
  @override
  Widget buildApp(BuildContext context) => SolarSystem();

  @override
  Future<void> init() async {
    final appInfo = await PackageInfo.fromPlatform();
    final path = await getApplicationDocumentsDirectory();
    final store = await openStore(directory: join(path.path, appInfo.appName));
    await Hive.initFlutter();
    final hive = await Hive.openBox(appInfo.appName);
    putService(store);
    putService(hive);

    putRepository(SettingsRepository());
    putRepository(BatteryRepository());
    putRepository(FlowRepository());
    putRepository(InverterRepository());
    putRepository(LoadsRepository());
    putRepository(PanelsRepository());
    putRepository(UtilityRepository());
  }
}

class SolarSystemBloc extends Cubit<bool> {
  late SettingsRepository settingsRepository = find();
  SolarSystemBloc() : super(false) {}

  @override
  Future<void> initState() {
    FlutterNativeSplash.remove();
    settingsRepository.stream.listen(
      (settings) => emit(settings.dark),
    );
    emit(settingsRepository.state.dark);
    return super.initState();
  }
}

class SolarSystem extends Feature<SolarSystemBloc> {
  const SolarSystem({super.key});
  @override
  SolarSystemBloc create() => SolarSystemBloc();
  @override
  Widget build(BuildContext context, controller) {
    return MaterialApp(
      navigatorKey: navigator.key,
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        progressIndicatorTheme: ProgressIndicatorThemeData(year2023: false),
      ),
      darkTheme: ThemeData.dark().copyWith(
        progressIndicatorTheme: ProgressIndicatorThemeData(year2023: false),
      ),
      themeMode: controller() ? ThemeMode.dark : ThemeMode.light,
      home: DashboardView(),
      builder: (context, child) {
        return FTheme(
          data: controller() ? FThemes.blue.dark : FThemes.green.light,
          child: child!,
        );
      },
    );
  }
}
