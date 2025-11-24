import 'dart:async';
import 'package:flutter/foundation.dart';
import '../usecases/power_management_usecase.dart';
import '../entities/loads.dart';
import '../entities/home_device.dart';
import '../repositories/battery_repository.dart';
import '../repositories/flow_repository.dart';
import '../repositories/inverter_repository.dart';
import '../repositories/home_repository.dart';
import '../repositories/panels_repository.dart';
import '../repositories/changeover_repository.dart';
import '../repositories/utility_repository.dart';
import '../repositories/settings_repository.dart';

/// Service that manages power flow between solar panels, loads, and battery
/// Handles excess power by charging the battery when output > load
class PowerManagementService extends ChangeNotifier {
  final IBatteryRepository _batteryRepo;
  final IFlowRepository _flowRepo;
  final IInverterRepository _inverterRepo;
  final IHomeRepository _homeRepo;
  final IPanelsRepository _panelsRepo;
  final IChangeoverRepository _changeoverRepo;
  final PowerManagementUseCase _powerManagementUseCase;
  final ISettingsRepository _settingsRepo;
  final IUtilityRepository _utilityRepo;

  Timer? _powerManagementTimer;
  bool _isManaging = false;

  PowerManagementService({
    required IBatteryRepository batteryRepo,
    required IFlowRepository flowRepo,
    required IInverterRepository inverterRepo,
    required IHomeRepository homeRepo,
    required IPanelsRepository panelsRepo,
    required IChangeoverRepository changeoverRepo,
    required PowerManagementUseCase powerManagementUseCase,
    required ISettingsRepository settingsRepo,
    required IUtilityRepository utilityRepo,
  }) : _batteryRepo = batteryRepo,
       _flowRepo = flowRepo,
       _inverterRepo = inverterRepo,
       _homeRepo = homeRepo,
       _panelsRepo = panelsRepo,
       _changeoverRepo = changeoverRepo,
       _powerManagementUseCase = powerManagementUseCase,
       _settingsRepo = settingsRepo,
       _utilityRepo = utilityRepo;

  bool get isManaging => _isManaging;

  /// Start power management when conditions are met
  void startPowerManagement() {
    if (_isManaging) return;

    _isManaging = true;
    _powerManagementTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => _managePower(),
    );
    notifyListeners();
  }

  /// Stop power management
  void stopPowerManagement() {
    if (!_isManaging) return;

    _powerManagementTimer?.cancel();
    _powerManagementTimer = null;
    _isManaging = false;
    notifyListeners();
  }

  /// Main power management logic
  Future<void> _managePower() async {
    try {
      // Get current system state
      final battery = await _batteryRepo.getBattery();
      final inverter = await _inverterRepo.getInverter();
      final flow = await _flowRepo.getFlow();
      final panels = await _panelsRepo.getPanels();
      final homeDevices = await _homeRepo.getHomeDevices();
      final changeover = await _changeoverRepo.getChangeover();

      // Check if power management should be active
      final settings = await _settingsRepo.getSettings();
      if (!_powerManagementUseCase.shouldManagePower(
        flow: flow,
        inverter: inverter,
        settings: settings,
      )) {
        return;
      }

      // Convert home devices to loads for compatibility with existing use case
      final loads = _homeDevicesToLoads(homeDevices);

      // Calculate power balance
      final powerBalance = _powerManagementUseCase.calculatePowerBalance(
        panels: panels,
        loads: loads,
        inverter: inverter,
        battery: battery,
      );

      // Update battery based on power balance
      if (powerBalance.shouldChargeBattery ||
          powerBalance.shouldDischargeBattery) {
        final updatedBattery = _powerManagementUseCase.calculateBatteryState(
          battery,
          powerBalance,
          const Duration(seconds: 1),
        );
        await _batteryRepo.updateBattery(updatedBattery);
      }

      // Determine optimal changeover state
      final utility = await _utilityRepo.getUtility();
      final optimalState = _powerManagementUseCase
          .determineOptimalChangeoverState(
            flow: flow,
            inverter: inverter,
            battery: battery,
            utility: utility,
            settings: settings,
          );

      // Update changeover if needed
      if (changeover.currentState != optimalState) {
        await _changeoverRepo.switchToState(optimalState);
      }
    } catch (e) {
      debugPrint('Error in power management: $e');
    }
  }

  /// Get current power balance
  Future<PowerBalance?> getCurrentPowerBalance() async {
    try {
      final panels = await _panelsRepo.getPanels();
      final homeDevices = await _homeRepo.getHomeDevices();
      final inverter = await _inverterRepo.getInverter();
      final battery = await _batteryRepo.getBattery();

      // Convert home devices to loads for compatibility
      final loads = _homeDevicesToLoads(homeDevices);

      return _powerManagementUseCase.calculatePowerBalance(
        panels: panels,
        loads: loads,
        inverter: inverter,
        battery: battery,
      );
    } catch (e) {
      debugPrint('Error getting power balance: $e');
      return null;
    }
  }

  /// Convert home devices to loads for compatibility with existing use case
  Loads _homeDevicesToLoads(HomeDevices homeDevices) {
    final loads = homeDevices.devices
        .map(
          (device) => Load(
            id: device.id,
            name: device.name,
            powerConsumption: device.powerConsumption,
            isActive: device.isActive,
            lastUpdated: device.lastUpdated,
          ),
        )
        .toList();

    return Loads(loads: loads, lastUpdated: homeDevices.lastUpdated);
  }

  @override
  void dispose() {
    stopPowerManagement();
    super.dispose();
  }
}
