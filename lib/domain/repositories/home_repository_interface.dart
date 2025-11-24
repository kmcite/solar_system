import '../entities/home_device.dart';

/// Repository interface for home devices data access
abstract class HomeRepositoryInterface {
  /// Get current home devices state
  Future<HomeDevices> getHomeDevices();

  /// Update home devices state
  Future<void> updateHomeDevices(HomeDevices devices);

  /// Stream home devices state changes
  Stream<HomeDevices> watchHomeDevices();

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
