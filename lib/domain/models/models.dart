class LoadType {
  final String id;
  final String name;
  final double wattage;
  final double cost;
  final double revenuePerSecond;
  final String description;
  final int iconCodePoint; // Store icon as code point for simplicity

  const LoadType({
    required this.id,
    required this.name,
    required this.wattage,
    required this.cost,
    required this.revenuePerSecond,
    required this.description,
    required this.iconCodePoint,
  });
}

const loadTypeCatalog = <String, LoadType>{
  'light_bulb': LoadType(
    id: 'light_bulb',
    name: 'Light Bulb',
    wattage: 100,
    cost: 200,
    revenuePerSecond: 0.5,
    description: 'Neighborhood lighting service',
    iconCodePoint: 0xe3a9, // Icons.lightbulb
  ),
  'sewing_machine': LoadType(
    id: 'sewing_machine',
    name: 'Sewing Machine',
    wattage: 200,
    cost: 600,
    revenuePerSecond: 1.5,
    description: 'Tailoring service',
    iconCodePoint: 0xf04b8, // Icons.precision_manufacturing
  ),
  'washing_machine': LoadType(
    id: 'washing_machine',
    name: 'Washing Machine',
    wattage: 500,
    cost: 1500,
    revenuePerSecond: 5.0,
    description: 'Laundry service',
    iconCodePoint: 0xe779, // Icons.local_laundry_service
  ),
  'iron': LoadType(
    id: 'iron',
    name: 'Iron',
    wattage: 1000,
    cost: 800,
    revenuePerSecond: 3.0,
    description: 'Ironing service',
    iconCodePoint: 0xe3ab, // Icons.iron
  ),
};

class LoadModel {
  final int id;
  final double load;
  final bool status;
  final String type;

  LoadModel({
    required this.id,
    this.load = 100,
    this.status = false,
    this.type = 'light_bulb',
  });

  LoadModel copyWith({
    int? id,
    double? load,
    bool? status,
    String? type,
  }) {
    return LoadModel(
      id: id ?? this.id,
      load: load ?? this.load,
      status: status ?? this.status,
      type: type ?? this.type,
    );
  }
}

class PanelModel {
  final int id;
  final double ratedMaxPowerOutput;
  final double currentMaxPowerOutput;
  final String name;
  final bool status;

  PanelModel({
    required this.id,
    this.ratedMaxPowerOutput = 585,
    this.currentMaxPowerOutput = 580,
    this.name = 'SOFAR',
    this.status = false,
  });

  PanelModel copyWith({
    int? id,
    double? ratedMaxPowerOutput,
    double? currentMaxPowerOutput,
    String? name,
    bool? status,
  }) {
    return PanelModel(
      id: id ?? this.id,
      ratedMaxPowerOutput: ratedMaxPowerOutput ?? this.ratedMaxPowerOutput,
      currentMaxPowerOutput:
          currentMaxPowerOutput ?? this.currentMaxPowerOutput,
      name: name ?? this.name,
      status: status ?? this.status,
    );
  }

  double currentPowerOutput(double radiation) =>
      currentMaxPowerOutput * radiation;
}
