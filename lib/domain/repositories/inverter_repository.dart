import '../entities/inverter.dart';
import '../../../utils/repository.dart';

/// Repository interface for inverter data access
abstract class IInverterRepository extends Repository<Inverter> {
  /// Get current inverter state
  Future<Inverter> getInverter();

  /// Update inverter state
  Future<void> updateInverter(Inverter inverter);

  /// Change inverter mode
  Future<void> setMode(InverterMode mode);

  /// Change inverter voltage
  Future<void> setVoltage(InverterVoltage voltage);

  /// Get inverter history
  Future<List<Inverter>> getInverterHistory({
    DateTime? startTime,
    DateTime? endTime,
    int? limit,
  });

  /// Reset inverter to default state
  Future<void> resetInverter();
}

/// Implementation of InverterRepository using in-memory storage
class InverterRepository extends IInverterRepository {
  Inverter _inverter = Inverter(id: 'main_inverter');
  final List<Inverter> _history = [];

  @override
  Future<Inverter> getInverter() async {
    return _inverter;
  }

  @override
  Future<void> updateInverter(Inverter inverter) async {
    _inverter = inverter.copyWith(lastUpdated: DateTime.now());
    _addToHistory(_inverter);
    notify(_inverter);
  }

  @override
  Future<void> setMode(InverterMode mode) async {
    final updatedInverter = _inverter.copyWith(
      mode: mode,
      lastUpdated: DateTime.now(),
    );
    await updateInverter(updatedInverter);
  }

  @override
  Future<void> setVoltage(InverterVoltage voltage) async {
    final updatedInverter = _inverter.copyWith(
      voltage: voltage,
      lastUpdated: DateTime.now(),
    );
    await updateInverter(updatedInverter);
  }

  @override
  Future<List<Inverter>> getInverterHistory({
    DateTime? startTime,
    DateTime? endTime,
    int? limit,
  }) async {
    var filteredHistory = _history;

    if (startTime != null) {
      filteredHistory = filteredHistory
          .where(
            (inverter) => inverter.lastUpdated?.isAfter(startTime) ?? false,
          )
          .toList();
    }

    if (endTime != null) {
      filteredHistory = filteredHistory
          .where((inverter) => inverter.lastUpdated?.isBefore(endTime) ?? false)
          .toList();
    }

    if (limit != null && limit > 0) {
      filteredHistory = filteredHistory.take(limit).toList();
    }

    return filteredHistory.reversed.toList(); // Most recent first
  }

  @override
  Future<void> resetInverter() async {
    _inverter = Inverter(id: 'main_inverter');
    _addToHistory(_inverter);
    notify(_inverter);
  }

  // Convenience getters for backward compatibility
  // Inverter get inverter => _inverter;
  // bool get isSolarMode => _inverter.isSolarMode;
  InverterMode get mode => _inverter.mode;
  InverterVoltage get voltage => _inverter.voltage;
  // double get power => _inverter.isOnline ? 5000.0 : 0.0; // Default max power
  // double get current => _inverter.outputPower / _inverter.voltage.value;

  void _addToHistory(Inverter inverter) {
    _history.add(inverter);

    // Keep only last 1000 entries to prevent memory issues
    if (_history.length > 1000) {
      _history.removeRange(0, _history.length - 1000);
    }
  }
}
