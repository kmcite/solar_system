// ignore_for_file: deprecated_member_use

import 'dart:developer';

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
import 'package:solar_system/features/dashboard/appBar/flow_toggle.dart';
import 'package:solar_system/features/dashboard/dashboard.dart';
import 'package:solar_system/features/dashboard/inverter/flow_bar.dart';
import 'package:solar_system/utils/bloc/bloc.dart';
import 'package:solar_system/utils/bloc/bloc_observer.dart';
import 'package:solar_system/utils/bloc/change.dart';
import 'package:solar_system/utils/bloc/cubit.dart';

import 'domain/flow_repository.dart';
import 'main.dart';
import 'objectbox.g.dart';

export 'dart:convert';

export 'package:flutter/foundation.dart';
export 'package:flutter/material.dart' hide Builder, State;
export 'package:forui/forui.dart';
export 'package:solar_system/utils/navigator.dart';
export 'package:solar_system/utils/persist_repository.dart';
export 'package:solar_system/utils/repository.dart';
export 'package:solar_system/utils/state.dart';
export 'package:solar_system/utils/locator.dart';

export 'package:uuid/uuid.dart';

void main() async {
  Bloc.observer = LogBlocs();
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  final appInfo = await PackageInfo.fromPlatform();
  final path = await getApplicationDocumentsDirectory();
  final store = await openStore(directory: join(path.path, appInfo.appName));
  await Hive.initFlutter();
  final hive = await Hive.openBox(appInfo.appName);
  service(store);
  service(hive);

  repository(BatteryRepository());
  repository(FlowRepository());
  repository(InverterRepository());
  repository(LoadsRepository());
  repository(PanelsRepository());
  repository(SettingsRepository());
  repository(UtilityRepository());

  runApp(Application());
}

class ApplicationBloc extends Cubit<bool> {
  late SettingsRepository settingsRepository = find();
  ApplicationBloc() : super(false) {}

  @override
  Future<void> initState() {
    FlutterNativeSplash.remove();
    settingsRepository.stream.listen(
      (settings) => emit(settings.dark),
    );
    emit(settingsRepository().dark);
    return super.initState();
  }
}

class Application extends Feature<ApplicationBloc> {
  const Application({super.key});
  @override
  ApplicationBloc create() => ApplicationBloc();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigator.navigatorKey,
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

class LogBlocs extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    if (bloc is FlowToggleBloc || bloc is FlowBarBloc) return;
    log(
      '${change.nextState}',
      name: bloc.runtimeType.toString(),
    );
  }
}
