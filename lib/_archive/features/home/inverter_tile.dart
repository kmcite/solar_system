// import 'package:solar_system/v2/sunlight_flow.dart';
// import 'package:solar_system/_archive/domain/apis/panels_repository.dart';
// import 'package:solar_system/_archive/domain/apis/settings_repository.dart';
// import 'package:solar_system/_archive/domain/models/inverter.dart';
// import 'package:solar_system/main.dart';

// void buyInverter() {
//   inverter.buy();
//   money.value += 1000;
// }

// void pressStatus(InverterStatus status) {
//   inverter.status.set(status);
// }

// void pressOperation(InverterOperation operation) {
//   inverter.operation.set(operation);
// }

// bool isStatus(InverterStatus _status) {
//   return inverter.status() == _status;
// }

// bool isOperation(InverterOperation _operation) {
//   return inverter.operation() == _operation;
// }

// String get powerBeingProduced {
//   if (inverter.isOff) return '0 W';
//   if (inverter.isInverterPresent()) {
//     return '${(flowPercentage() * panelsRepository.power).toStringAsFixed(0)} W';
//   }
//   return '0 W';
// }

// String get moneyStr => '${money} \$';

// class InverterTile extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     if (inverter.isInverterPresent())
//       return FTile(
//         title: Row(
//           children: [
//             const Text(
//               'INVERTER',
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 18,
//                 letterSpacing: 1.1,
//               ),
//             ),
//             const Spacer(),
//             Text(
//               money.toString(),
//               style: const TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ],
//         ),
//         subtitle: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Row(
//               children: List.generate(
//                 InverterOperation.values.length,
//                 (i) {
//                   final operation = InverterOperation.values[i];
//                   return Padding(
//                     padding: const EdgeInsets.all(4.0),
//                     child: FButton.icon(
//                       child: Icon(
//                         switch (operation) {
//                           InverterOperation.auto => FIcons.donut,
//                           InverterOperation.manual => FIcons.handshake,
//                         },
//                       ),
//                       onPress: isOperation(operation)
//                           ? null
//                           : () => pressOperation(operation),
//                     ),
//                   );
//                 },
//               ),
//             ),
//             Row(
//               children: InverterStatus.values.take(4).map(
//                 (status) {
//                   return Padding(
//                     padding: const EdgeInsets.all(4.0),
//                     child: FButton.icon(
//                       child: Icon(status.icon),
//                       onPress:
//                           isStatus(status) ? null : () => pressStatus(status),
//                     ),
//                   );
//                 },
//               ).toList(),
//             ),
//           ],
//         ),
//       );
//     else
//       return FTile(
//         title: const Text('INVERTER'),
//         subtitle: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             const Text('No inverter present'),
//             const SizedBox(height: 8),
//             FButton(
//               onPress: buyInverter,
//               child: const Text('BUY INVERTER'),
//             ),
//           ],
//         ),
//       );
//   }
// }
