import '../entities/battery.dart';

/// Repository interface for battery data access
abstract class BatteryRepositoryInterface {
  /// Get current battery state
  Future<Battery> getBattery();

  /// Update battery state
  Future<void> updateBattery(Battery battery);

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
