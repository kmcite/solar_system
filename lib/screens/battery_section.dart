import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:solar_system/business/battery.dart';
import 'package:solar_system/business/battery_upgrades.dart';
import 'package:solar_system/business/money.dart';
import 'package:solar_system/screens/game_screen.dart';
import 'package:solar_system/utils/builder.dart';

Widget batterySection() => listenTo(
  [],
  (_) {
    final energyVal = battery.energy;
    final maxCap = battery.maximumCapacity;
    final chargingVal = battery.isCharging; // Changed from isCharging.value
    final tierNameVal = battery.chemistry.name; // Changed from tierName.value
    final currentUpgrade = currentBatteryUpgrade.value;
    final nextUpgrade = nextBatteryUpgrade.value;
    final moneyState = money();
    final remainingCycles = battery.currentRemainingCycles;

    final batteryPercent = maxCap > 0 ? (energyVal / maxCap * 100) : 0.0;
    final canUpgrade = nextUpgrade != null && moneyState >= nextUpgrade.cost;

    final batteryColor = batteryPercent > 50
        ? CupertinoColors.systemGreen
        : batteryPercent > 20
        ? CupertinoColors.systemYellow
        : CupertinoColors.systemRed;
    final batteryIcon = chargingVal
        ? CupertinoIcons.battery_charging
        : batteryPercent > 50
        ? CupertinoIcons.battery_100
        : CupertinoIcons.battery_25;

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Battery'),
            // Main battery row
            Row(
              children: [
                Icon(batteryIcon, size: 28, color: batteryColor),
                const SizedBox(width: 8),
                Text(
                  '${batteryPercent.toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: batteryColor,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: CupertinoProgressBar(
                    value: batteryPercent / 100,
                    backgroundColor: CupertinoColors.systemGrey5,
                    valueColor: batteryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Stats row
            Wrap(
              children: [
                IconValue(
                  icon: CupertinoIcons.tag,
                  value: tierNameVal,
                  iconColor: CupertinoColors.systemTeal,
                ),
                const SizedBox(width: 12),
                IconValue(
                  icon: CupertinoIcons.bolt,
                  value: '${currentUpgrade.voltage.toStringAsFixed(0)}V',
                  iconColor: CupertinoColors.systemYellow,
                ),
                const SizedBox(width: 12),
                IconValue(
                  icon: CupertinoIcons.cube_box,
                  value: '${currentUpgrade.capacityWh.toStringAsFixed(0)}Wh',
                  iconColor: CupertinoColors.systemOrange,
                ),
                const SizedBox(width: 12),
                IconValue(
                  icon: CupertinoIcons.gauge,
                  value:
                      '${(currentUpgrade.efficiency * 100).toStringAsFixed(0)}%',
                  iconColor: CupertinoColors.systemGreen,
                ),
                IconValue(
                  icon: Icons.cyclone,
                  value: '$remainingCycles',
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Upgrade row
            Row(
              children: [
                Icon(
                  CupertinoIcons.up_arrow,
                  size: 16,
                  color: CupertinoColors.systemPurple,
                ),
                const SizedBox(width: 4),
                if (nextUpgrade != null) ...[
                  Text(
                    nextUpgrade.name,
                    style: const TextStyle(fontSize: 12),
                  ),
                  const SizedBox(width: 8),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: canUpgrade
                        ? () {
                            purchaseBatteryUpgrade(nextUpgrade.id);
                            money.debit(nextUpgrade.cost.toDouble());
                          }
                        : null,
                    child: Text('₨${nextUpgrade.cost}'),
                  ),
                ] else
                  Text(
                    'MAX',
                    style: TextStyle(
                      fontSize: 12,
                      color: CupertinoColors.systemGreen,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  },
);
