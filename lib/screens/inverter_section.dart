import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:solar_system/business/inverter.dart';
import 'package:solar_system/business/inverter_upgrades.dart';
import 'package:solar_system/screens/game_screen.dart';
import 'package:solar_system/utils/ui_helpers.dart';

class InverterSection extends StatelessWidget {
  const InverterSection();

  @override
  Widget build(BuildContext context) {
    return Watch((context) {
      final isOn = inverterStatus.value;
      final currentUpgrade = currentInverterUpgrade.value;

      return Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            crossAxisAlignment: .stretch,
            children: [
              Text('Inverter'),
              // Main control row
              GestureDetector(
                onTap: () => toggleInverter(),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      Icon(
                        CupertinoIcons.power,
                        size: 32,
                        color: isOn ? AppColors.iosGreen : AppColors.iosRed,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        isOn ? 'ON' : 'OFF',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: isOn ? AppColors.iosGreen : AppColors.iosRed,
                        ),
                      ),
                      const Spacer(),
                      CupertinoSwitch(
                        value: isOn,
                        onChanged: (_) => toggleInverter(),
                      ),
                    ],
                  ),
                ),
              ),
              // Stats row
              Row(
                children: [
                  IconValue(
                    icon: CupertinoIcons.bolt,
                    value: '${currentUpgrade.watt.toStringAsFixed(0)}W',
                    iconColor: AppColors.iosOrange,
                  ),
                  const SizedBox(width: 16),
                  IconValue(
                    icon: CupertinoIcons.square_grid_2x2,
                    value: currentUpgrade.tier.label,
                    iconColor: AppColors.iosTeal,
                  ),
                  const SizedBox(width: 16),
                  IconValue(
                    icon: CupertinoIcons.gauge,
                    value:
                        '${(currentUpgrade.tier.efficiency * 100).toStringAsFixed(0)}%',
                    iconColor: AppColors.iosGreen,
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
