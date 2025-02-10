import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:solar_system/main.dart';

class InverterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inverter Status'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: FaIcon(
              FontAwesomeIcons.plugCircleBolt,
              size: 120,
              // color: inverterRM.power.color,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              inverterBloc.inverter.status
                  ? FontAwesomeIcons.toggleOn
                  : FontAwesomeIcons.toggleOff,
              color: inverterBloc.inverter.status ? Colors.green : Colors.red,
            ),
          ),
          // Text(
          //   '${inverter} watts',
          //   textScaler: TextScaler.linear(2),
          // )
        ],
      ),
    );
  }
}
