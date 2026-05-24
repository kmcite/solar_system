import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:solar_system/business/money.dart';
import 'package:solar_system/business/panels.dart';
import 'package:solar_system/business/radiation.dart';
import 'package:solar_system/screens/game_screen.dart';
import 'package:solar_system/utils/builder.dart';

class SolarFarmSection extends StatelessWidget {
  const SolarFarmSection();

  @override
  Widget build(BuildContext context) {
    return listenTo(
      [panels],
      (context) {
        final panelsList = panels.panels;
        final radiationVal = radiation.value;
        final moneyState = money();
        final powerOut = panels.currentPowerOutput;
        final maxCap = panels.currentMaxCapacity;

        final radiationPercent = (radiationVal * 100).clamp(0.0, 100.0);
        final canBuyPanel = moneyState >= 1000;

        return Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Solar Farm'),
                // Stats row
                Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          CupertinoIcons.sun_max,
                          size: 16,
                          color: CupertinoColors.systemOrange,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${radiationPercent.toStringAsFixed(0)}%',
                          style: const TextStyle(fontSize: 12),
                        ),
                        const SizedBox(width: 4),
                        SizedBox(
                          width: 40,
                          child: CupertinoProgressBar(
                            value: radiationPercent / 100,
                            backgroundColor: CupertinoColors.systemGrey5,
                            valueColor: CupertinoColors.systemOrange,
                          ),
                        ),
                      ],
                    ),
                    IconValue(
                      icon: CupertinoIcons.sun_max_fill,
                      value:
                          '${powerOut.toStringAsFixed(0)}/${maxCap.toStringAsFixed(0)}W',
                      iconColor: CupertinoColors.systemYellow,
                    ),
                    IconValue(
                      icon: CupertinoIcons.square_grid_2x2,
                      value: '${panelsList.length}',
                      iconColor: CupertinoColors.systemTeal,
                    ),
                  ],
                ),
                if (panelsList.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: panelsList.map((panel) {
                      return CupertinoChip(
                        icon: CupertinoIcons.sun_max_fill,
                        label: '#${panel.id}',
                        isSelected: panel.status,
                        onTap: () => panels.togglePanelActivation(panel),
                      );
                    }).toList(),
                  ),
                ],
                const SizedBox(height: 8),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: canBuyPanel
                      ? () {
                          panels.createPanel();
                          money.debit(1000);
                        }
                      : null,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(CupertinoIcons.plus_circle, size: 16),
                      const SizedBox(width: 4),
                      const Text('₨1,000'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
