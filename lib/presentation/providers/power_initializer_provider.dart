import 'package:flutter/material.dart';
import '../../domain/services/power_management_service.dart';
import '../../data/repositories/flow_repository_impl.dart';
import '../../data/repositories/inverter_repository_impl.dart';

/// Provider that initializes and manages the power management system
class PowerInitializerProvider extends ChangeNotifier {
  final PowerManagementService _powerManagementService;
  final FlowRepositoryImpl _flowRepo;
  final InverterRepositoryImpl _inverterRepo;
  bool _isInitialized = false;

  PowerInitializerProvider({
    required PowerManagementService powerManagementService,
    required FlowRepositoryImpl flowRepo,
    required InverterRepositoryImpl inverterRepo,
  }) : _powerManagementService = powerManagementService,
       _flowRepo = flowRepo,
       _inverterRepo = inverterRepo;

  /// Initialize the power management system
  void initialize() {
    if (_isInitialized) return;

    _isInitialized = true;

    // Start power management when conditions are met
    _updatePowerManagement();

    // Listen to changes in flow and inverter mode
    _flowRepo.addListener(_onFlowOrInverterChanged);
    _inverterRepo.addListener(_onFlowOrInverterChanged);
  }

  void _onFlowOrInverterChanged() {
    _updatePowerManagement();
  }

  void _updatePowerManagement() {
    final flow = _flowRepo.flow;
    final inverter = _inverterRepo.inverter;

    if (flow.isActive && inverter.isSolarMode) {
      _powerManagementService.startPowerManagement();
    } else {
      _powerManagementService.stopPowerManagement();
    }
  }

  /// Dispose the provider and clean up resources
  @override
  void dispose() {
    if (!_isInitialized) return;

    // Clean up listeners
    _flowRepo.removeListener(_onFlowOrInverterChanged);
    _inverterRepo.removeListener(_onFlowOrInverterChanged);

    // Stop power management
    _powerManagementService.stopPowerManagement();

    _isInitialized = false;
    super.dispose();
  }
}
