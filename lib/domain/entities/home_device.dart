import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';

/// Type of home device
enum HomeDeviceType {
  computer,
  laptop,
  phoneCharger,
  clothingIron,
  waterPump,
  television,
  refrigerator,
  microwave,
  airConditioner,
  washingMachine,
  lighting,
  generic, // For general loads like the existing ones
  other;

  /// Get display name for the device type
  String get displayName {
    switch (this) {
      case HomeDeviceType.computer:
        return 'Computer';
      case HomeDeviceType.laptop:
        return 'Laptop';
      case HomeDeviceType.phoneCharger:
        return 'Phone Charger';
      case HomeDeviceType.clothingIron:
        return 'Clothing Iron';
      case HomeDeviceType.waterPump:
        return 'Water Pump';
      case HomeDeviceType.television:
        return 'Television';
      case HomeDeviceType.refrigerator:
        return 'Refrigerator';
      case HomeDeviceType.microwave:
        return 'Microwave';
      case HomeDeviceType.airConditioner:
        return 'Air Conditioner';
      case HomeDeviceType.washingMachine:
        return 'Washing Machine';
      case HomeDeviceType.lighting:
        return 'Lighting';
      case HomeDeviceType.generic:
        return 'General Load';
      case HomeDeviceType.other:
        return 'Other';
    }
  }

  /// Get icon for the device type
  IconData get icon {
    switch (this) {
      case HomeDeviceType.computer:
        return FontAwesomeIcons.desktop;
      case HomeDeviceType.laptop:
        return FontAwesomeIcons.laptop;
      case HomeDeviceType.phoneCharger:
        return FontAwesomeIcons.mobileAlt;
      case HomeDeviceType.clothingIron:
        return FontAwesomeIcons.fire;
      case HomeDeviceType.waterPump:
        return FontAwesomeIcons.faucet;
      case HomeDeviceType.television:
        return FontAwesomeIcons.tv;
      case HomeDeviceType.refrigerator:
        return FontAwesomeIcons.snowflake;
      case HomeDeviceType.microwave:
        return FontAwesomeIcons.bluetooth;
      case HomeDeviceType.airConditioner:
        return FontAwesomeIcons.wind;
      case HomeDeviceType.washingMachine:
        return FontAwesomeIcons.tshirt;
      case HomeDeviceType.lighting:
        return FontAwesomeIcons.lightbulb;
      case HomeDeviceType.generic:
        return FontAwesomeIcons.plug;
      case HomeDeviceType.other:
        return FontAwesomeIcons.cogs;
    }
  }

  /// Get typical power consumption in watts
  double get typicalPowerConsumption {
    switch (this) {
      case HomeDeviceType.computer:
        return 300.0;
      case HomeDeviceType.laptop:
        return 65.0;
      case HomeDeviceType.phoneCharger:
        return 20.0;
      case HomeDeviceType.clothingIron:
        return 1200.0;
      case HomeDeviceType.waterPump:
        return 750.0;
      case HomeDeviceType.television:
        return 150.0;
      case HomeDeviceType.refrigerator:
        return 400.0;
      case HomeDeviceType.microwave:
        return 1000.0;
      case HomeDeviceType.airConditioner:
        return 2000.0;
      case HomeDeviceType.washingMachine:
        return 500.0;
      case HomeDeviceType.lighting:
        return 60.0;
      case HomeDeviceType.generic:
        return 100.0;
      case HomeDeviceType.other:
        return 100.0;
    }
  }
}

/// Home device entity representing a household electrical device
class HomeDevice {
  final String id;
  final String name;
  final HomeDeviceType type;
  double powerConsumption;
  bool isActive;
  final String? roomId;
  final DateTime? lastUpdated;

  HomeDevice({
    required this.id,
    required this.name,
    required this.type,
    double? powerConsumption,
    bool? isActive,
    this.roomId,
    this.lastUpdated,
  }) : powerConsumption = powerConsumption ?? type.typicalPowerConsumption,
       isActive = isActive ?? true;

  /// Create a HomeDevice from a Load entity (for migration)
  factory HomeDevice.fromLoad({
    required String id,
    required String name,
    required double powerConsumption,
    required bool isActive,
    String? roomId,
    DateTime? lastUpdated,
  }) {
    return HomeDevice(
      id: id,
      name: name,
      type: HomeDeviceType.generic, // Default to generic for migrated loads
      powerConsumption: powerConsumption,
      isActive: isActive,
      roomId: roomId,
      lastUpdated: lastUpdated,
    );
  }

  /// Get device icon
  IconData get icon => type.icon;

  /// Get device type display name
  String get typeDisplayName => type.displayName;

  /// Check if device is currently consuming power
  bool get isConsumingPower => isActive && powerConsumption > 0;

  /// Get energy consumption in kWh for a given duration in hours
  double getEnergyConsumption(double hours) {
    if (!isConsumingPower) return 0.0;
    return (powerConsumption * hours) / 1000.0; // Convert W to kWh
  }

  /// Create a copy with updated values
  HomeDevice copyWith({
    String? id,
    String? name,
    HomeDeviceType? type,
    double? powerConsumption,
    bool? isActive,
    String? roomId,
    DateTime? lastUpdated,
  }) {
    return HomeDevice(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      powerConsumption: powerConsumption ?? this.powerConsumption,
      isActive: isActive ?? this.isActive,
      roomId: roomId ?? this.roomId,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  String toString() {
    return 'HomeDevice(id: $id, name: $name, type: $typeDisplayName, '
        'power: ${powerConsumption.toStringAsFixed(1)}W, active: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HomeDevice &&
        other.id == id &&
        other.name == name &&
        other.type == type &&
        other.powerConsumption == powerConsumption &&
        other.isActive == isActive &&
        other.roomId == roomId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        type.hashCode ^
        powerConsumption.hashCode ^
        isActive.hashCode ^
        roomId.hashCode;
  }
}

/// Room entity for organizing home devices
class Room {
  final String id;
  final String name;
  final List<String> deviceIds;
  final DateTime? lastUpdated;

  Room({
    required this.id,
    required this.name,
    this.deviceIds = const [],
    this.lastUpdated,
  });

  Room copyWith({
    String? id,
    String? name,
    List<String>? deviceIds,
    DateTime? lastUpdated,
  }) {
    return Room(
      id: id ?? this.id,
      name: name ?? this.name,
      deviceIds: deviceIds ?? this.deviceIds,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  String toString() {
    return 'Room(id: $id, name: $name, deviceCount: ${deviceIds.length})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Room &&
        other.id == id &&
        other.name == name &&
        other.deviceIds.length == deviceIds.length;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ deviceIds.length;
  }
}

/// Collection of home devices
class HomeDevices {
  final List<HomeDevice> devices;
  final List<Room> rooms;
  final DateTime? lastUpdated;

  HomeDevices({
    this.devices = const [],
    this.rooms = const [],
    this.lastUpdated,
  });

  /// Total power consumption from all active devices
  double get totalConsumption {
    return devices
        .where((device) => device.isConsumingPower)
        .fold(0.0, (sum, device) => sum + device.powerConsumption);
  }

  /// Number of active devices
  int get activeCount =>
      devices.where((device) => device.isConsumingPower).length;

  /// Average power consumption per active device
  double get averageConsumption {
    final activeDevices = devices.where((device) => device.isConsumingPower);
    if (activeDevices.isEmpty) return 0.0;
    return totalConsumption / activeDevices.length;
  }

  /// Get devices by room
  List<HomeDevice> getDevicesByRoom(String roomId) {
    return devices.where((device) => device.roomId == roomId).toList();
  }

  /// Get devices by type
  List<HomeDevice> getDevicesByType(HomeDeviceType type) {
    return devices.where((device) => device.type == type).toList();
  }

  /// Get total consumption by room
  double getConsumptionByRoom(String roomId) {
    return getDevicesByRoom(roomId)
        .where((device) => device.isConsumingPower)
        .fold(0.0, (sum, device) => sum + device.powerConsumption);
  }

  /// Get total consumption by device type
  double getConsumptionByType(HomeDeviceType type) {
    return getDevicesByType(type)
        .where((device) => device.isConsumingPower)
        .fold(0.0, (sum, device) => sum + device.powerConsumption);
  }

  HomeDevices copyWith({
    List<HomeDevice>? devices,
    List<Room>? rooms,
    DateTime? lastUpdated,
  }) {
    return HomeDevices(
      devices: devices ?? this.devices,
      rooms: rooms ?? this.rooms,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  String toString() {
    return 'HomeDevices(deviceCount: ${devices.length}, activeCount: $activeCount, '
        'totalConsumption: ${totalConsumption.toStringAsFixed(1)}W)';
  }
}
