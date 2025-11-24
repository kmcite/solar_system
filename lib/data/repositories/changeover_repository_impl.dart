import 'package:flutter/material.dart';
import '../../domain/entities/changeover.dart';
import '../../domain/repositories/changeover_repository_interface.dart';

/// Implementation of ChangeoverRepository using in-memory storage
class ChangeoverRepositoryImpl extends ChangeNotifier
    implements ChangeoverRepositoryInterface {
  Changeover _changeover = Changeover(id: 'main_changeover');
  final List<Changeover> _history = [];

  @override
  Future<Changeover> getChangeover() async {
    return _changeover;
  }

  @override
  Future<void> updateChangeover(Changeover changeover) async {
    _changeover = changeover.copyWith(lastUpdated: DateTime.now());
    _addToHistory(_changeover);
    notifyListeners();
  }

  @override
  Stream<Changeover> watchChangeover() {
    return Stream.fromIterable([
      _changeover,
    ]).asyncMap((_) async => _changeover);
  }

  @override
  Future<void> switchToState(ChangeoverState state) async {
    if (_changeover.currentState != state) {
      final updatedChangeover = _changeover.switchTo(state);
      await updateChangeover(updatedChangeover);
    }
  }

  @override
  Future<void> toggleAutoMode() async {
    final updatedChangeover = _changeover.copyWith(
      isAutoMode: !_changeover.isAutoMode,
      lastUpdated: DateTime.now(),
    );
    await updateChangeover(updatedChangeover);
  }

  @override
  Future<List<Changeover>> getChangeoverHistory({
    DateTime? startTime,
    DateTime? endTime,
    int? limit,
  }) async {
    var filteredHistory = _history;

    if (startTime != null) {
      filteredHistory = filteredHistory
          .where(
            (changeover) => changeover.lastUpdated?.isAfter(startTime) ?? false,
          )
          .toList();
    }

    if (endTime != null) {
      filteredHistory = filteredHistory
          .where(
            (changeover) => changeover.lastUpdated?.isBefore(endTime) ?? false,
          )
          .toList();
    }

    if (limit != null && limit > 0) {
      filteredHistory = filteredHistory.take(limit).toList();
    }

    return filteredHistory.reversed.toList(); // Most recent first
  }

  @override
  Future<void> resetChangeover() async {
    _changeover = Changeover(id: 'main_changeover');
    _addToHistory(_changeover);
    notifyListeners();
  }

  // Convenience getters for backward compatibility
  Changeover get changeover => _changeover;
  ChangeoverState get currentSource => _changeover.currentState;
  bool get isAutoMode => _changeover.isAutoMode;
  bool get isUtilitySource => _changeover.isOnUtility;
  bool get isSolarSource => _changeover.isOnSolar;
  bool get isBatterySource => _changeover.isOnBackup;

  /// Enable/disable automatic mode
  void setAutomaticMode(bool enabled) {
    final updatedChangeover = _changeover.copyWith(
      isAutoMode: enabled,
      lastUpdated: DateTime.now(),
    );
    updateChangeover(updatedChangeover);
  }

  void _addToHistory(Changeover changeover) {
    _history.add(changeover);

    // Keep only last 1000 entries to prevent memory issues
    if (_history.length > 1000) {
      _history.removeRange(0, _history.length - 1000);
    }
  }
}
