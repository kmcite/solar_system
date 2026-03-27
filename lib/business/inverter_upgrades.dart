import 'package:flutter/material.dart';
import 'package:signals/signals.dart';

// =============================================================================
// ENUMS
// =============================================================================
enum VoltageTier {
  v12,
  v24,
  v48
  ;

  double get voltage => switch (this) {
    VoltageTier.v12 => 12.0,
    VoltageTier.v24 => 24.0,
    VoltageTier.v48 => 48.0,
  };
  double get efficiency => switch (this) {
    VoltageTier.v12 => 0.85,
    VoltageTier.v24 => 0.92,
    VoltageTier.v48 => 0.96,
  };
  Color get color => switch (this) {
    VoltageTier.v12 => Colors.orange,
    VoltageTier.v24 => Colors.blue,
    VoltageTier.v48 => Colors.purple,
  };
  String get label => switch (this) {
    VoltageTier.v12 => '12V',
    VoltageTier.v24 => '24V',
    VoltageTier.v48 => '48V',
  };
}

// =============================================================================
// DATA MODEL
// =============================================================================
class InverterUpgrade {
  final String id;
  final double watt;
  final VoltageTier tier;
  final int cost;
  final String? requires;
  final bool status;

  const InverterUpgrade({
    required this.id,
    required this.watt,
    required this.tier,
    required this.cost,
    this.requires,
    this.status = true,
  });

  InverterUpgrade copyWith({
    String? id,
    double? watt,
    VoltageTier? tier,
    int? cost,
    String? requires,
    bool? status,
  }) => InverterUpgrade(
    id: id ?? this.id,
    watt: watt ?? this.watt,
    tier: tier ?? this.tier,
    cost: cost ?? this.cost,
    requires: requires ?? this.requires,
    status: status ?? this.status,
  );
}

// =============================================================================
// UPGRADE TREE (CONSTANT)
// =============================================================================
const inverterTree = <String, InverterUpgrade>{
  // 12V
  'inv_200': InverterUpgrade(
    id: 'inv_200',
    watt: 200,
    tier: VoltageTier.v12,
    cost: 100,
  ),
  'inv_500': InverterUpgrade(
    id: 'inv_500',
    watt: 500,
    tier: VoltageTier.v12,
    cost: 200,
    requires: 'inv_200',
  ),
  'inv_1000': InverterUpgrade(
    id: 'inv_1000',
    watt: 1000,
    tier: VoltageTier.v12,
    cost: 400,
    requires: 'inv_500',
  ),
  // unlock 24V
  'tier_24': InverterUpgrade(
    id: 'tier_24',
    watt: 1200,
    tier: VoltageTier.v24,
    cost: 800,
    requires: 'inv_1000',
  ),
  // 24V progression
  'inv_1500': InverterUpgrade(
    id: 'inv_1500',
    watt: 1500,
    tier: VoltageTier.v24,
    cost: 1000,
    requires: 'tier_24',
  ),
  'inv_1800': InverterUpgrade(
    id: 'inv_1800',
    watt: 1800,
    tier: VoltageTier.v24,
    cost: 1300,
    requires: 'inv_1500',
  ),
  'inv_2100': InverterUpgrade(
    id: 'inv_2100',
    watt: 2100,
    tier: VoltageTier.v24,
    cost: 1600,
    requires: 'inv_1800',
  ),
  'inv_2500': InverterUpgrade(
    id: 'inv_2500',
    watt: 2500,
    tier: VoltageTier.v24,
    cost: 2000,
    requires: 'inv_2100',
  ),
  'inv_3000': InverterUpgrade(
    id: 'inv_3000',
    watt: 3000,
    tier: VoltageTier.v24,
    cost: 2500,
    requires: 'inv_2500',
  ),
  'inv_3500': InverterUpgrade(
    id: 'inv_3500',
    watt: 3500,
    tier: VoltageTier.v24,
    cost: 3000,
    requires: 'inv_3000',
  ),
  'inv_5000': InverterUpgrade(
    id: 'inv_5000',
    watt: 5000,
    tier: VoltageTier.v24,
    cost: 4000,
    requires: 'inv_3500',
  ),
  // unlock 48V
  'tier_48': InverterUpgrade(
    id: 'tier_48',
    watt: 6000,
    tier: VoltageTier.v48,
    cost: 6000,
    requires: 'inv_5000',
  ),
  // 48V progression
  'inv_7000': InverterUpgrade(
    id: 'inv_7000',
    watt: 7000,
    tier: VoltageTier.v48,
    cost: 7000,
    requires: 'tier_48',
  ),
  'inv_8000': InverterUpgrade(
    id: 'inv_8000',
    watt: 8000,
    tier: VoltageTier.v48,
    cost: 9000,
    requires: 'inv_7000',
  ),
  'inv_10000': InverterUpgrade(
    id: 'inv_10000',
    watt: 10000,
    tier: VoltageTier.v48,
    cost: 12000,
    requires: 'inv_8000',
  ),
  'inv_12000': InverterUpgrade(
    id: 'inv_12000',
    watt: 12000,
    tier: VoltageTier.v48,
    cost: 15000,
    requires: 'inv_10000',
  ),
};

// =============================================================================
// STATE
// =============================================================================
final currentInverterUpgrade = signal<InverterUpgrade>(
  inverterTree['inv_200']!,
);

// =============================================================================
// COMPUTED
// =============================================================================
final nextInverterUpgrade = computed<InverterUpgrade?>(() {
  try {
    return inverterTree.values.firstWhere(
      (u) => u.requires == currentInverterUpgrade.value.id,
    );
  } catch (_) {
    return null;
  }
});

// =============================================================================
// ACTIONS
// =============================================================================
void purchaseInverterUpgrade(String id) {
  final next = inverterTree[id];
  if (next == null) return;
  if (next.requires != currentInverterUpgrade.value.id) return;
  currentInverterUpgrade.value = next;
}

void toggleInverterUpgradeStatus() {
  currentInverterUpgrade.value = currentInverterUpgrade.value.copyWith(
    status: !currentInverterUpgrade.value.status,
  );
}

// =============================================================================
// GAME LOGIC HELPERS
// =============================================================================
double calculateOutput({
  required double radiation, // 0-1
  required InverterUpgrade inv,
}) {
  final base = radiation * inv.watt;

  final efficiency = switch (inv.tier) {
    VoltageTier.v12 => 0.85,
    VoltageTier.v24 => 0.92,
    VoltageTier.v48 => 0.96,
  };

  return base * efficiency;
}
