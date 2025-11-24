import 'package:flutter/material.dart';
import '../../domain/entities/home_device.dart';
import '../../domain/repositories/home_repository_interface.dart';

/// Provider that manages home devices state
class HomeProvider extends ChangeNotifier {
  final HomeRepositoryInterface _homeRepository;
  HomeDevices _devices = HomeDevices();
  bool _isLoading = false;
  String? _error;

  HomeProvider({
    required HomeRepositoryInterface homeRepository,
  }) : _homeRepository = homeRepository {
    _loadDevices();
  }

  // Getters
  HomeDevices get devices => _devices;
  List<HomeDevice> get deviceList => _devices.devices;
  List<Room> get rooms => _devices.rooms;
  bool get isLoading => _isLoading;
  String? get error => _error;
  double get totalConsumption => _devices.totalConsumption;
  int get activeCount => _devices.activeCount;

  /// Load home devices from repository
  Future<void> _loadDevices() async {
    _setLoading(true);
    try {
      _devices = await _homeRepository.getHomeDevices();
      _clearError();
    } catch (e) {
      _setError('Failed to load home devices: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Refresh devices from repository
  Future<void> refreshDevices() async {
    await _loadDevices();
  }

  /// Toggle device state
  Future<void> toggleDevice(String deviceId) async {
    try {
      await _homeRepository.toggleDevice(deviceId);
      await _loadDevices();
    } catch (e) {
      _setError('Failed to toggle device: $e');
    }
  }

  /// Update device
  Future<void> updateDevice(HomeDevice device) async {
    try {
      await _homeRepository.updateDevice(device);
      await _loadDevices();
    } catch (e) {
      _setError('Failed to update device: $e');
    }
  }

  /// Add new device
  Future<void> addDevice(HomeDevice device) async {
    try {
      await _homeRepository.addDevice(device);
      await _loadDevices();
    } catch (e) {
      _setError('Failed to add device: $e');
    }
  }

  /// Remove device
  Future<void> removeDevice(String deviceId) async {
    try {
      await _homeRepository.removeDevice(deviceId);
      await _loadDevices();
    } catch (e) {
      _setError('Failed to remove device: $e');
    }
  }

  /// Get devices by room
  List<HomeDevice> getDevicesByRoom(String roomId) {
    return _devices.getDevicesByRoom(roomId);
  }

  /// Get devices by type
  List<HomeDevice> getDevicesByType(HomeDeviceType type) {
    return _devices.getDevicesByType(type);
  }

  /// Get consumption by room
  double getConsumptionByRoom(String roomId) {
    return _devices.getConsumptionByRoom(roomId);
  }

  /// Get consumption by type
  double getConsumptionByType(HomeDeviceType type) {
    return _devices.getConsumptionByType(type);
  }

  /// Add new room
  Future<void> addRoom(Room room) async {
    try {
      await _homeRepository.addRoom(room);
      await _loadDevices();
    } catch (e) {
      _setError('Failed to add room: $e');
    }
  }

  /// Update room
  Future<void> updateRoom(Room room) async {
    try {
      await _homeRepository.updateRoom(room);
      await _loadDevices();
    } catch (e) {
      _setError('Failed to update room: $e');
    }
  }

  /// Remove room
  Future<void> removeRoom(String roomId) async {
    try {
      await _homeRepository.removeRoom(roomId);
      await _loadDevices();
    } catch (e) {
      _setError('Failed to remove room: $e');
    }
  }

  /// Initialize with sample data
  Future<void> initializeSampleData() async {
    _setLoading(true);
    try {
      await _homeRepository.initializeSampleData();
      await _loadDevices();
    } catch (e) {
      _setError('Failed to initialize sample data: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Reset all devices
  Future<void> resetDevices() async {
    try {
      await _homeRepository.resetDevices();
      await _loadDevices();
    } catch (e) {
      _setError('Failed to reset devices: $e');
    }
  }

  /// Get energy consumption analytics
  Future<Map<String, double>> getEnergyConsumption({
    DateTime? startTime,
    DateTime? endTime,
  }) async {
    try {
      return await _homeRepository.getEnergyConsumption(
        startTime: startTime,
        endTime: endTime,
      );
    } catch (e) {
      _setError('Failed to get energy consumption: $e');
      return {};
    }
  }

  /// Set loading state
  void _setLoading(bool loading) {
    if (_isLoading != loading) {
      _isLoading = loading;
      notifyListeners();
    }
  }

  /// Set error state
  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  /// Clear error state
  void _clearError() {
    if (_error != null) {
      _error = null;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
