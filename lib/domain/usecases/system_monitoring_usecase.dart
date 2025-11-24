import '../entities/battery.dart';
import '../entities/inverter.dart';
import '../entities/panels.dart';
import '../entities/loads.dart';
import '../entities/utility.dart';
import '../entities/changeover.dart';

/// Use case for monitoring system health and performance
class SystemMonitoringUseCase {
  /// Get overall system health status
  SystemHealth getSystemHealth({
    required Battery battery,
    required Inverter inverter,
    required Panels panels,
    required Loads loads,
    required Utility utility,
    required Changeover changeover,
  }) {
    final issues = <SystemIssue>[];

    // Check battery health
    if (battery.stateOfCharge < 10) {
      issues.add(SystemIssue.batteryCritical);
    } else if (battery.stateOfCharge < 20) {
      issues.add(SystemIssue.batteryLow);
    }

    // Check inverter status
    if (!inverter.isOnline) {
      issues.add(SystemIssue.inverterOffline);
    }

    // Check panel performance
    if (panels.activeCount == 0) {
      issues.add(SystemIssue.noActivePanels);
    } else if (panels.efficiency < 50) {
      issues.add(SystemIssue.lowPanelEfficiency);
    }

    // Check utility status
    if (changeover.isOnUtility && !utility.isOnline) {
      issues.add(SystemIssue.utilityOffline);
    }

    // Determine overall health
    final health = issues.isEmpty
        ? SystemHealthStatus.healthy
        : issues.any((issue) => issue.severity == IssueSeverity.critical)
        ? SystemHealthStatus.critical
        : SystemHealthStatus.warning;

    return SystemHealth(
      status: health,
      issues: issues,
      lastChecked: DateTime.now(),
    );
  }

  /// Get system performance metrics
  SystemPerformance getSystemPerformance({
    required Panels panels,
    required Loads loads,
    required Battery battery,
  }) {
    return SystemPerformance(
      totalGeneration: panels.totalOutput,
      totalConsumption: loads.totalConsumption,
      batteryEfficiency: battery.stateOfCharge,
      panelEfficiency: panels.efficiency,
      averageLoadPerActiveLoad: loads.averageConsumption,
      activePanels: panels.activeCount,
      activeLoads: loads.activeCount,
      timestamp: DateTime.now(),
    );
  }

  /// Check if system needs maintenance
  bool needsMaintenance({
    required Panels panels,
    required Battery battery,
    required Inverter inverter,
  }) {
    // Low panel efficiency might indicate cleaning needed
    if (panels.efficiency < 60) return true;

    // Battery degradation check (simplified)
    if (battery.stateOfCharge < 5 && battery.current < 1.0) return true;

    // Inverter performance issues
    if (!inverter.isOperational) return true;

    return false;
  }

  /// Get recommendations for system optimization
  List<SystemRecommendation> getRecommendations({
    required SystemHealth health,
    required SystemPerformance performance,
  }) {
    final recommendations = <SystemRecommendation>[];

    // Battery recommendations
    if (health.issues.contains(SystemIssue.batteryLow)) {
      recommendations.add(SystemRecommendation.chargeBattery);
    }

    // Panel recommendations
    if (health.issues.contains(SystemIssue.lowPanelEfficiency)) {
      recommendations.add(SystemRecommendation.cleanPanels);
    }

    // Load management
    if (performance.totalConsumption > performance.totalGeneration) {
      recommendations.add(SystemRecommendation.reduceLoad);
    }

    return recommendations;
  }
}

/// System health status
enum SystemHealthStatus {
  healthy,
  warning,
  critical;

  String get displayName {
    switch (this) {
      case SystemHealthStatus.healthy:
        return 'Healthy';
      case SystemHealthStatus.warning:
        return 'Warning';
      case SystemHealthStatus.critical:
        return 'Critical';
    }
  }
}

/// System issue types
enum SystemIssue {
  batteryLow(IssueSeverity.warning),
  batteryCritical(IssueSeverity.critical),
  inverterOffline(IssueSeverity.critical),
  noActivePanels(IssueSeverity.warning),
  lowPanelEfficiency(IssueSeverity.warning),
  utilityOffline(IssueSeverity.critical);

  const SystemIssue(this.severity);
  final IssueSeverity severity;

  String get description {
    switch (this) {
      case SystemIssue.batteryLow:
        return 'Battery charge is low';
      case SystemIssue.batteryCritical:
        return 'Battery charge is critically low';
      case SystemIssue.inverterOffline:
        return 'Inverter is offline';
      case SystemIssue.noActivePanels:
        return 'No active solar panels';
      case SystemIssue.lowPanelEfficiency:
        return 'Solar panel efficiency is low';
      case SystemIssue.utilityOffline:
        return 'Utility power is offline';
    }
  }
}

/// Issue severity levels
enum IssueSeverity { warning, critical }

/// System health information
class SystemHealth {
  final SystemHealthStatus status;
  final List<SystemIssue> issues;
  final DateTime lastChecked;

  const SystemHealth({
    required this.status,
    required this.issues,
    required this.lastChecked,
  });

  bool get hasIssues => issues.isNotEmpty;
  bool get hasCriticalIssues =>
      issues.any((issue) => issue.severity == IssueSeverity.critical);
}

/// System performance metrics
class SystemPerformance {
  final double totalGeneration;
  final double totalConsumption;
  final double batteryEfficiency;
  final double panelEfficiency;
  final double averageLoadPerActiveLoad;
  final int activePanels;
  final int activeLoads;
  final DateTime timestamp;

  const SystemPerformance({
    required this.totalGeneration,
    required this.totalConsumption,
    required this.batteryEfficiency,
    required this.panelEfficiency,
    required this.averageLoadPerActiveLoad,
    required this.activePanels,
    required this.activeLoads,
    required this.timestamp,
  });

  /// Net power balance
  double get netBalance => totalGeneration - totalConsumption;

  /// System efficiency
  double get systemEfficiency =>
      totalGeneration > 0 ? (totalConsumption / totalGeneration) * 100 : 0.0;
}

/// System recommendations
enum SystemRecommendation {
  chargeBattery,
  cleanPanels,
  reduceLoad,
  scheduleMaintenance;

  String get description {
    switch (this) {
      case SystemRecommendation.chargeBattery:
        return 'Charge battery to optimal level';
      case SystemRecommendation.cleanPanels:
        return 'Clean solar panels to improve efficiency';
      case SystemRecommendation.reduceLoad:
        return 'Reduce power consumption to match generation';
      case SystemRecommendation.scheduleMaintenance:
        return 'Schedule system maintenance';
    }
  }
}
