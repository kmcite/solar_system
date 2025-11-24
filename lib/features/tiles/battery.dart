import 'dart:async';
import 'package:flutter/material.dart';
import 'package:manager/manager.dart';
import '../../domain/entities/battery.dart';
import '../../domain/entities/power_balance.dart';
import '../../domain/entities/solar_flow.dart';
import '../../domain/entities/inverter.dart';
import '../../domain/entities/panels.dart';
import '../../domain/entities/home_device.dart';
import '../../domain/entities/settings.dart';
import '../../domain/repositories/battery_repository.dart';
import '../../domain/repositories/flow_repository.dart';
import '../../domain/repositories/inverter_repository.dart';
import '../../domain/repositories/panels_repository.dart';
import '../../domain/repositories/home_repository.dart';
import '../../domain/repositories/settings_repository.dart';
import '../common/base_tile.dart';

/// Provider that manages battery state and power management
class BatteryProvider extends ChangeNotifier {
  late final _batteryRepository = find<IBatteryRepository>();
  late final _flowRepository = find<IFlowRepository>();
  late final _inverterRepository = find<IInverterRepository>();
  late final _panelsRepository = find<IPanelsRepository>();
  late final _homeRepository = find<IHomeRepository>();
  late final _settingsRepository = find<ISettingsRepository>();

  Battery _battery = Battery(id: 'main_battery');
  bool _isLoading = false;
  String? _error;

  // Power management state (moved from service)
  bool _isManaging = false;
  Timer? _powerManagementTimer;
  PowerBalance? _currentPowerBalance;

  BatteryProvider() {
    _loadBattery();
    _listenToBatteryChanges();
    _initializePowerManagement();
  }

  /// Initialize power management system
  void _initializePowerManagement() {
    // Listen to changes in flow and inverter mode using streams
    _flowRepository.watch().listen((_) => _onFlowOrInverterChanged());
    _inverterRepository.watch().listen(
      (_) => _onFlowOrInverterChanged(),
    );

    // Initial power management setup
    _updatePowerManagement();
  }

  void _onFlowOrInverterChanged() {
    _updatePowerManagement();
  }

  Future<void> _updatePowerManagement() async {
    final flow = await _flowRepository.getFlow();
    final inverter = await _inverterRepository.getInverter();

    if (flow.isActive && inverter.isSolarMode) {
      startPowerManagement();
    } else {
      stopPowerManagement();
    }
  }

  // Getters
  Battery get battery => _battery;
  bool get isLoading => _isLoading;
  String? get error => _error;
  double get stateOfCharge => _battery.stateOfCharge;
  double get voltage => _battery.voltage;
  double get current => _battery.current;
  bool get isCharging => _isManaging; // Changed from _powerService.isManaging
  PowerBalance? get powerBalance => _currentPowerBalance;
  bool get isFullyCharged => _battery.isFullyCharged;
  bool get isEmpty => _battery.isEmpty;

  /// Load battery from repository
  Future<void> _loadBattery() async {
    _setLoading(true);
    try {
      _battery = await _batteryRepository.getBattery();
      _clearError();
    } catch (e) {
      _setError('Failed to load battery: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Update battery state
  Future<void> updateBattery(Battery battery) async {
    try {
      _setLoading(true);
      await _batteryRepository.updateBattery(battery);
      _clearError();
    } catch (e) {
      _setError('Failed to update battery: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Refresh battery state
  Future<void> refreshBattery() => _loadBattery();

  /// Reset battery to default state
  Future<void> resetBattery() async {
    try {
      _setLoading(true);
      await _batteryRepository.resetBattery();
      _clearError();
    } catch (e) {
      _setError('Failed to reset battery: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Listen to battery changes
  void _listenToBatteryChanges() {
    _batteryRepository.watch().listen(_onBatteryChanged);
  }

  /// Handle battery changes
  void _onBatteryChanged(Battery _) {
    updateBattery(battery);
  }

  /// Set loading state
  void _setLoading(bool loading) {
    if (_isLoading != loading) {
      _isLoading = loading;
      notifyListeners();
    }
  }

  /// Set error state
  void _setError(String error) {
    if (_error != error) {
      _error = error;
      notifyListeners();
    }
  }

  /// Clear error state
  void _clearError() {
    if (_error != null) {
      _error = null;
      notifyListeners();
    }
  }

  // Power Management Methods (integrated from service layer)

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
      final battery = await _batteryRepository.getBattery();
      final inverter = await _inverterRepository.getInverter();
      final flow = await _flowRepository.getFlow();
      final panels = await _panelsRepository.getPanels();
      final homeDevices = await _homeRepository.getHomeDevices();
      final settings = await _settingsRepository.getSettings();

      // Check if power management should be active
      if (!_shouldManagePower(flow, inverter, settings)) {
        return;
      }

      // Calculate power balance
      final powerBalance = await _calculatePowerBalance(
        panels,
        homeDevices,
        inverter,
        battery,
      );
      _currentPowerBalance = powerBalance;

      // Update battery based on power balance
      if (powerBalance.shouldChargeBattery ||
          powerBalance.shouldDischargeBattery) {
        final updatedBattery = _calculateBatteryState(battery, powerBalance);
        await _batteryRepository.updateBattery(updatedBattery);
        await _loadBattery(); // Refresh local state
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Error in power management: $e');
    }
  }

  /// Calculate power balance
  Future<PowerBalance> _calculatePowerBalance(
    Panels panels,
    HomeDevices homeDevices,
    Inverter inverter,
    Battery battery,
  ) async {
    final generation = panels.totalOutput;
    final consumption = homeDevices.totalConsumption;
    final netPower = generation - consumption;

    return PowerBalance(
      generation: generation,
      consumption: consumption,
      netPower: netPower,
      batteryCurrent: netPower / battery.voltage,
      shouldChargeBattery: netPower > 0 && !battery.isFullyCharged,
      shouldDischargeBattery: netPower < 0 && !battery.isEmpty,
    );
  }

  /// Check if power management should be active
  bool _shouldManagePower(
    SolarFlow flow,
    Inverter inverter,
    AppSettings settings,
  ) {
    return flow.isActive &&
        inverter.isSolarMode &&
        settings.autoPowerManagement;
  }

  /// Calculate battery state after power flow
  Battery _calculateBatteryState(
    Battery currentBattery,
    PowerBalance powerBalance,
  ) {
    if (powerBalance.shouldChargeBattery) {
      final chargeAdded = powerBalance.batteryCurrent * 1; // 1 second
      final newCharge = (currentBattery.charge + chargeAdded).clamp(
        0.0,
        currentBattery.capacity,
      );

      return currentBattery.copyWith(charge: newCharge);
    } else if (powerBalance.shouldDischargeBattery) {
      final chargeRemoved = (powerBalance.batteryCurrent * 1).abs();
      final newCharge = (currentBattery.charge - chargeRemoved).clamp(
        0.0,
        currentBattery.capacity,
      );

      return currentBattery.copyWith(charge: newCharge);
    }

    return currentBattery;
  }

  /// Get current power balance
  Future<PowerBalance?> getCurrentPowerBalance() async {
    try {
      final panels = await _panelsRepository.getPanels();
      final homeDevices = await _homeRepository.getHomeDevices();
      final inverter = await _inverterRepository.getInverter();
      final battery = await _batteryRepository.getBattery();

      return await _calculatePowerBalance(
        panels,
        homeDevices,
        inverter,
        battery,
      );
    } catch (e) {
      debugPrint('Error getting power balance: $e');
      return null;
    }
  }

  @override
  void dispose() {
    stopPowerManagement(); // Stop power management timer
    super.dispose();
  }
}

/// View for displaying battery tile
class BatteryView extends StatelessWidget {
  const BatteryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Feature(
      created: () => BatteryProvider(),
      builder: (_, batteryProvider) {
        if (batteryProvider.isLoading) {
          return BaseTile(
            title: 'Battery',
            icon: Icons.battery_full,
            iconColor: Colors.blue,
            children: const [
              CircularProgressIndicator(),
            ],
          );
        }

        if (batteryProvider.error != null) {
          return BaseTile(
            title: 'Battery',
            icon: Icons.battery_alert,
            iconColor: Colors.red,
            children: [
              Text('Error loading battery'),
              Text(batteryProvider.error!),
            ],
          );
        }

        final soc =
            batteryProvider.stateOfCharge /
            100.0; // Convert percentage to fraction

        return BaseTile(
          title: 'Battery',
          icon: batteryProvider.isCharging
              ? Icons.battery_charging_full
              : Icons.battery_full,
          iconColor: batteryProvider.isCharging ? Colors.green : Colors.blue,
          action: batteryProvider.isCharging
              ? const Icon(Icons.arrow_downward, color: Colors.green, size: 16)
              : null,
          children: [
            Text('SOC: ${batteryProvider.stateOfCharge.toStringAsFixed(0)}%'),
            Text('Voltage: ${batteryProvider.voltage.toStringAsFixed(1)}V'),
            Text('Current: ${batteryProvider.current.toStringAsFixed(2)}A'),
            if (batteryProvider.isCharging)
              const Text(
                'Charging',
                style: TextStyle(color: Colors.green),
              ),
            Container(
              height: 12,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Colors.grey[300],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: soc,
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    batteryProvider.isCharging ? Colors.green : Colors.blue,
                  ),
                  minHeight: 12,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
