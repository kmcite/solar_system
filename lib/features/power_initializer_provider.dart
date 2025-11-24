import 'package:flutter/material.dart';
import 'package:manager/manager.dart';
import '../domain/repositories/flow_repository.dart';
import '../domain/repositories/inverter_repository.dart';
import '../domain/repositories/battery_repository.dart';

/// Provider that initializes and manages the power management system
class PowerInitializerProvider extends ChangeNotifier {
  late final IFlowRepository _flowRepo;
  late final IInverterRepository _inverterRepo;
  late final IBatteryRepository _batteryRepo;
  bool _isInitialized = false;
  bool _isPowerManagementActive = false;

  PowerInitializerProvider() {
    _flowRepo = find<IFlowRepository>();
    _inverterRepo = find<IInverterRepository>();
    _batteryRepo = find<IBatteryRepository>();
  }

  /// Initialize the power management system
  void initialize() {
    if (_isInitialized) return;

    _isInitialized = true;

    // Start power management when conditions are met
    _updatePowerManagement();

    // Listen to changes in flow and inverter mode using streams
    _flowRepo.watchFlow().listen((_) => _onFlowOrInverterChanged());
    _inverterRepo.watchInverter().listen((_) => _onFlowOrInverterChanged());
  }

  void _onFlowOrInverterChanged() {
    _updatePowerManagement();
  }

  void _updatePowerManagement() async {
    final flow = await _flowRepo.getFlow();
    final inverter = await _inverterRepo.getInverter();

    if (flow.isActive && inverter.isSolarMode) {
      _startPowerManagement();
    } else {
      _stopPowerManagement();
    }
  }

  void _startPowerManagement() async {
    if (_isPowerManagementActive) return;

    _isPowerManagementActive = true;

    // Update battery last updated timestamp to indicate power management change
    final battery = await _batteryRepo.getBattery();
    final updatedBattery = battery.copyWith(
      lastUpdated: DateTime.now(),
    );

    await _batteryRepo.updateBattery(updatedBattery);
    notifyListeners();
  }

  void _stopPowerManagement() async {
    if (!_isPowerManagementActive) return;

    _isPowerManagementActive = false;

    // Update battery last updated timestamp to indicate power management change
    final battery = await _batteryRepo.getBattery();
    final updatedBattery = battery.copyWith(
      lastUpdated: DateTime.now(),
    );

    await _batteryRepo.updateBattery(updatedBattery);
    notifyListeners();
  }

  /// Get current power management status
  bool get isPowerManagementActive => _isPowerManagementActive;

  /// Dispose the provider and clean up resources
  @override
  void dispose() {
    if (!_isInitialized) return;

    // Stop power management
    _stopPowerManagement();

    _isInitialized = false;
    super.dispose();
  }
}
