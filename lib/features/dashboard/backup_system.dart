// import 'package:solar_system/_archive/domain/models/battery.dart';
// import 'package:solar_system/_archive/domain/models/inverter.dart';
// import 'package:solar_system/_archive/features/home/battery_charge.dart';
// import 'package:solar_system/main.dart';

// double get currentFlow => batteryRepository.current;

// double get voltage => batteryRepository.voltage;
// double get capacity => batteryRepository.capacity() * 100;

// bool get isInverterOnBattery {
//   return inverter.status() == InverterStatus.battery;
// }

// class BatteryTile extends UI {
//   const BatteryTile({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return FTile(
//       selected: isInverterOnBattery,
//       title: Row(
//         children: [
//           const Text(
//             'BACKUP SYSTEM',
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 18,
//               letterSpacing: 1.1,
//             ),
//           ),
//           Spacer(),
//           FSwitch(
//             value: batteryRepository.status(),
//             onChange: (value) {
//               // batteryRepository.statusRM.state = value;
//             },
//           ),
//           RemainingBatteryCapacity(),
//         ],
//       )
//       subtitle: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         spacing: 4,
//         children: [
//           Text('Manage your backup batteries'),
//           // Text('${state}'),
//           Row(
//             children: [
//               Text('Battery: '),
//               Badge(
//                 label: capacity.toStringAsFixed(1).text(),
//                 backgroundColor: Colors.green,
//               ),
//               Text(' Ah'),
//             ],
//           ),
//           Row(
//             children: [
//               Text('Voltage: '),
//               Badge(
//                 label: voltage.toStringAsFixed(1).text(),
//                 backgroundColor: Colors.green,
//               ),
//               Text(' V'),
//             ],
//           ),
//           Row(
//             children: [
//               Text('Current Flow: '),
//               Badge(
//                 label: currentFlow.toStringAsFixed(2).text(),
//                 backgroundColor: Colors.red,
//               ),
//               Text(' A'),
//             ],
//           ),
//           SizedBox(height: 8),
//         ],
//       ),
//     );
//   }
// }
