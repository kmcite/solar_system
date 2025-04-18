import '../../main.dart';

Widget batteryByRemainingCapacity(double capacity) {
  final IconData icon = switch (capacity) {
    <= 0.1 => Icons.battery_0_bar,
    <= 0.2 => Icons.battery_1_bar,
    <= 0.4 => Icons.battery_2_bar,
    <= 0.6 => Icons.battery_4_bar,
    <= 0.8 => Icons.battery_5_bar,
    <= 0.9 => Icons.battery_6_bar,
    _ => Icons.battery_full,
  };

  return Icon(
    icon,
    size: 30,
    color: Colors.orangeAccent,
  );
}
