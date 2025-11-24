import '../entities/loads.dart';
import '../../../utils/repository.dart';

/// Repository interface for loads data access
abstract class ILoadsRepository extends Repository<Loads> {
  /// Get current loads state
  Future<Loads> getLoads();

  /// Update loads state
  Future<void> updateLoads(Loads loads);

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

/// Implementation of LoadsRepository using in-memory storage
class LoadsRepository extends ILoadsRepository {
  Loads _loads = _createSampleLoads();
  final List<Loads> _history = [];

  @override
  Future<Loads> getLoads() async {
    return _loads;
  }

  @override
  Future<void> updateLoads(Loads loads) async {
    _loads = loads.copyWith(lastUpdated: DateTime.now());
    _addToHistory(_loads);
    notify(_loads);
  }

  @override
  Future<void> updateLoad(Load load) async {
    final updatedLoads = _loads.copyWith(
      loads: _loads.loads.map((l) => l.id == load.id ? load : l).toList(),
      lastUpdated: DateTime.now(),
    );
    await updateLoads(updatedLoads);
  }

  @override
  Future<void> addLoad(Load load) async {
    final updatedLoads = _loads.copyWith(
      loads: [..._loads.loads, load],
      lastUpdated: DateTime.now(),
    );
    await updateLoads(updatedLoads);
  }

  @override
  Future<void> removeLoad(String loadId) async {
    final updatedLoads = _loads.copyWith(
      loads: _loads.loads.where((load) => load.id != loadId).toList(),
      lastUpdated: DateTime.now(),
    );
    await updateLoads(updatedLoads);
  }

  @override
  Future<void> toggleLoad(String loadId) async {
    final targetLoad = _loads.loads.firstWhere((load) => load.id == loadId);
    final updatedLoad = targetLoad.copyWith(
      isActive: !targetLoad.isActive,
      lastUpdated: DateTime.now(),
    );
    await updateLoad(updatedLoad);
  }

  @override
  Future<List<Loads>> getLoadsHistory({
    DateTime? startTime,
    DateTime? endTime,
    int? limit,
  }) async {
    var filteredHistory = _history;

    if (startTime != null) {
      filteredHistory = filteredHistory
          .where((loads) => loads.lastUpdated?.isAfter(startTime) ?? false)
          .toList();
    }

    if (endTime != null) {
      filteredHistory = filteredHistory
          .where((loads) => loads.lastUpdated?.isBefore(endTime) ?? false)
          .toList();
    }

    if (limit != null && limit > 0) {
      filteredHistory = filteredHistory.take(limit).toList();
    }

    return filteredHistory.reversed.toList(); // Most recent first
  }

  @override
  Future<void> resetLoads() async {
    _loads = Loads();
    _addToHistory(_loads);
    notify(_loads);
  }

  // Convenience getters for backward compatibility
  List<Load> get loads => _loads.loads;
  double get totalConsumption => _loads.totalConsumption;

  void _addToHistory(Loads loads) {
    _history.add(loads);

    // Keep only last 1000 entries to prevent memory issues
    if (_history.length > 1000) {
      _history.removeRange(0, _history.length - 1000);
    }
  }

  /// Create sample loads for demonstration
  static Loads _createSampleLoads() {
    return Loads(
      loads: [
        Load(
          id: 'load_1',
          name: 'Refrigerator',
          powerConsumption: 150.0, // 150W
          isActive: true,
        ),
        Load(
          id: 'load_2',
          name: 'Lights',
          powerConsumption: 100.0, // 100W
          isActive: true,
        ),
        Load(
          id: 'load_3',
          name: 'TV',
          powerConsumption: 200.0, // 200W
          isActive: false, // Turned off
        ),
        Load(
          id: 'load_4',
          name: 'Air Conditioner',
          powerConsumption: 800.0, // 800W
          isActive: false, // Turned off to save power
        ),
      ],
      lastUpdated: DateTime.now(),
    );
  }
}
