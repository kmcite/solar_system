import 'package:signals/signals.dart';

// =============================================================================
// DATA MODEL
// =============================================================================
class BatteryUpgrade {
  final String id;
  final String name;
  final double voltage;
  final double capacityWh;
  final double efficiency; // 0.0 - 1.0
  final double chargeMultiplier; // 1.0 = base speed
  final int cost;
  final String? requires; // id of prerequisite upgrade

  const BatteryUpgrade({
    required this.id,
    required this.name,
    required this.voltage,
    required this.capacityWh,
    required this.efficiency,
    required this.chargeMultiplier,
    required this.cost,
    this.requires,
  });

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
const batteryUpgradeTree = <String, BatteryUpgrade>{
  'bat_lead_acid': BatteryUpgrade(
    id: 'bat_lead_acid',
    name: 'Lead-Acid',
    voltage: 12.0,
    capacityWh: 1.0,
    efficiency: 0.85,
    chargeMultiplier: 1.0,
    cost: 0, // starting battery
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
  ),
  'bat_agm': BatteryUpgrade(
    id: 'bat_agm',
    name: 'AGM',
    voltage: 24.0,
    capacityWh: 5.0,
    efficiency: 0.92,
    chargeMultiplier: 1.5,
    cost: 5000,
    requires: 'bat_enhanced_lead',
  ),
  'bat_lithium': BatteryUpgrade(
    id: 'bat_lithium',
    name: 'Lithium-Ion',
    voltage: 48.0,
    capacityWh: 10.0,
    efficiency: 0.96,
    chargeMultiplier: 2.0,
    cost: 12000,
    requires: 'bat_agm',
  ),
  'bat_lifepo4': BatteryUpgrade(
    id: 'bat_lifepo4',
    name: 'LiFePO4',
    voltage: 48.0,
    capacityWh: 20.0,
    efficiency: 0.98,
    chargeMultiplier: 2.5,
    cost: 25000,
    requires: 'bat_lithium',
  ),
};

// =============================================================================
// STATE
// =============================================================================
final currentBatteryUpgrade = signal<BatteryUpgrade>(
  batteryUpgradeTree['bat_lead_acid']!,
);

// =============================================================================
// COMPUTED
// =============================================================================
final nextBatteryUpgrade = computed<BatteryUpgrade?>(() {
  try {
    return batteryUpgradeTree.values.firstWhere(
      (u) => u.requires == currentBatteryUpgrade.value.id,
    );
  } catch (_) {
    return null;
  }
});

// =============================================================================
// ACTIONS
// =============================================================================
void purchaseBatteryUpgrade(String id) {
  final next = batteryUpgradeTree[id];
  if (next == null) return;
  if (next.requires != currentBatteryUpgrade.value.id) return;
  currentBatteryUpgrade.value = next;
}
