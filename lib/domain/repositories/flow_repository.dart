import 'dart:async';
import 'package:faker/faker.dart';
import '../entities/solar_flow.dart';
import '../../../utils/repository.dart';

/// Repository interface for flow data access
abstract class IFlowRepository extends Repository<SolarFlow> {
  /// Get current flow state
  Future<SolarFlow> getFlow();

  /// Update flow state
  Future<void> updateFlow(SolarFlow flow);

  /// Start flow
  Future<void> startFlow();

  /// Stop flow
  Future<void> stopFlow();

  /// Get flow history
  Future<List<SolarFlow>> getFlowHistory({
    DateTime? startTime,
    DateTime? endTime,
    int? limit,
  });

  /// Reset flow to default state
  Future<void> resetFlow();
}

/// Implementation of FlowRepository using in-memory storage
class FlowRepository extends IFlowRepository {
  SolarFlow _flow = SolarFlow(id: 'main_flow');
  final List<SolarFlow> _history = [];
  Timer? _timer;

  @override
  Future<SolarFlow> getFlow() async {
    return _flow;
  }

  @override
  Future<void> updateFlow(SolarFlow flow) async {
    _flow = flow.copyWith(lastUpdated: DateTime.now());
    _addToHistory(_flow);
    notify(_flow);
  }

  @override
  Future<void> startFlow() async {
    if (_timer != null) return;

    _timer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      final faker = Faker();
      final updatedFlow = _flow.copyWith(
        currentFlow: faker.randomGenerator.decimal(scale: 1000),
        lastUpdated: DateTime.now(),
      );
      await updateFlow(updatedFlow);
    });
  }

  @override
  Future<void> stopFlow() async {
    _timer?.cancel();
    _timer = null;
    final stoppedFlow = _flow.copyWith(
      currentFlow: 0.0,
      lastUpdated: DateTime.now(),
    );
    await updateFlow(stoppedFlow);
  }

  @override
  Future<List<SolarFlow>> getFlowHistory({
    DateTime? startTime,
    DateTime? endTime,
    int? limit,
  }) async {
    var filteredHistory = _history;

    if (startTime != null) {
      filteredHistory = filteredHistory
          .where((flow) => flow.lastUpdated?.isAfter(startTime) ?? false)
          .toList();
    }

    if (endTime != null) {
      filteredHistory = filteredHistory
          .where((flow) => flow.lastUpdated?.isBefore(endTime) ?? false)
          .toList();
    }

    if (limit != null && limit > 0) {
      filteredHistory = filteredHistory.take(limit).toList();
    }

    return filteredHistory.reversed.toList(); // Most recent first
  }

  @override
  Future<void> resetFlow() async {
    _timer?.cancel();
    _timer = null;
    _flow = SolarFlow(id: 'main_flow');
    _addToHistory(_flow);
    notify(_flow);
  }

  // Convenience getters for backward compatibility
  SolarFlow get flow => _flow;
  double get currentFlow => _flow.currentFlow;

  void _addToHistory(SolarFlow flow) {
    _history.add(flow);

    // Keep only last 1000 entries to prevent memory issues
    if (_history.length > 1000) {
      _history.removeRange(0, _history.length - 1000);
    }
  }
}
