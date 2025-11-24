import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';

// Data Layer
import 'package:solar_system/data/repositories/battery_repository_impl.dart';
import 'package:solar_system/data/repositories/flow_repository_impl.dart';
import 'package:solar_system/data/repositories/inverter_repository_impl.dart';
import 'package:solar_system/data/repositories/loads_repository_impl.dart';
import 'package:solar_system/data/repositories/panels_repository_impl.dart';
import 'package:solar_system/data/repositories/utility_repository_impl.dart';
import 'package:solar_system/data/repositories/changeover_repository_impl.dart';
import 'package:solar_system/data/repositories/settings_repository_impl.dart';
import 'package:solar_system/data/repositories/home_repository_impl.dart';

// Domain Layer
import 'package:solar_system/domain/usecases/power_management_usecase.dart';
import 'package:solar_system/domain/usecases/system_monitoring_usecase.dart';
import 'package:solar_system/domain/services/power_management_service.dart';

// Presentation Layer
import 'package:solar_system/presentation/screens/dashboard_screen.dart';
import 'package:solar_system/presentation/screens/home_screen.dart';
import 'package:solar_system/presentation/providers/power_initializer_provider.dart';
import 'package:solar_system/presentation/providers/home_provider.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  runApp(SolarSystemApp());
}

class SolarSystemApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    return MultiProvider(
      providers: [
        // Data Layer - Repository Implementations
        ChangeNotifierProvider<BatteryRepositoryImpl>(
          create: (_) => BatteryRepositoryImpl(),
        ),
        ChangeNotifierProvider<FlowRepositoryImpl>(
          create: (_) => FlowRepositoryImpl(),
        ),
        ChangeNotifierProvider<InverterRepositoryImpl>(
          create: (_) => InverterRepositoryImpl(),
        ),
        ChangeNotifierProvider<LoadsRepositoryImpl>(
          create: (_) => LoadsRepositoryImpl(),
        ),
        ChangeNotifierProvider<PanelsRepositoryImpl>(
          create: (_) => PanelsRepositoryImpl(),
        ),
        ChangeNotifierProvider<UtilityRepositoryImpl>(
          create: (_) => UtilityRepositoryImpl(),
        ),
        ChangeNotifierProvider<ChangeoverRepositoryImpl>(
          create: (_) => ChangeoverRepositoryImpl(),
        ),
        ChangeNotifierProvider<SettingsRepositoryImpl>(
          create: (_) => SettingsRepositoryImpl(),
        ),
        ChangeNotifierProvider<HomeRepositoryImpl>(
          create: (_) => HomeRepositoryImpl(),
        ),

        // Domain Layer - Use Cases
        Provider<PowerManagementUseCase>(
          create: (_) => PowerManagementUseCase(),
        ),
        Provider<SystemMonitoringUseCase>(
          create: (_) => SystemMonitoringUseCase(),
        ),

        // Domain Layer - Services
        ChangeNotifierProvider<PowerManagementService>(
          create: (context) {
            final batteryRepo = context.read<BatteryRepositoryImpl>();
            final flowRepo = context.read<FlowRepositoryImpl>();
            final inverterRepo = context.read<InverterRepositoryImpl>();
            final homeRepo = context.read<HomeRepositoryImpl>();
            final panelsRepo = context.read<PanelsRepositoryImpl>();
            final changeoverRepo = context.read<ChangeoverRepositoryImpl>();
            final utilityRepo = context.read<UtilityRepositoryImpl>();
            final settingsRepo = context.read<SettingsRepositoryImpl>();
            final powerManagementUseCase = context
                .read<PowerManagementUseCase>();

            return PowerManagementService(
              batteryRepo: batteryRepo,
              flowRepo: flowRepo,
              inverterRepo: inverterRepo,
              homeRepo: homeRepo,
              panelsRepo: panelsRepo,
              changeoverRepo: changeoverRepo,
              utilityRepo: utilityRepo,
              settingsRepo: settingsRepo,
              powerManagementUseCase: powerManagementUseCase,
            );
          },
        ),

        // Presentation Layer - Providers
        ChangeNotifierProvider<PowerInitializerProvider>(
          create: (context) {
            final powerManagementService = context
                .read<PowerManagementService>();
            final flowRepo = context.read<FlowRepositoryImpl>();
            final inverterRepo = context.read<InverterRepositoryImpl>();

            return PowerInitializerProvider(
              powerManagementService: powerManagementService,
              flowRepo: flowRepo,
              inverterRepo: inverterRepo,
            );
          },
        ),
        ChangeNotifierProvider<HomeProvider>(
          create: (context) {
            final homeRepo = context.read<HomeRepositoryImpl>();
            final loadsRepo = context.read<LoadsRepositoryImpl>();
            final homeProvider = HomeProvider(homeRepository: homeRepo);

            // Migrate existing loads to home devices
            WidgetsBinding.instance.addPostFrameCallback((_) {
              homeRepo.migrateFromLoads(loadsRepo);
            });

            return homeProvider;
          },
        ),
      ],
      child: Builder(
        builder: (context) {
          final settingsRepo = context.watch<SettingsRepositoryImpl>();
          return MaterialApp(
            navigatorKey: AppNavigator.key,
            debugShowCheckedModeBanner: false,
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            themeMode: settingsRepo.dark ? ThemeMode.dark : ThemeMode.light,
            home: const DashboardScreen(),
            routes: {
              '/home': (context) => const HomeScreen(),
            },
          );
        },
      ),
    );
  }
}

class AppNavigator {
  static final GlobalKey<NavigatorState> key = GlobalKey<NavigatorState>();

  static void back() {
    key.currentState?.pop();
  }

  static Future<T?> push<T>(Widget page) {
    return key.currentState?.push(
          MaterialPageRoute(builder: (context) => page),
        ) ??
        Future.value(null);
  }

  static Future<T?> pushNamed<T>(String routeName) {
    return key.currentState?.pushNamed(routeName) ?? Future.value(null);
  }
}
