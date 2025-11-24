import 'package:flutter/foundation.dart';
import 'package:solar_system/domain/repositories/loads_repository.dart';
import '../entities/home_device.dart';
import '../../../utils/repository.dart';

/// Repository interface for home devices data access
abstract class IHomeRepository extends Repository<HomeDevices> {
  /// Get current home devices state
  Future<HomeDevices> getHomeDevices();

  /// Update home devices state
  Future<void> updateHomeDevices(HomeDevices devices);

  /// Update individual device
  Future<void> updateDevice(HomeDevice device);

  /// Add new device
  Future<void> addDevice(HomeDevice device);

  /// Remove device
  Future<void> removeDevice(String deviceId);

  /// Toggle device state
  Future<void> toggleDevice(String deviceId);

  /// Get device by ID
  Future<HomeDevice?> getDeviceById(String deviceId);

  /// Get devices by room
  Future<List<HomeDevice>> getDevicesByRoom(String roomId);

  /// Get devices by type
  Future<List<HomeDevice>> getDevicesByType(HomeDeviceType type);

  /// Room management
  Future<List<Room>> getRooms();
  Future<void> addRoom(Room room);
  Future<void> updateRoom(Room room);
  Future<void> removeRoom(String roomId);
  Future<Room?> getRoomById(String roomId);

  /// Get devices history
  Future<List<HomeDevices>> getDevicesHistory({
    DateTime? startTime,
    DateTime? endTime,
    int? limit,
  });

  /// Get energy consumption analytics
  Future<Map<String, double>> getEnergyConsumption({
    DateTime? startTime,
    DateTime? endTime,
  });

  /// Reset devices to default state
  Future<void> resetDevices();

  /// Initialize with sample data
  Future<void> initializeSampleData();
}

/// Implementation of HomeRepository using in-memory storage
class HomeRepository extends IHomeRepository {
  HomeDevices _homeDevices = _createSampleHomeDevices();
  final List<HomeDevices> _history = [];

  /// Migrate existing loads to home devices
  Future<void> migrateFromLoads(LoadsRepository loadsRepo) async {
    try {
      final loads = await loadsRepo.getLoads();
      final migratedDevices = loads.loads
          .map(
            (load) => HomeDevice.fromLoad(
              id: load.id,
              name: load.name,
              powerConsumption: load.powerConsumption,
              isActive: load.isActive,
              lastUpdated: load.lastUpdated,
            ),
          )
          .toList();

      // Merge with existing devices, avoiding duplicates
      final existingDeviceIds = _homeDevices.devices.map((d) => d.id).toSet();
      final newDevices = migratedDevices
          .where((d) => !existingDeviceIds.contains(d.id))
          .toList();

      if (newDevices.isNotEmpty) {
        final updatedDevices = _homeDevices.copyWith(
          devices: [..._homeDevices.devices, ...newDevices],
          lastUpdated: DateTime.now(),
        );
        await updateHomeDevices(updatedDevices);
      }
    } catch (e) {
      debugPrint('Error migrating loads: $e');
    }
  }

  @override
  Future<HomeDevices> getHomeDevices() async {
    return _homeDevices;
  }

  @override
  Future<void> updateHomeDevices(HomeDevices devices) async {
    _homeDevices = devices.copyWith(lastUpdated: DateTime.now());
    _addToHistory(_homeDevices);
    notify(_homeDevices);
  }

  @override
  Future<void> updateDevice(HomeDevice device) async {
    final updatedDevices = _homeDevices.copyWith(
      devices: _homeDevices.devices
          .map((d) => d.id == device.id ? device : d)
          .toList(),
      lastUpdated: DateTime.now(),
    );
    await updateHomeDevices(updatedDevices);
  }

  @override
  Future<void> addDevice(HomeDevice device) async {
    final updatedDevices = _homeDevices.copyWith(
      devices: [..._homeDevices.devices, device],
      lastUpdated: DateTime.now(),
    );
    await updateHomeDevices(updatedDevices);
  }

  @override
  Future<void> removeDevice(String deviceId) async {
    final updatedDevices = _homeDevices.copyWith(
      devices: _homeDevices.devices
          .where((device) => device.id != deviceId)
          .toList(),
      lastUpdated: DateTime.now(),
    );
    await updateHomeDevices(updatedDevices);
  }

  @override
  Future<void> toggleDevice(String deviceId) async {
    final targetDevice = _homeDevices.devices.firstWhere(
      (device) => device.id == deviceId,
    );
    final updatedDevice = targetDevice.copyWith(
      isActive: !targetDevice.isActive,
      lastUpdated: DateTime.now(),
    );
    await updateDevice(updatedDevice);
  }

  @override
  Future<HomeDevice?> getDeviceById(String deviceId) async {
    try {
      return _homeDevices.devices.firstWhere((device) => device.id == deviceId);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<HomeDevice>> getDevicesByRoom(String roomId) async {
    return _homeDevices.devices
        .where((device) => device.roomId == roomId)
        .toList();
  }

  @override
  Future<List<HomeDevice>> getDevicesByType(HomeDeviceType type) async {
    return _homeDevices.devices.where((device) => device.type == type).toList();
  }

  @override
  Future<List<Room>> getRooms() async {
    return _homeDevices.rooms;
  }

  @override
  Future<void> addRoom(Room room) async {
    final updatedDevices = _homeDevices.copyWith(
      rooms: [..._homeDevices.rooms, room],
      lastUpdated: DateTime.now(),
    );
    await updateHomeDevices(updatedDevices);
  }

  @override
  Future<void> updateRoom(Room room) async {
    final updatedDevices = _homeDevices.copyWith(
      rooms: _homeDevices.rooms.map((r) => r.id == room.id ? room : r).toList(),
      lastUpdated: DateTime.now(),
    );
    await updateHomeDevices(updatedDevices);
  }

  @override
  Future<void> removeRoom(String roomId) async {
    // Remove room and update devices to remove room reference
    final updatedDevices = _homeDevices.copyWith(
      rooms: _homeDevices.rooms.where((room) => room.id != roomId).toList(),
      devices: _homeDevices.devices
          .map(
            (device) => device.roomId == roomId
                ? device.copyWith(roomId: null)
                : device,
          )
          .toList(),
      lastUpdated: DateTime.now(),
    );
    await updateHomeDevices(updatedDevices);
  }

  @override
  Future<Room?> getRoomById(String roomId) async {
    try {
      return _homeDevices.rooms.firstWhere((room) => room.id == roomId);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<HomeDevices>> getDevicesHistory({
    DateTime? startTime,
    DateTime? endTime,
    int? limit,
  }) async {
    var filteredHistory = _history;

    if (startTime != null) {
      filteredHistory = filteredHistory
          .where((devices) => devices.lastUpdated?.isAfter(startTime) ?? false)
          .toList();
    }

    if (endTime != null) {
      filteredHistory = filteredHistory
          .where((devices) => devices.lastUpdated?.isBefore(endTime) ?? false)
          .toList();
    }

    if (limit != null && limit > 0) {
      filteredHistory = filteredHistory.take(limit).toList();
    }

    return filteredHistory.reversed.toList(); // Most recent first
  }

  @override
  Future<Map<String, double>> getEnergyConsumption({
    DateTime? startTime,
    DateTime? endTime,
  }) async {
    // Simple implementation - return consumption by device type
    final Map<String, double> consumptionByType = {};

    for (final device in _homeDevices.devices) {
      if (device.isConsumingPower) {
        final typeName = device.type.displayName;
        consumptionByType[typeName] =
            (consumptionByType[typeName] ?? 0.0) + device.powerConsumption;
      }
    }

    return consumptionByType;
  }

  @override
  Future<void> resetDevices() async {
    _homeDevices = HomeDevices();
    _addToHistory(_homeDevices);
    notify(_homeDevices);
  }

  @override
  Future<void> initializeSampleData() async {
    _homeDevices = _createSampleHomeDevices();
    _addToHistory(_homeDevices);
    notify(_homeDevices);
  }

  // Convenience getters for backward compatibility
  List<HomeDevice> get devices => _homeDevices.devices;
  List<Room> get rooms => _homeDevices.rooms;
  double get totalConsumption => _homeDevices.totalConsumption;

  void _addToHistory(HomeDevices devices) {
    _history.add(devices);

    // Keep only last 1000 entries to prevent memory issues
    if (_history.length > 1000) {
      _history.removeRange(0, _history.length - 1000);
    }
  }

  /// Create sample home devices for demonstration
  static HomeDevices _createSampleHomeDevices() {
    final livingRoom = Room(
      id: 'room_living',
      name: 'Living Room',
    );

    final kitchen = Room(
      id: 'room_kitchen',
      name: 'Kitchen',
    );

    final bedroom = Room(
      id: 'room_bedroom',
      name: 'Bedroom',
    );

    return HomeDevices(
      devices: [
        // Living Room devices
        HomeDevice(
          id: 'device_tv',
          name: 'TV',
          type: HomeDeviceType.television,
          isActive: true,
          roomId: livingRoom.id,
        ),
        HomeDevice(
          id: 'device_laptop',
          name: 'Work Laptop',
          type: HomeDeviceType.laptop,
          isActive: true,
          roomId: livingRoom.id,
        ),
        HomeDevice(
          id: 'device_phone_charger_1',
          name: 'Phone Charger',
          type: HomeDeviceType.phoneCharger,
          isActive: true,
          roomId: livingRoom.id,
        ),
        HomeDevice(
          id: 'device_lighting_living',
          name: 'Living Room Lights',
          type: HomeDeviceType.lighting,
          powerConsumption: 120.0,
          isActive: true,
          roomId: livingRoom.id,
        ),

        // Kitchen devices
        HomeDevice(
          id: 'device_refrigerator',
          name: 'Refrigerator',
          type: HomeDeviceType.refrigerator,
          isActive: true,
          roomId: kitchen.id,
        ),
        HomeDevice(
          id: 'device_microwave',
          name: 'Microwave Oven',
          type: HomeDeviceType.microwave,
          isActive: false,
          roomId: kitchen.id,
        ),
        HomeDevice(
          id: 'device_water_pump',
          name: 'Water Pump',
          type: HomeDeviceType.waterPump,
          isActive: false,
          roomId: kitchen.id,
        ),

        // Bedroom devices
        HomeDevice(
          id: 'device_phone_charger_2',
          name: 'Bedroom Phone Charger',
          type: HomeDeviceType.phoneCharger,
          isActive: false,
          roomId: bedroom.id,
        ),
        HomeDevice(
          id: 'device_computer',
          name: 'Gaming Computer',
          type: HomeDeviceType.computer,
          isActive: false,
          roomId: bedroom.id,
        ),
        HomeDevice(
          id: 'device_clothing_iron',
          name: 'Clothing Iron',
          type: HomeDeviceType.clothingIron,
          isActive: false,
          roomId: bedroom.id,
        ),

        // Whole house devices
        HomeDevice(
          id: 'device_ac',
          name: 'Air Conditioner',
          type: HomeDeviceType.airConditioner,
          isActive: false,
        ),
        HomeDevice(
          id: 'device_washing_machine',
          name: 'Washing Machine',
          type: HomeDeviceType.washingMachine,
          isActive: false,
        ),
      ],
      rooms: [livingRoom, kitchen, bedroom],
      lastUpdated: DateTime.now(),
    );
  }
}
