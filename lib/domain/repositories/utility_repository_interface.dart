import '../entities/utility.dart';

/// Repository interface for utility data access
abstract class UtilityRepositoryInterface {
  /// Get current utility state
  Future<Utility> getUtility();

  /// Update utility state
  Future<void> updateUtility(Utility utility);

  /// Stream utility state changes
  Stream<Utility> watchUtility();

  /// Set utility online status
  Future<void> setOnlineStatus(bool isOnline);

  /// Update power flow
  Future<void> updatePowerFlow({
    double? import,
    double? export,
  });

  /// Get utility history
  Future<List<Utility>> getUtilityHistory({
    DateTime? startTime,
    DateTime? endTime,
    int? limit,
  });

  /// Reset utility to default state
  Future<void> resetUtility();
}
