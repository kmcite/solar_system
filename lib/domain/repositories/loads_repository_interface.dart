import '../entities/loads.dart';

/// Repository interface for loads data access
abstract class LoadsRepositoryInterface {
  /// Get current loads state
  Future<Loads> getLoads();

  /// Update loads state
  Future<void> updateLoads(Loads loads);

  /// Stream loads state changes
  Stream<Loads> watchLoads();

  /// Update individual load
  Future<void> updateLoad(Load load);

  /// Add new load
  Future<void> addLoad(Load load);

  /// Remove load
  Future<void> removeLoad(String loadId);

  /// Toggle load state
  Future<void> toggleLoad(String loadId);

  /// Get loads history
  Future<List<Loads>> getLoadsHistory({
    DateTime? startTime,
    DateTime? endTime,
    int? limit,
  });

  /// Reset loads to default state
  Future<void> resetLoads();
}
