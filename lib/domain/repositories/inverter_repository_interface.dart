import '../entities/inverter.dart';

/// Repository interface for inverter data access
abstract class InverterRepositoryInterface {
  /// Get current inverter state
  Future<Inverter> getInverter();

  /// Update inverter state
  Future<void> updateInverter(Inverter inverter);

  /// Stream inverter state changes
  Stream<Inverter> watchInverter();

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
