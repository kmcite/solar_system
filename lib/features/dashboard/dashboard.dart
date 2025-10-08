import 'package:solar_system/main.dart';
import 'package:solar_system/features/dashboard/appBar/app_bar.dart';
import 'package:solar_system/features/dashboard/inverter/inverter_tile.dart';
import 'package:solar_system/features/dashboard/loads/loads_tile.dart';
import 'package:solar_system/features/dashboard/panels_tile.dart';
import 'package:solar_system/features/dashboard/utility/utility_tile.dart';
import 'package:solar_system/features/dashboard/battery_tile.dart';

class DashboardView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tiles = [
      // Counter(),
      InverterView(),
      PanelsTile(),
      UtilityTile(),
      BatteryTile(),
      LoadsTile(),
    ];

    return FScaffold(
      header: appBar(),
      child: ListView.separated(
        separatorBuilder: (context, index) => SizedBox(height: 8),
        // spacing: 8,
        // crossAxisAlignment: CrossAxisAlignment.start,
        itemBuilder: (context, index) => tiles[index],
        itemCount: tiles.length,
      ),
    );
  }
}
