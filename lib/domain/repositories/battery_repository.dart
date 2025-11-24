import 'package:flutter/foundation.dart';
import '../entities/battery.dart';
import '../entities/power_balance.dart';

/// Repository interface for battery data access
abstract class IBatteryRepository {
  /// Get current battery state
  Future<Battery> getBattery();

  /// Update battery state
  Future<void> updateBattery(Battery battery);

  /// Get current power balance
  Future<PowerBalance> getCurrentPowerBalance();

  /// Stream battery state changes
  Stream<Battery> watchBattery();

  /// Get battery history
  Future<List<Battery>> getBatteryHistory({
    DateTime? startTime,
    DateTime? endTime,
    int? limit,
  });

  /// Reset battery to default state
  Future<void> resetBattery();
}

/// Implementation of BatteryRepository using in-memory storage
class BatteryRepository extends ChangeNotifier implements IBatteryRepository {
  Battery _battery = Battery(id: 'main_battery');
  final List<Battery> _history = [];

  @override
  Future<Battery> getBattery() async {
    return _battery;
  }

  @override
  Future<void> updateBattery(Battery battery) async {
    _battery = battery.copyWith(lastUpdated: DateTime.now());
    _addToHistory(_battery);
    notifyListeners();
  }

  @override
  Future<PowerBalance> getCurrentPowerBalance() async {
    // This would need access to other repositories for full calculation
    // For now, return a basic calculation with current battery data
    return PowerBalance(
      generation: 0.0,
      consumption: 0.0,
      netPower: 0.0,
      batteryCurrent: 0.0,
      shouldChargeBattery: false,
      shouldDischargeBattery: false,
    );
  }

  @override
  Stream<Battery> watchBattery() {
    return Stream.fromIterable([_battery]).asyncMap((_) async => _battery);
  }

  @override
  Future<List<Battery>> getBatteryHistory({
    DateTime? startTime,
    DateTime? endTime,
    int? limit,
  }) async {
    var filteredHistory = _history;

    if (startTime != null) {
      filteredHistory = filteredHistory
          .where((battery) => battery.lastUpdated?.isAfter(startTime) ?? false)
          .toList();
    }

    if (endTime != null) {
      filteredHistory = filteredHistory
          .where((battery) => battery.lastUpdated?.isBefore(endTime) ?? false)
          .toList();
    }

    if (limit != null && limit > 0) {
      filteredHistory = filteredHistory.take(limit).toList();
    }

    return filteredHistory.reversed.toList(); // Most recent first
  }

  @override
  Future<void> resetBattery() async {
    _battery = Battery(id: 'main_battery');
    _addToHistory(_battery);
    notifyListeners();
  }

  // Convenience getters for backward compatibility
  Battery get battery => _battery;
  double get stateOfCharge => _battery.stateOfCharge;

  void _addToHistory(Battery battery) {
    _history.add(battery);

    // Keep only last 1000 entries to prevent memory issues
    if (_history.length > 1000) {
      _history.removeRange(0, _history.length - 1000);
    }
  }
}
