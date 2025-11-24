import '../entities/changeover.dart';

/// Repository interface for changeover data access
abstract class ChangeoverRepositoryInterface {
  /// Get current changeover state
  Future<Changeover> getChangeover();

  /// Update changeover state
  Future<void> updateChangeover(Changeover changeover);

  /// Stream changeover state changes
  Stream<Changeover> watchChangeover();

  /// Switch to specific state
  Future<void> switchToState(ChangeoverState state);

  /// Toggle auto mode
  Future<void> toggleAutoMode();

  /// Get changeover history
  Future<List<Changeover>> getChangeoverHistory({
    DateTime? startTime,
    DateTime? endTime,
    int? limit,
  });

  /// Reset changeover to default state
  Future<void> resetChangeover();
}
