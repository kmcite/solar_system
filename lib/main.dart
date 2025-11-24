import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:manager/manager.dart';
import 'package:solar_system/domain/repositories/settings_repository.dart';

// Core
import 'package:solar_system/utils/app_config.dart';
import 'package:solar_system/utils/dependency_injection.dart';
import 'package:solar_system/utils/router.dart';

// Data Layer

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Configure dependencies
  await configureDependencies();

  runApp(SolarSystemApp());
}

class SolarSystemProvider extends ChangeNotifier {
  late final ISettingsRepository _settingsRepository = find();
  SolarSystemProvider() {
    _settingsRepository.watch().listen(
      (settings) {
        darkMode = settings.darkMode;
        notifyListeners();
      },
    );
  }

  bool darkMode = false;
}

class SolarSystemApp extends StatelessWidget {
  const SolarSystemApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Feature(
      created: () => SolarSystemProvider(),
      builder: (_, solarSystem) {
        FlutterNativeSplash.remove();
        return MaterialApp.router(
          routerConfig: AppRouter.router,
          debugShowCheckedModeBanner: false,
          title: appConfig.appName,
          theme: appConfig.lightTheme,
          darkTheme: appConfig.darkTheme,
          themeMode: solarSystem.darkMode ? ThemeMode.dark : ThemeMode.light,
        );
      },
    );
  }
}
