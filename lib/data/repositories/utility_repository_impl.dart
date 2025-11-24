import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../domain/entities/utility.dart';
import '../../domain/repositories/utility_repository_interface.dart';

/// Implementation of UtilityRepository using in-memory storage
class UtilityRepositoryImpl extends ChangeNotifier
    implements UtilityRepositoryInterface {
  Utility _utility = Utility(id: 'main_utility');
  final List<Utility> _history = [];
  Timer? _timer;

  @override
  Future<Utility> getUtility() async {
    return _utility;
  }

  @override
  Future<void> updateUtility(Utility utility) async {
    _utility = utility.copyWith(lastUpdated: DateTime.now());
    _addToHistory(_utility);
    notifyListeners();
  }

  @override
  Stream<Utility> watchUtility() {
    return Stream.fromIterable([_utility]).asyncMap((_) async => _utility);
  }

  @override
  Future<void> setOnlineStatus(bool isOnline) async {
    final updatedUtility = _utility.copyWith(
      isOnline: isOnline,
      voltage: isOnline ? 230.0 : 0.0,
      lastUpdated: DateTime.now(),
    );
    await updateUtility(updatedUtility);
  }

  @override
  Future<void> updatePowerFlow({
    double? import,
    double? export,
  }) async {
    final updatedUtility = _utility.copyWith(
      currentImport: import ?? _utility.currentImport,
      currentExport: export ?? _utility.currentExport,
      lastUpdated: DateTime.now(),
    );
    await updateUtility(updatedUtility);
  }

  @override
  Future<List<Utility>> getUtilityHistory({
    DateTime? startTime,
    DateTime? endTime,
    int? limit,
  }) async {
    var filteredHistory = _history;

    if (startTime != null) {
      filteredHistory = filteredHistory
          .where((utility) => utility.lastUpdated?.isAfter(startTime) ?? false)
          .toList();
    }

    if (endTime != null) {
      filteredHistory = filteredHistory
          .where((utility) => utility.lastUpdated?.isBefore(endTime) ?? false)
          .toList();
    }

    if (limit != null && limit > 0) {
      filteredHistory = filteredHistory.take(limit).toList();
    }

    return filteredHistory.reversed.toList(); // Most recent first
  }

  @override
  Future<void> resetUtility() async {
    _timer?.cancel();
    _timer = null;
    _utility = Utility(id: 'main_utility');
    _addToHistory(_utility);
    notifyListeners();
  }

  // Convenience getters for backward compatibility
  Utility get utility => _utility;
  bool get status => _utility.isOnline;
  double get voltage => _utility.voltage;

  void turnOn() {
    setOnlineStatus(true);
  }

  void turnOff() {
    setOnlineStatus(false);
  }

  void toggle() {
    setOnlineStatus(!_utility.isOnline);
  }

  void setStatus(bool newStatus) {
    setOnlineStatus(newStatus);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _addToHistory(Utility utility) {
    _history.add(utility);

    // Keep only last 1000 entries to prevent memory issues
    if (_history.length > 1000) {
      _history.removeRange(0, _history.length - 1000);
    }
  }
}
