import 'package:flutter/material.dart';
import 'package:signals/signals.dart';

// =============================================================================
// DATA MODEL
// =============================================================================
/// Represents a battery upgrade tier with specific performance characteristics.
class BatteryUpgrade {
  final String id;
  final String name;
  final double voltage; // Operating voltage in volts
  final double capacityWh; // Energy capacity in watt-hours
  final double efficiency; // Charge/discharge efficiency (0.0 - 1.0)
  final double chargeMultiplier; // Charging speed multiplier (1.0 = base speed)
  final int cost; // Cost in currency units
  final String? requires; // ID of prerequisite upgrade
  final Color color; // Visual indicator color
  final String description; // Brief description of the battery type

  const BatteryUpgrade({
    required this.id,
    required this.name,
    required this.voltage,
    required this.capacityWh,
    required this.efficiency,
    required this.chargeMultiplier,
    required this.cost,
    this.requires,
    this.color = Colors.grey,
    this.description = '',
  });

  /// Returns true if this is the starting battery (cost = 0)
  bool get isStarter => cost == 0;

  /// Returns true if this upgrade has a prerequisite
  bool get hasRequirement => requires != null;

  /// Calculates the cost per Wh of capacity
  double get costPerWh => capacityWh > 0 ? cost / capacityWh : 0.0;

  /// Returns a formatted string of voltage
  String get voltageLabel => '${voltage.toStringAsFixed(0)}V';

  /// Returns a formatted string of capacity
  String get capacityLabel => '${capacityWh.toStringAsFixed(1)} Wh';

  /// Returns efficiency as percentage
  String get efficiencyPercent => '${(efficiency * 100).toStringAsFixed(0)}%';

  /// Returns charge multiplier as percentage
  String get chargeSpeedPercent =>
      '${((chargeMultiplier - 1) * 100).toStringAsFixed(0)}%';

  @override
  String toString() =>
      'BatteryUpgrade($id: $name, ${voltageLabel}, ${capacityLabel})';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BatteryUpgrade &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  BatteryUpgrade copyWith({
    String? id,
    String? name,
    double? voltage,
    double? capacityWh,
    double? efficiency,
    double? chargeMultiplier,
    int? cost,
    String? requires,
  }) => BatteryUpgrade(
    id: id ?? this.id,
    name: name ?? this.name,
    voltage: voltage ?? this.voltage,
    capacityWh: capacityWh ?? this.capacityWh,
    efficiency: efficiency ?? this.efficiency,
    chargeMultiplier: chargeMultiplier ?? this.chargeMultiplier,
    cost: cost ?? this.cost,
    requires: requires ?? this.requires,
  );
}

// =============================================================================
// UPGRADE TREE (CONSTANT)
// =============================================================================
/// Complete battery upgrade progression from basic lead-acid to advanced LiFePO4.
/// Features 12 tiers total: 5 in 12V, 4 in 24V, and 3 in 48V configurations.
const batteryUpgradeTree = <String, BatteryUpgrade>{
  'bat_lead_acid': BatteryUpgrade(
    id: 'bat_lead_acid',
    name: 'Lead-Acid',
    voltage: 12.0,
    capacityWh: 1.0,
    efficiency: 0.85,
    chargeMultiplier: 1.0,
    cost: 0, // starting battery
    color: Colors.brown,
    description:
        'Basic lead-acid battery. Reliable but limited capacity and efficiency.',
  ),
  'bat_enhanced_lead': BatteryUpgrade(
    id: 'bat_enhanced_lead',
    name: 'Enhanced Lead-Acid',
    voltage: 12.0,
    capacityWh: 2.0,
    efficiency: 0.88,
    chargeMultiplier: 1.2,
    cost: 2000,
    requires: 'bat_lead_acid',
    color: Colors.orange,
    description:
        'Improved lead-acid design with better capacity and charging speed.',
  ),
  'bat_deep_cycle': BatteryUpgrade(
    id: 'bat_deep_cycle',
    name: 'Deep Cycle',
    voltage: 12.0,
    capacityWh: 3.5,
    efficiency: 0.90,
    chargeMultiplier: 1.4,
    cost: 3500,
    requires: 'bat_enhanced_lead',
    color: Colors.deepOrange,
    description:
        'Deep cycle lead-acid. Designed for repeated discharge cycles.',
  ),
  'bat_gel_cell': BatteryUpgrade(
    id: 'bat_gel_cell',
    name: 'Gel Cell',
    voltage: 12.0,
    capacityWh: 4.5,
    efficiency: 0.91,
    chargeMultiplier: 1.6,
    cost: 4500,
    requires: 'bat_deep_cycle',
    color: Colors.amber,
    description:
        'Gel electrolyte battery. Maintenance-free with good deep discharge recovery.',
  ),
  'bat_agm': BatteryUpgrade(
    id: 'bat_agm',
    name: 'AGM',
    voltage: 24.0,
    capacityWh: 5.0,
    efficiency: 0.92,
    chargeMultiplier: 1.5,
    cost: 5000,
    requires: 'bat_gel_cell',
    color: Colors.blue,
    description:
        'Absorbent Glass Mat technology. Superior performance and longevity.',
  ),
  'bat_agm_pro': BatteryUpgrade(
    id: 'bat_agm_pro',
    name: 'AGM Pro',
    voltage: 24.0,
    capacityWh: 7.0,
    efficiency: 0.93,
    chargeMultiplier: 1.7,
    cost: 7500,
    requires: 'bat_agm',
    color: Colors.lightBlue,
    description:
        'Professional-grade AGM. Enhanced power density and cycle life.',
  ),
  'bat_carbon_foam': BatteryUpgrade(
    id: 'bat_carbon_foam',
    name: 'Carbon Foam',
    voltage: 24.0,
    capacityWh: 8.5,
    efficiency: 0.94,
    chargeMultiplier: 1.8,
    cost: 9500,
    requires: 'bat_agm_pro',
    color: Colors.teal,
    description:
        'Advanced carbon foam electrodes. Ultra-fast charging and extended lifespan.',
  ),
  'bat_lithium': BatteryUpgrade(
    id: 'bat_lithium',
    name: 'Lithium-Ion',
    voltage: 48.0,
    capacityWh: 10.0,
    efficiency: 0.96,
    chargeMultiplier: 2.0,
    cost: 12000,
    requires: 'bat_carbon_foam',
    color: Colors.green,
    description:
        'Modern lithium-ion cells. High energy density and fast charging.',
  ),
  'bat_nmc': BatteryUpgrade(
    id: 'bat_nmc',
    name: 'NMC Lithium',
    voltage: 48.0,
    capacityWh: 14.0,
    efficiency: 0.97,
    chargeMultiplier: 2.2,
    cost: 18000,
    requires: 'bat_lithium',
    color: Colors.lightGreen,
    description:
        'Nickel Manganese Cobalt chemistry. Superior energy density and stability.',
  ),
  'bat_solid_state': BatteryUpgrade(
    id: 'bat_solid_state',
    name: 'Solid-State',
    voltage: 48.0,
    capacityWh: 17.0,
    efficiency: 0.975,
    chargeMultiplier: 2.3,
    cost: 22000,
    requires: 'bat_nmc',
    color: Colors.cyan,
    description:
        'Next-gen solid-state technology. Maximum safety and energy density.',
  ),
  'bat_lifepo4': BatteryUpgrade(
    id: 'bat_lifepo4',
    name: 'LiFePO4',
    voltage: 48.0,
    capacityWh: 20.0,
    efficiency: 0.98,
    chargeMultiplier: 2.5,
    cost: 25000,
    requires: 'bat_solid_state',
    color: Colors.purple,
    description:
        'Lithium Iron Phosphate. Ultimate safety, cycle life, and performance.',
  ),
};

// =============================================================================
// COMPUTED HELPERS
// =============================================================================
/// Returns all upgrades in progression order (sorted by prerequisite chain)
final orderedUpgrades = computed<List<BatteryUpgrade>>(() {
  final result = <BatteryUpgrade>[];
  BatteryUpgrade? current = batteryUpgradeTree.values.firstWhere(
    (u) => u.isStarter,
  );

  while (current != null) {
    result.add(current);
    current = nextUpgradeFrom(current.id);
  }

  return result;
});

/// Returns the next upgrade from a given upgrade ID
BatteryUpgrade? nextUpgradeFrom(String upgradeId) {
  try {
    return batteryUpgradeTree.values.firstWhere(
      (u) => u.requires == upgradeId,
    );
  } catch (_) {
    return null;
  }
}

/// Returns all available upgrades (already purchased or purchasable)
final availableUpgrades = computed<List<BatteryUpgrade>>(() {
  final current = currentBatteryUpgrade.value;
  final result = [current];

  var next = nextUpgradeFrom(current.id);
  while (next != null) {
    result.add(next);
    next = nextUpgradeFrom(next.id);
  }

  return result;
});

/// Checks if a specific upgrade can be purchased
bool canPurchaseUpgrade(String upgradeId) {
  final upgrade = batteryUpgradeTree[upgradeId];
  if (upgrade == null) return false;
  return upgrade.requires == currentBatteryUpgrade.value.id;
}

/// Returns the upgrade path from current to target (inclusive)
List<BatteryUpgrade> getUpgradePathTo(String targetId) {
  final path = <BatteryUpgrade>[];
  final target = batteryUpgradeTree[targetId];
  if (target == null) return path;

  // Build path from current to target
  var current = currentBatteryUpgrade.value;
  path.add(current);

  while (current.id != targetId) {
    final next = nextUpgradeFrom(current.id);
    if (next == null) break;
    path.add(next);
    current = next;
  }

  return path;
}

// =============================================================================
// STATE
// =============================================================================
/// Currently installed battery upgrade
final currentBatteryUpgrade = signal<BatteryUpgrade>(
  batteryUpgradeTree['bat_lead_acid']!,
);

// =============================================================================
// COMPUTED
// =============================================================================
/// Computes the next available upgrade in the tree
final nextBatteryUpgrade = computed<BatteryUpgrade?>(() {
  try {
    return batteryUpgradeTree.values.firstWhere(
      (u) => u.requires == currentBatteryUpgrade.value.id,
    );
  } catch (_) {
    return null;
  }
});

/// Computes the progress in the upgrade tree (0.0 to 1.0)
final upgradeProgress = computed<double>(() {
  final ordered = orderedUpgrades.value;
  final currentIndex = ordered.indexWhere(
    (u) => u.id == currentBatteryUpgrade.value.id,
  );
  return ordered.isNotEmpty ? (currentIndex + 1) / ordered.length : 0.0;
});

/// Computes total investment in battery upgrades
final totalInvestment = computed<int>(() {
  final ordered = orderedUpgrades.value;
  final currentIndex = ordered.indexWhere(
    (u) => u.id == currentBatteryUpgrade.value.id,
  );
  int total = 0;
  for (int i = 0; i <= currentIndex && i < ordered.length; i++) {
    total += ordered[i].cost;
  }
  return total;
});

// =============================================================================
// ACTIONS
// =============================================================================
/// Attempts to purchase and install the specified battery upgrade.
/// Returns true if successful, false otherwise.
bool purchaseBatteryUpgrade(String id) {
  final next = batteryUpgradeTree[id];
  if (next == null) return false;
  if (next.requires != currentBatteryUpgrade.value.id) return false;

  currentBatteryUpgrade.value = next;
  return true;
}

/// Resets the battery system to the starter upgrade
void resetBatterySystem() {
  final starter = batteryUpgradeTree.values.firstWhere((u) => u.isStarter);
  currentBatteryUpgrade.value = starter;
}

/// Validates if an upgrade path is valid (sequential)
bool isValidUpgradePath(List<String> upgradeIds) {
  if (upgradeIds.isEmpty) return false;

  for (int i = 1; i < upgradeIds.length; i++) {
    final prev = batteryUpgradeTree[upgradeIds[i - 1]];
    final curr = batteryUpgradeTree[upgradeIds[i]];
    if (prev == null || curr == null) return false;
    if (curr.requires != prev.id) return false;
  }

  return true;
}
