import 'package:flutter/cupertino.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:solar_system/business/dark.dart';
import 'package:solar_system/business/radiation.dart';
import 'package:solar_system/screens/game_screen.dart';

class SettingsDialog extends StatelessWidget {
  const SettingsDialog();

  @override
  Widget build(BuildContext context) {
    return Watch((context) {
      final darkState = dark();
      final radiationVal = radiation.value;
      final cyclePos = elapsedSeconds.value;
      final cycleDur = cycleDuration.value;

      final halfCycle = cycleDur ~/ 2;
      final isDay = cyclePos <= halfCycle && radiationVal > 0;

      return CupertinoAlertDialog(
        title: const Text('Settings'),
        content: SizedBox(
          width: 280,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Dark Mode'),
                  CupertinoSwitch(
                    value: darkState,
                    onChanged: (_) => dark.toggleDark(),
                  ),
                ],
              ),
              Container(height: 1, color: CupertinoColors.separator),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Cycle Duration'),
                  Text('${cycleDur}s'),
                ],
              ),
              CupertinoSlider(
                value: cycleDur.toDouble(),
                min: 10,
                max: 300,
                divisions: 29,
                onChanged: (value) {
                  configureRadiationCycle(value.toInt());
                },
              ),
              Container(height: 1, color: CupertinoColors.separator),
              Row(
                children: [
                  Icon(isDay ? CupertinoIcons.sun_max : CupertinoIcons.moon),
                  const SizedBox(width: 8),
                  Text(isDay ? 'Day' : 'Night'),
                  const Spacer(),
                  Text('${cyclePos}s / ${cycleDur}s'),
                ],
              ),
              CupertinoProgressBar(
                value: cyclePos / cycleDur,
                backgroundColor: CupertinoColors.systemGrey5,
                valueColor: CupertinoColors.systemBlue,
              ),
            ],
          ),
        ),
        actions: [
          CupertinoButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      );
    });
  }
}
