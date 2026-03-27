import 'package:signals/signals.dart';
import '../domain/models/models.dart';

// =============================================================================
// LOAD MODEL (for signals - not using Equatable anymore)
// =============================================================================
class Load {
  final int id;
  final num load;
  final bool isActive;
  final String type;
  final String name;
  final double revenuePerSecond;

  const Load({
    required this.id,
    required this.load,
    required this.isActive,
    required this.type,
    required this.name,
    required this.revenuePerSecond,
  });

  Load copyWith({
    int? id,
    num? load,
    bool? isActive,
    String? type,
    String? name,
    double? revenuePerSecond,
  }) {
    return Load(
      id: id ?? this.id,
      load: load ?? this.load,
      isActive: isActive ?? this.isActive,
      type: type ?? this.type,
      name: name ?? this.name,
      revenuePerSecond: revenuePerSecond ?? this.revenuePerSecond,
    );
  }
}

// =============================================================================
// STATE
// =============================================================================
final loads = signal<List<Load>>([]);

// =============================================================================
// COMPUTED
// =============================================================================
final totalLoads = computed(() {
  return loads.value.fold<double>(0, (sum, load) => sum + load.load);
});

final totalActiveLoads = computed(() {
  return loads.value.fold<double>(
    0,
    (sum, load) => sum + (load.isActive ? load.load : 0),
  );
});

final totalActiveRevenue = computed(() {
  return loads.value.fold<double>(
    0,
    (sum, load) => sum + (load.isActive ? load.revenuePerSecond : 0),
  );
});

// =============================================================================
// INTERNAL
// =============================================================================
int _nextLoadId = 1;

// =============================================================================
// ACTIONS
// =============================================================================
void purchaseLoad(String loadTypeId) {
  final loadType = loadTypeCatalog[loadTypeId];
  if (loadType == null) return;
  final load = Load(
    id: _nextLoadId++,
    load: loadType.wattage,
    isActive: true,
    type: loadType.id,
    name: loadType.name,
    revenuePerSecond: loadType.revenuePerSecond,
  );
  loads.value = [...loads.value, load];
}

void toggleLoad(int id) {
  loads.value = loads.value.map((l) {
    return l.id == id ? l.copyWith(isActive: !l.isActive) : l;
  }).toList();
}

void removeLoad(int id) {
  loads.value = loads.value.where((l) => l.id != id).toList();
}

void clearAllLoads() {
  loads.value = [];
}
