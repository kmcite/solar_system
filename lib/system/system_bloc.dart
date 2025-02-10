import 'dart:math';
import 'package:manager/manager.dart';
import 'package:solar_system/main.dart';

/// SolarSystem class managing energy flow
final SolarSystem solarSystem = SolarSystem();

class SolarSystem {
  /// Battery charge rate
  int get batteryChargeRate => 20;

  /// Total energy flown through the solar system
  final loadedEnergyRM = RM.inject<int>(
    () => 10,
    persist: () => PersistState(key: 'totalEnergy'),
  );

  int get loadedEnergy => loadedEnergyRM.state;

  void _setLoadedEnergy(int value) {
    loadedEnergyRM.state = value.clamp(0, maximumCapacity);
  }

  void decreaseLoadedEnergy(int value) =>
      _setLoadedEnergy(loadedEnergy - value);
  void increaseLoadedEnergy(int value) =>
      _setLoadedEnergy(loadedEnergy + value);

  /// Instantaneous energy flow
  late final energyFlowRM = RM.inject<int>(
    () => 0,
    sideEffects: SideEffects.onData(flowContinues),
  );

  int get energy => energyFlowRM.state;

  void flowContinues(int flow) {
    handleInverterUsage();
    handleBatteryState();
    handlePanels();
    handleUtility();
  }

  void handleInverterUsage() {
    if (inverterBloc.status) {
      decreaseLoadedEnergy(inverterBloc.inverterEnergyUsage);
    }
  }

  void handleBatteryState() {
    if (batteryBloc.battery.isCharging) {
      batteryBloc.charge(batteryChargeRate);
      decreaseLoadedEnergy(batteryChargeRate);
    }
    if (batteryBloc.battery.isPoweringLoads) {
      batteryBloc.discharge(loadsBloc.loads.loads);
    }
  }

  void handlePanels() {
    if (panelsBloc.status) {
      increaseLoadedEnergy(panelsBloc.currentPower);
    }
  }

  void handleUtility() {
    if (utilityBloc.utility.isPoweringLoads) {
      decreaseLoadedEnergy(utilityBloc.utility.energyToPowerLoads);
    }
  }

  /// Stream for simulating energy flow
  final StreamController<int> _energyFlowController =
      StreamController.broadcast();

  void startEnergyFlow() {
    stopEnergyFlow(); // Stop any previous flow before starting a new one
    _energyFlowController.addStream(
      Stream.periodic(
        Duration(seconds: 1),
        (_) => Random().nextInt(maxEnergy),
      ),
    );
  }

  void stopEnergyFlow() {
    _energyFlowController.close();
  }

  Stream<int> get energyFlowStream => _energyFlowController.stream;

  /// Subscription to energy flow stream
  StreamSubscription<int>? flowSubscription;

  void startFlow() {
    stopFlow(); // Ensure no duplicate subscriptions
    flowSubscription = energyFlowStream.listen((flow) {
      energyFlowRM.state = flow;
    });
  }

  void stopFlow() {
    flowSubscription?.cancel();
    flowSubscription = null;
  }

  /// Maximum energy settings
  final maxEnergyRM = RM.inject(() => 10);

  int get maxEnergy => maxEnergyRM.state;
  set maxEnergy(int value) => maxEnergyRM.state = value;

  bool get isFullyLoaded => loadedEnergy >= maximumCapacity;

  int get maximumCapacity => 1000;
}
