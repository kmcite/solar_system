// // ignore_for_file: deprecated_member_use

// import 'package:signals_flutter/signals_flutter.dart';
// import 'package:solar_system/v2/panels.dart';
// import 'package:solar_system/v2/sunlight.dart';
// import 'package:solar_system/v2/sunlight_flow.dart';
// // import 'package:solar_system/_archive/domain/apis/flow_repository.dart';
// // import 'package:solar_system/_archive/features/home/sunlight.dart';
// // import 'package:solar_system/_archive/features/settings/settings.dart';
// import 'package:solar_system/main.dart';
// // import 'package:solar_system/_archive/features/home/backup_system.dart';
// // import 'package:solar_system/_archive/features/home/inverter_tile.dart';
// // import 'package:solar_system/_archive/features/home/loads_tile/loads_tile.dart';
// // import 'package:solar_system/_archive/features/home/panels_tile.dart';
// // import 'package:solar_system/_archive/features/home/utility_tile.dart';

// final dark = signal(true);

// void toggle_dark() => dark.set(!dark());

// class HomePage extends UI {
//   const HomePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return FScaffold(
//       header: FHeader(
//         title: const Text('Solar System'),
//         suffixes: [
//           FHeaderAction(
//             onPress: toggle_flow,
//             icon: Icon(
//               isFlowing() ? Icons.flash_on : Icons.flash_off,
//             ),
//           ),
//           FHeaderAction(
//             onPress: toggle_dark,
//             icon: Icon(
//               dark() ? Icons.dark_mode : Icons.light_mode,
//             ),
//           ),
//           // FHeaderAction(
//           //   onPress: () => navigator.to(SettingsPage()),
//           //   icon: Icon(Icons.settings),
//           // ),
//         ],
//       ),
//       child: Column(
//         spacing: 8,
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           Sunlight(),
//           FTile(
//             title: '$powerCapacityOfPanels watts'.text(),
//             subtitle: Wrap(
//               spacing: 8,
//               children: [
//                 for (final panel in panels.values)
//                   GUI(
//                     () {
//                       return FButton.icon(
//                         child: Icon(FIcons.ethernetPort),
//                         onPress: () => remove_panel(panel),
//                       );
//                     },
//                   ),
//               ],
//             ),
//             suffix: FButton.icon(
//               onPress: () => put_panel(Panel()),
//               child: Icon(FIcons.plus),
//             ),
//           ),

//           // InverterTile(),
//           // BatteryTile(),
//           // PanelsTile(),
//           // UtilityTile(),
//           // LoadsTile(),
//         ],
//       ),
//     );
//   }
// }
