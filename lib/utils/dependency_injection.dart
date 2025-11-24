import 'package:manager/manager.dart';
import 'package:solar_system/domain/repositories/battery_repository.dart';
import 'package:solar_system/domain/repositories/changeover_repository.dart';
import 'package:solar_system/domain/repositories/flow_repository.dart';
import 'package:solar_system/domain/repositories/home_repository.dart';
import 'package:solar_system/domain/repositories/inverter_repository.dart';
import 'package:solar_system/domain/repositories/loads_repository.dart';
import 'package:solar_system/domain/repositories/panels_repository.dart';
import 'package:solar_system/domain/repositories/settings_repository.dart';
import 'package:solar_system/domain/repositories/utility_repository.dart';

Future<void> configureDependencies() async {
  /// inject services

  /// inject repositories
  put<IFlowRepository>(FlowRepository());
  put<IHomeRepository>(HomeRepository());
  put<IBatteryRepository>(BatteryRepository());
  put<IInverterRepository>(InverterRepository());
  put<ILoadsRepository>(LoadsRepository());
  put<IPanelsRepository>(PanelsRepository());
  put<ISettingsRepository>(SettingsRepository());
  put<IChangeoverRepository>(ChangeoverRepository());
  put<IUtilityRepository>(UtilityRepository());
}
