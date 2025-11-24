import '../entities/flow.dart';

/// Repository interface for flow data access
abstract class FlowRepositoryInterface {
  /// Get current flow state
  Future<Flow> getFlow();

  /// Update flow state
  Future<void> updateFlow(Flow flow);

  /// Stream flow state changes
  Stream<Flow> watchFlow();

  /// Start flow
  Future<void> startFlow();

  /// Stop flow
  Future<void> stopFlow();

  /// Get flow history
  Future<List<Flow>> getFlowHistory({
    DateTime? startTime,
    DateTime? endTime,
    int? limit,
  });

  /// Reset flow to default state
  Future<void> resetFlow();
}
