import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Card;
import 'package:signals_flutter/signals_flutter.dart';
import 'package:solar_system/business/loads.dart';
import 'package:solar_system/business/money.dart';
import 'package:solar_system/business/panels.dart';
import 'package:solar_system/domain/models/models.dart';
import 'package:solar_system/screens/game_screen.dart';

class LoadsSection extends StatelessWidget {
  const LoadsSection();

  @override
  Widget build(BuildContext context) {
    return Watch((context) {
      final loadsList = loads.value;
      final powerOut = panels.currentPowerOutput;
      final moneyState = money();
      final activeLoadsVal = totalActiveLoads.value;
      final activeRevenueVal = totalActiveRevenue.value;

      return Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Loads'),
              // Balance row
              Wrap(
                spacing: 8,
                runSpacing: 4,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  IconValue(
                    icon: CupertinoIcons.sun_max_fill,
                    value: '${powerOut.toStringAsFixed(0)}W',
                    iconColor: CupertinoColors.systemYellow,
                  ),
                  Icon(
                    CupertinoIcons.arrow_right,
                    size: 14,
                    color: CupertinoColors.systemGrey,
                  ),
                  IconValue(
                    icon: CupertinoIcons.bolt_fill,
                    value: '${activeLoadsVal.toStringAsFixed(0)}W',
                    iconColor: CupertinoColors.systemTeal,
                  ),
                  Text(
                    '|',
                    style: TextStyle(color: CupertinoColors.systemGrey),
                  ),
                  IconValue(
                    icon: CupertinoIcons.money_dollar,
                    value: '+${activeRevenueVal.toStringAsFixed(1)}₨/s',
                    iconColor: CupertinoColors.systemGreen,
                  ),
                ],
              ),
              if (loadsList.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: loadsList.map((load) {
                    return CupertinoChip(
                      icon: _getLoadIcon(load.name),
                      label: '${load.load.toStringAsFixed(0)}W',
                      isSelected: load.isActive,
                      onTap: () => toggleLoad(load.id),
                    );
                  }).toList(),
                ),
              ],
              const SizedBox(height: 8),
              // Marketplace
              Row(
                children: [
                  Icon(
                    CupertinoIcons.cart,
                    size: 14,
                    color: CupertinoColors.systemGrey,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Buy:',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Wrap(
                spacing: 4,
                runSpacing: 4,
                children: loadTypeCatalog.values.map((loadType) {
                  final canBuy = moneyState >= loadType.cost;
                  return CupertinoActionChip(
                    icon: CupertinoIcons.lightbulb,
                    label:
                        '${loadType.wattage.toStringAsFixed(0)}W ₨${loadType.cost.toStringAsFixed(0)}',
                    onTap: canBuy
                        ? () {
                            purchaseLoad(loadType.id);
                            money.debit(loadType.cost);
                          }
                        : null,
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      );
    });
  }

  IconData _getLoadIcon(String name) {
    final lowerName = name.toLowerCase();
    if (lowerName.contains('bulb') || lowerName.contains('light')) {
      return CupertinoIcons.lightbulb;
    } else if (lowerName.contains('iron')) {
      return CupertinoIcons.rectangle_3_offgrid;
    } else if (lowerName.contains('wash') || lowerName.contains('laundry')) {
      return CupertinoIcons.bubble_left;
    } else if (lowerName.contains('sew') || lowerName.contains('machine')) {
      return CupertinoIcons.gear;
    }
    return CupertinoIcons.bolt;
  }
}
