import 'package:solar_system/main.dart';
import 'package:solar_system/domain/loads_repository.dart';
import 'package:solar_system/utils/bloc/cubit.dart';

class LoadsState {
  double get runningLoads => loads.fold(
    0,
    (a, n) => a + (n.isRunning ? n.power : 0),
  );
  double get totalLoads => loads.fold(0, (a, n) => a + n.power);
  Iterable<Load> loads = [];
  bool loading = false;
  Set<int> loadsToBeRemoved = {};
}

class LoadsBloc extends Cubit<LoadsState> {
  LoadsBloc() : super(LoadsState());

  late LoadsRepository loadsRepository = find();

  @override
  Future<void> initState() {
    loadsRepository.stream.listen(
      (loads) {
        emit(state..loads = loads);
      },
    );
    emit(state..loads = loadsRepository());
    return super.initState();
  }

  void onLoadRemoved(Load load) async {
    emit(
      state
        ..loading = true
        ..loadsToBeRemoved.add(load.id),
    );

    await loadsRepository.remove(load);
    emit(
      state
        ..loading = false
        ..loadsToBeRemoved.remove(load.id),
    );
  }

  void onLoadAdded() async {
    emit(state..loading = true);
    final load = Load();
    await loadsRepository.put(load);
    emit(state..loading = false);
  }

  void onLoadUpdated(Load load) async {
    emit(state..loading = true);
    await loadsRepository.put(load);
    emit(state..loading = false);
  }
}

class LoadsTile extends Feature<LoadsBloc> {
  @override
  LoadsBloc create() => LoadsBloc();

  @override
  Widget build(BuildContext context) {
    return FTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('TotalLoads: ${controller().totalLoads} W'),
          FButton.icon(
            onPress: controller().loading ? null : controller.onLoadAdded,
            child: controller().loading
                ? FCircularProgress.pinwheel()
                : Icon(Icons.add_circle_outline),
          ),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Running: ${controller().runningLoads} W'),
          Text('Needed Loads'),
          Text('Supporting Power: 1200 W'),
          SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final load in controller().loads)
                Column(
                  spacing: 8,
                  children: [
                    FButton.icon(
                      child: Row(
                        spacing: 8,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (controller().loadsToBeRemoved.contains(load.id))
                            FCircularProgress.loader()
                          else
                            Icon(
                              load.isRunning ? Icons.power : Icons.power_off,
                              color: load.isRunning ? Colors.green : Colors.red,
                            ),
                          Text(
                            load.power.toStringAsFixed(0),
                          ),
                        ],
                      ),
                      onPress: () {
                        controller.onLoadUpdated(
                          load..isRunning = !load.isRunning,
                        );
                      },
                      onLongPress: () => controller.onLoadRemoved(load),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}
// /// STATE
// double get fullPowerUsage => loadsRepository.allLoads;
// Iterable<Load> get loads => loadsRepository.loads;


// void openAddLoadDialog() {
//   navigator.toDialog(AddLoadDialog());
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
