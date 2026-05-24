import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Card;
import 'package:signals_flutter/signals_flutter.dart';
import 'package:solar_system/business/radiation.dart';
import 'package:solar_system/screens/game_screen.dart';
import 'package:solar_system/utils/ui_helpers.dart';

class DayNightCycleSection extends StatelessWidget {
  const DayNightCycleSection();

  @override
  Widget build(BuildContext context) {
    return Watch((context) {
      final timeOfDay = currentTimeOfDay.value;
      final progress = dayProgress.value;
      final radiationVal = radiation.value;
      final label = timeOfDayLabel.value;
      final percent = cycleProgressPercent.value;
      final nextPhaseTime = timeUntilNextPhase.value;

      Color cycleColor;
      IconData cycleIcon;
      switch (timeOfDay) {
        case TimeOfDay.night:
          cycleColor = AppColors.iosIndigo;
          cycleIcon = CupertinoIcons.moon;
          break;
        case TimeOfDay.dawn:
          cycleColor = AppColors.iosOrange;
          cycleIcon = CupertinoIcons.sunset;
          break;
        case TimeOfDay.day:
          cycleColor = AppColors.iosYellow;
          cycleIcon = CupertinoIcons.sun_max;
          break;
        case TimeOfDay.dusk:
          cycleColor = AppColors.iosPink;
          cycleIcon = CupertinoIcons.sunrise;
          break;
      }

      return Card(
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Cycle'),
              Row(
                children: [
                  Icon(cycleIcon, color: cycleColor, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    '[TIME: $label]',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: cycleColor,
                    ),
                  ),
                  const Spacer(),
                  IconValue(
                    icon: CupertinoIcons.sun_max,
                    value: '${(radiationVal * 100).toStringAsFixed(0)}%',
                    iconColor: radiationVal > 0
                        ? AppColors.iosYellow
                        : AppColors.iosGray,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Progress bar
              CupertinoProgressBar(
                value: progress,
                backgroundColor: AppColors.cardDark,
                valueColor: cycleColor,
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '00:00',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.iosGray,
                    ),
                  ),
                  Text(
                    'Progress: $percent%',
                    style: TextStyle(
                      fontSize: 12,
                      color: cycleColor,
                    ),
                  ),
                  Text(
                    '24:00',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.iosGray,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(CupertinoIcons.time, size: 14, color: AppColors.iosGray),
                  const SizedBox(width: 4),
                  Text(
                    'Next phase in ${nextPhaseTime}s',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.iosGray,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
