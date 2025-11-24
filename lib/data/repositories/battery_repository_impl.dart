import 'package:flutter/foundation.dart';
import '../../domain/entities/battery.dart';
import '../../domain/repositories/battery_repository_interface.dart';

/// Implementation of BatteryRepository using in-memory storage
class BatteryRepositoryImpl extends ChangeNotifier
    implements BatteryRepositoryInterface {
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
