// import 'package:flutter/foundation.dart';

import 'dart:async';

import 'package:solar_system/main.dart';

final battery = Battery();

class Battery with ChangeNotifier {
  Battery() {
    timer = Timer.periodic(1.seconds, update);
  }
  Timer? timer;

  double get remainingCapacity => capacity * 100; // Convert to Ah
  double capacity = 1;
  double loadOnBattery = 0;
  void update(_) {
    if (loadOnBattery > 0) {
      capacity -= loadOnBattery / 1000; // Convert to Ah
      if (capacity < 0) {
        capacity = 0;
      }
    } else if (loadOnBattery < 0) {
      capacity += loadOnBattery / 1000; // Convert to Ah
      if (capacity > 1) {
        capacity = 1;
      }
    }
    notifyListeners();
  }

  double get voltage => 11.0 + (capacity * 2.5);

  void charge(double power) {
    final current = power / (voltage + .5);
    capacity += current / 1000;
    notifyListeners();
  }

  void discharge(double power) {
    final current = power / (voltage + .5);
    capacity -= current / 1000; // Convert to Ah
    notifyListeners();
  }

  @override
  void dispose() {
    timer?.cancel();
    timer = null;
    super.dispose();
  }
}

// /// Abstract BatteryNode Interface
// abstract class BatteryNode extends ChangeNotifier {
//   int get voltage; // Voltage in volts
//   int get current; // Current in amperes
//   int get capacity; // Total capacity in Ah
//   double get remainingCapacity;
//   // Normalized capacity (1.0 -> fully charged, 0.0 -> empty)
//   void charge(double power); // Charge with power in watts per second
//   void discharge(double power);
//   // Discharge with power in watts per second
// }

// /// Battery Class
// class Battery with ChangeNotifier implements BatteryNode {
//   final int voltage; // Battery voltage (immutable)
//   final int current; // Battery current (immutable)
//   final int capacity; // Total capacity in Ah (immutable)
//   double _remainingAh; // Remaining capacity in Ah (mutable)

//   Battery({
//     required this.voltage,
//     required this.current,
//     required this.capacity,
//   }) : _remainingAh = capacity.toDouble();

//   /// Charge the battery
//   @override
//   void charge(double power) {
//     double addedAh =
//         power / (voltage * 3600); // Power to Ah conversion
//     _remainingAh =
//         (_remainingAh + addedAh).clamp(0, capacity.toDouble());
//     notifyListeners(); // Notify listeners of state change
//   }

//   /// Discharge the battery
//   @override
//   void discharge(double power) {
//     double consumedAh =
//         power / (voltage * 3600); // Power to Ah conversion
//     _remainingAh =
//         (_remainingAh - consumedAh).clamp(0, capacity.toDouble());
//     notifyListeners(); // Notify listeners of state change
//   }

//   /// Get the normalized remaining capacity
//   @override
//   double get remainingCapacity => _remainingAh / capacity;
// }

// /// BatteryGroup Class
// class BatteryGroup with ChangeNotifier implements BatteryNode {
//   ConnectionType type; // Connection type: series or parallel
//   final List<BatteryNode>
//       batteries; // List of batteries/groups in the group

//   BatteryGroup({
//     required this.type,
//     required this.batteries,
//   });

//   /// Compute total voltage dynamically
//   @override
//   int get voltage {
//     return type == ConnectionType.series
//         ? batteries.fold(0, (sum, node) => sum + node.voltage)
//         : (batteries.isNotEmpty ? batteries.first.voltage : 0);
//   }

//   /// Compute total current dynamically
//   @override
//   int get current {
//     return type == ConnectionType.parallel
//         ? batteries.fold(0, (sum, node) => sum + node.current)
//         : (batteries.isNotEmpty ? batteries.first.current : 0);
//   }

//   /// Compute total capacity dynamically
//   @override
//   int get capacity {
//     return type == ConnectionType.parallel
//         ? batteries.fold(0, (sum, node) => sum + node.capacity)
//         : (batteries.isNotEmpty ? batteries.first.capacity : 0);
//   }

//   /// Compute total normalized remaining capacity dynamically
//   @override
//   double get remainingCapacity {
//     int totalCapacity = capacity;
//     if (totalCapacity == 0) return 0.0;
//     return batteries.fold(
//             0.0,
//             (sum, node) =>
//                 sum + node.remainingCapacity * node.capacity) /
//         totalCapacity;
//   }

//   /// Charge all batteries in the group
//   @override
//   void charge(double power) {
//     if (batteries.isEmpty) return;
//     for (var node in batteries) {
//       node.charge(
//           power / batteries.length); // Distribute power equally
//     }
//     notifyListeners(); // Notify listeners of state change
//   }

//   /// Discharge all batteries in the group
//   @override
//   void discharge(double power) {
//     if (batteries.isEmpty) return;
//     for (var node in batteries) {
//       node.discharge(
//           power / batteries.length); // Distribute power equally
//     }
//     notifyListeners(); // Notify listeners of state change
//   }

//   /// Add a new battery or group
//   void add(BatteryNode node) {
//     batteries.add(node);
//     notifyListeners(); // Notify listeners of state change
//   }

//   /// Remove a specific battery/group
//   void remove(BatteryNode node) {
//     batteries.remove(node);
//     notifyListeners(); // Notify listeners of state change
//   }

//   /// Change connection type dynamically
//   void changeType(ConnectionType type) {
//     this.type = type;
//     notifyListeners(); // Notify listeners of state change
//   }
// }

// /// Connection Type Enum
// enum ConnectionType { series, parallel }
