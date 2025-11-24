import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:faker/faker.dart';
import '../../domain/entities/flow.dart';
import '../../domain/repositories/flow_repository_interface.dart';

/// Implementation of FlowRepository using in-memory storage
class FlowRepositoryImpl extends ChangeNotifier
    implements FlowRepositoryInterface {
  Flow _flow = Flow(id: 'main_flow');
  final List<Flow> _history = [];
  Timer? _timer;

  @override
  Future<Flow> getFlow() async {
    return _flow;
  }

  @override
  Future<void> updateFlow(Flow flow) async {
    _flow = flow.copyWith(lastUpdated: DateTime.now());
    _addToHistory(_flow);
    notifyListeners();
  }

  @override
  Stream<Flow> watchFlow() {
    return Stream.fromIterable([_flow]).asyncMap((_) async => _flow);
  }

  @override
  Future<void> startFlow() async {
    if (_flow.isActive) return; // Already running

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) {
        final value = faker.randomGenerator.decimal(scale: 0.4, min: 0.6);
        final updatedFlow = _flow.copyWith(
          state: Flowing.running,
          currentFlow: value,
          lastUpdated: DateTime.now(),
        );
        _flow = updatedFlow;
        _addToHistory(_flow);
        notifyListeners();
      },
    );

    final initialFlow = _flow.copyWith(
      state: Flowing.running,
      lastUpdated: DateTime.now(),
    );
    await updateFlow(initialFlow);
  }

  @override
  Future<void> stopFlow() async {
    _timer?.cancel();
    _timer = null;

    final stoppedFlow = _flow.copyWith(
      state: Flowing.stopped,
      currentFlow: 0.0,
      lastUpdated: DateTime.now(),
    );
    await updateFlow(stoppedFlow);
  }

  @override
  Future<List<Flow>> getFlowHistory({
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
    _flow = Flow(id: 'main_flow');
    _addToHistory(_flow);
    notifyListeners();
  }

  // Convenience getters for backward compatibility
  Flow get flow => _flow;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _addToHistory(Flow flow) {
    _history.add(flow);

    // Keep only last 1000 entries to prevent memory issues
    if (_history.length > 1000) {
      _history.removeRange(0, _history.length - 1000);
    }
  }
}
