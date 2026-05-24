import 'package:flutter/cupertino.dart';
import 'package:solar_system/business/app.dart';
import 'package:solar_system/business/battery.dart';
import 'package:solar_system/business/dark.dart';
import 'package:solar_system/business/money.dart';
import 'package:solar_system/business/panels.dart';
import 'package:solar_system/business/revenue.dart';
import 'package:solar_system/screens/game_screen.dart';
import 'package:solar_system/utils/builder.dart';
import 'package:solar_system/utils/ui_helpers.dart';

Widget hudBar() => listenTo(
  [index],
  (_) {
    final darkState = dark();
    final moneyState = money();
    final revenueRate = revenue.rate;
    final powerOut = panels.currentPowerOutput;
    final energy = battery.energy;
    final maxCap = battery.maximumCapacity;

    final batteryPercent = maxCap > 0 ? (energy / maxCap * 100) : 0.0;
    final batteryColor = batteryPercent > 20
        ? AppColors.iosGreen
        : AppColors.iosRed;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      color: darkState ? AppColors.cardDark : AppColors.iosGray6,
      child: Wrap(
        spacing: 16,
        runSpacing: 8,
        children: [
          IconValue(
            icon: CupertinoIcons.money_dollar_circle,
            value: '₨ ${moneyState.toStringAsFixed(0)}',
            iconColor: AppColors.iosOrange,
          ),
          IconValue(
            icon: CupertinoIcons.arrow_up_circle,
            value: '+${revenueRate.toStringAsFixed(1)}/s',
            iconColor: AppColors.iosGreen,
          ),
          IconValue(
            icon: CupertinoIcons.sun_max,
            value: '${powerOut.toStringAsFixed(0)}W',
            iconColor: AppColors.iosYellow,
          ),
          IconValue(
            icon: CupertinoIcons.battery_100,
            value: '${batteryPercent.toStringAsFixed(0)}%',
            iconColor: batteryColor,
          ),
        ],
      ),
    );
  },
);
