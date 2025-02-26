import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../main.dart';

class PanelPage extends UI {
  Widget build(BuildContext context) {
    // final dynamic pv = 0;
    // final energy = (pv.power * pv.usage / 1000000).toStringAsFixed(2);

    return Scaffold(
      appBar: AppBar(title: Text('Panel Details'), centerTitle: true),
      body: SingleChildScrollView(
        child:
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FaIcon(
                  FontAwesomeIcons.solarPanel,
                  size: 80,
                  color: Colors.yellow,
                ).pad(),
                Card(
                  elevation: 4,
                  margin: EdgeInsets.all(8),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        // Text(
                        //   pv.brand,
                        //   style: TextStyle(
                        //     fontSize: 24,
                        //     fontWeight: FontWeight.bold,
                        //   ),
                        // ),
                        Divider(),
                        ListTile(
                          leading: Icon(Icons.bolt),
                          title: Text('Voltage'),
                          // trailing: Text('${pv.voltage}V'),
                        ),
                        ListTile(
                          leading: Icon(Icons.electric_meter),
                          title: Text('Current'),
                          // trailing: Text('${pv.maxCurrent}A'),
                        ),
                        ListTile(
                          leading: Icon(Icons.battery_charging_full),
                          title: Text('Usage'),
                          // trailing: Text('${pv.usage}%'),
                        ),
                        ListTile(
                          leading: Icon(Icons.power),
                          title: Text('Power'),
                          // trailing: Text('${pv.power}W'),
                        ),
                        ListTile(
                          leading: Icon(Icons.energy_savings_leaf),
                          title: Text('Energy'),
                          // trailing: Text('$energy kWh'),
                        ),
                        ListTile(
                          title: Text('Panel Status'),
                          // value: pv.status,
                          // onChanged: null,
                          // trailing: Text(pv.status ? "On" : "Off"),
                          // leading: Icon(
                          //   pv.status ? Icons.check_circle : Icons.error,
                          //   color: pv.status ? Colors.green : Colors.red,
                          // ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ).pad(),
      ),
    );
  }
}
