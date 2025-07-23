// import 'package:solar_system/v2/sunlight_flow.dart';
// import 'package:solar_system/_archive/domain/apis/loads_repository.dart';
// import 'package:solar_system/_archive/domain/apis/panels_repository.dart';
// import 'package:solar_system/_archive/domain/apis/utility_repository.dart';
// import 'package:solar_system/_archive/domain/models/load.dart';
// import 'package:solar_system/_archive/features/home/loads_tile/add_load_dialog.dart';
// import 'package:solar_system/main.dart';

// /// STATE
// double get fullPowerUsage => loadsRepository.allLoads;
// Iterable<Load> get loads => loadsRepository.loads;

// /// EVENTS
// void put(Load load) {
//   loadsRepository.put(load);
//   utilityRepository.loads.value += load.power;
// }

// void remove(Load load) {
//   loadsRepository.remove(load.id);
// }

// void openAddLoadDialog() {
//   navigator.toDialog(AddLoadDialog());
// }

// double totalLoads() {
//   return loadsRepository.allLoads;
// }

// double capacity() {
//   return panelsRepository.power * flowPercentage();
// }

// class LoadsTile extends StatelessWidget {
//   const LoadsTile({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         FTile(
//           title: Row(
//             children: [
//               const Text(
//                 'LOADS',
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 18,
//                 ),
//               ),
//               Spacer(),
//               Text(
//                 '${fullPowerUsage} W',
//               ),
//             ],
//           ),
//           subtitle: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Wrap(
//                 children: loads.map(
//                   (load) {
//                     return Padding(
//                       padding: const EdgeInsets.all(4),
//                       child: FButton.icon(
//                         style: load.status
//                             ? FButtonStyle.primary()
//                             : FButtonStyle.destructive(),
//                         child: Column(
//                           children: [
//                             Text('${load.name}'),
//                             Text('${load.power} W'),
//                           ],
//                         ),
//                         onPress: () {
//                           put(load..status = !load.status);
//                         },
//                         onLongPress: () {
//                           remove(load);
//                         },
//                       ),
//                     );
//                   },
//                 ).toList(),
//               ),
//               if (loads.isEmpty)
//                 const Text(
//                   'No loads available',
//                   style: TextStyle(color: Colors.grey),
//                 ),
//             ],
//           ),
//           suffix: PopupMenuButton<Load?>(
//             icon: const Icon(
//               Icons.add_circle,
//               color: Colors.green,
//             ),
//             itemBuilder: (context) {
//               return [
//                 Load()
//                   ..name = 'Fan'
//                   ..power = 50,
//                 Load()
//                   ..name = 'Fridge'
//                   ..power = 200,
//                 Load()
//                   ..name = 'Washing Machine'
//                   ..power = 500,
//                 Load()
//                   ..name = 'Iron'
//                   ..power = 1000,
//                 Load()
//                   ..name = 'Bulb'
//                   ..power = 10,
//               ].map(
//                 (load) {
//                   return PopupMenuItem(
//                     value: load,
//                     child: Text(load.name),
//                   );
//                 },
//               ).toList()
//                 ..add(
//                   PopupMenuItem(
//                     child: '+'.text(),
//                     value: null,
//                     onTap: () => openAddLoadDialog(),
//                   ),
//                 );
//             },
//             onSelected: (load) {
//               if (load != null) put(load);
//             },
//           ),
//         ),
//         'all loads: ${loadsRepository.allLoads}'.text(),
//         'active loads: ${loadsRepository.activeLoad}'.text(),
//         FProgress(value: 0
//                 // totalLoads() / capacity(),
//                 )
//             .pad(),
//       ],
//     );
//   }
// }
