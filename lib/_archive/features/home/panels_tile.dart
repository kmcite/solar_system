// import 'package:solar_system/v2/sunlight_flow.dart';
// import 'package:solar_system/_archive/domain/apis/panels_repository.dart';
// import 'package:solar_system/_archive/domain/models/inverter.dart';
// import 'package:solar_system/_archive/domain/models/panel.dart';
// import 'package:solar_system/main.dart';

// Iterable<Panel> get panels => panelsRepository.panels;
// double get gemin {
//   return panelsRepository.power * flowPercentage();
// }

// double get panelsPowerCapacity => panelsRepository.power;
// final remove = panelsRepository.remove;
// final put = panelsRepository.put;
// bool get isSolarSelectedForPower {
//   return inverter.status() == InverterStatus.solar;
// }

// class PanelsTile extends UI {
//   @override
//   Widget build(BuildContext context) {
//     return FTile(
//       // selectedColor: Colors.green,
//       selected: isSolarSelectedForPower,
//       title: Row(
//         children: [
//           const Text(
//             'SOLAR PANELS',
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 18,
//               letterSpacing: 1.1,
//             ),
//           ),
//           Spacer(),
//           FButton.icon(
//             style: FButtonStyle.primary(),
//             onPress: () {
//               panelsRepository.put(
//                 Panel(),
//               );
//             },
//             child: Icon(FIcons.plus),
//           )
//         ],
//       ),
//       subtitle: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           Text(
//             'TOTAL: ${panelsPowerCapacity.toStringAsFixed(0)} W',
//           ),
//           Text(
//             'GEMIN: ${gemin.toStringAsFixed(0)} W',
//           ),
//           const SizedBox(height: 8),
//           Wrap(
//             spacing: 16,
//             runSpacing: 16,
//             children: [
//               ...panels.map(
//                 (panel) {
//                   return GestureDetector(
//                     onTap: () {
//                       remove(panel.id);
//                     },
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Icon(
//                           FIcons.ethernetPort,
//                           size: 40,
//                           color: Colors.deepPurple.withValues(
//                             alpha: 120 * 0.8,
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         Text(
//                           '${panel.power.toStringAsFixed(0)} W',
//                           style: const TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 13,
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ).toList(),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
