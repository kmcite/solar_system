import 'package:solar_system/domain/apis/flow_repository.dart';
import 'package:solar_system/main.dart';
import 'package:solar_system/features/home/backup_tile.dart';
import 'package:solar_system/features/home/inverter_tile.dart';
import 'package:solar_system/features/home/loads_tile.dart';
import 'package:solar_system/features/home/panels_tile.dart';
import 'package:solar_system/features/home/utility_tile.dart';
import '../../domain/apis/dark_repository.dart';

mixin SystemBloc {
  bool get dark => darkRepository.dark;
  bool get flowing => flowRepository.flowing;

  final toggleDark = darkRepository.toggle;
  final toggleFlow = flowRepository.toggle;

  double get percentage => flowRepository.percentage;
  double get unusable => flowRepository.unusable;
}

class HomePage extends GUI with SystemBloc {
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Solar System'),
        actions: [
          IconButton(
            onPressed: toggleFlow,
            icon: Icon(flowing ? Icons.flash_on : Icons.flash_off),
          ),
          IconButton(
            onPressed: toggleDark,
            icon: Icon(dark ? Icons.dark_mode : Icons.light_mode),
          ).pad(right: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: percentage),
              duration: const Duration(milliseconds: 1100),
              builder: (context, value, child) {
                return LinearProgressIndicator(
                  value: value,
                  borderRadius: BorderRadius.circular(8),
                  minHeight: 30,
                );
              },
            ).pad(),
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: unusable),
              duration: const Duration(milliseconds: 1100),
              builder: (context, value, child) =>
                  LinearProgressIndicator(
                value: value,
                borderRadius: BorderRadius.circular(8),
                minHeight: 10,
                color: Colors.red,
              ),
            ).pad(),
            InverterTile(),
            BackupTile(),
            PanelsTile(),
            UtilityTile(),
            LoadsTile(),
          ],
        ),
      ),
    );
  }
}
