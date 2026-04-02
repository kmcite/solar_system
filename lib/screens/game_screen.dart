import 'package:flutter/cupertino.dart';
import 'package:signals_flutter/signals_flutter.dart';

import 'package:solar_system/business/app.dart';
import 'package:solar_system/business/battery.dart';
import 'package:solar_system/business/battery_upgrades.dart';
import 'package:solar_system/business/inverter.dart';
import 'package:solar_system/business/inverter_upgrades.dart';
import 'package:solar_system/business/loads.dart';
import 'package:solar_system/business/panels.dart';
import 'package:solar_system/business/radiation.dart';
import 'package:solar_system/business/revenue.dart';
import 'package:solar_system/business/utility.dart';
import 'package:solar_system/domain/models/models.dart';
import 'package:solar_system/utils/ui_helpers.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = CupertinoTheme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Solar Tycoon'),
        backgroundColor: isDark
            ? AppColors.iosDarkBackground
            : AppColors.iosLightBackground,
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => _showSettingsDialog(context),
          child: const Icon(CupertinoIcons.settings, size: 24),
        ),
      ),
      backgroundColor: isDark
          ? AppColors.iosDarkBackground
          : AppColors.iosLightBackground,
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: const [
            _HudBar(),
            SizedBox(height: 16),
            _DayNightCycleSection(),
            SizedBox(height: 16),
            _InverterSection(),
            SizedBox(height: 16),
            _SolarFarmSection(),
            SizedBox(height: 16),
            _BatterySection(),
            SizedBox(height: 16),
            _LoadsSection(),
            SizedBox(height: 16),
            _InverterUpgradesSection(),
            SizedBox(height: 16),
            _UtilitySection(),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showSettingsDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (dialogContext) => const _SettingsDialog(),
    );
  }
}

// ============================================================================
// ICON + VALUE WIDGET - Core pattern for iconic design
// ============================================================================
class _IconValue extends StatelessWidget {
  final IconData icon;
  final String value;
  final Color? iconColor;

  const _IconValue({
    required this.icon,
    required this.value,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: iconColor),
        const SizedBox(width: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}

// ============================================================================
// HUD BAR - Row of icon+value pairs
// ============================================================================
class _HudBar extends StatelessWidget {
  const _HudBar();

  @override
  Widget build(BuildContext context) {
    return Watch((context) {
      final theme = CupertinoTheme.of(context);
      final isDark = theme.brightness == Brightness.dark;
      final moneyVal = money.value;
      final revenueVal = currentRevenuePerSecond.value;
      final powerOut = currentPowerOutput.value;
      final energyVal = energyInWattHours.value;
      final maxCap = maxCapacity.value;

      final batteryPercent = maxCap > 0 ? (energyVal / maxCap * 100) : 0.0;
      final batteryColor = batteryPercent > 20
          ? AppColors.iosGreen
          : AppColors.iosRed;

      return Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        color: isDark ? AppColors.cardDark : AppColors.iosGray6,
        child: Wrap(
          spacing: 16,
          runSpacing: 8,
          children: [
            _IconValue(
              icon: CupertinoIcons.money_dollar_circle,
              value: '₨${moneyVal.toStringAsFixed(0)}',
              iconColor: AppColors.iosOrange,
            ),
            _IconValue(
              icon: CupertinoIcons.arrow_up_circle,
              value: '+${revenueVal.toStringAsFixed(1)}/s',
              iconColor: AppColors.iosGreen,
            ),
            _IconValue(
              icon: CupertinoIcons.sun_max,
              value: '${powerOut.toStringAsFixed(0)}W',
              iconColor: AppColors.iosYellow,
            ),
            _IconValue(
              icon: CupertinoIcons.battery_100,
              value: '${batteryPercent.toStringAsFixed(0)}%',
              iconColor: batteryColor,
            ),
          ],
        ),
      );
    });
  }
}

// ============================================================================
// DAY/NIGHT CYCLE SECTION
// ============================================================================
class _DayNightCycleSection extends StatelessWidget {
  const _DayNightCycleSection();

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

      return Container(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                _IconValue(
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
            _CupertinoProgressBar(
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
      );
    });
  }
}

// ============================================================================
// INVERTER SECTION - Large icon with toggle
// ============================================================================
class _InverterSection extends StatelessWidget {
  const _InverterSection();

  @override
  Widget build(BuildContext context) {
    return Watch((context) {
      final isOn = inverterStatus.value;
      final currentUpgrade = currentInverterUpgrade.value;

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          children: [
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
                _IconValue(
                  icon: CupertinoIcons.bolt,
                  value: '${currentUpgrade.watt.toStringAsFixed(0)}W',
                  iconColor: AppColors.iosOrange,
                ),
                const SizedBox(width: 16),
                _IconValue(
                  icon: CupertinoIcons.square_grid_2x2,
                  value: currentUpgrade.tier.label,
                  iconColor: AppColors.iosTeal,
                ),
                const SizedBox(width: 16),
                _IconValue(
                  icon: CupertinoIcons.gauge,
                  value:
                      '${(currentUpgrade.tier.efficiency * 100).toStringAsFixed(0)}%',
                  iconColor: AppColors.iosGreen,
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}

// ============================================================================
// SOLAR FARM SECTION
// ============================================================================
class _SolarFarmSection extends StatelessWidget {
  const _SolarFarmSection();

  @override
  Widget build(BuildContext context) {
    return Watch((context) {
      final panelsList = panels.value;
      final radiationVal = radiation.value;
      final moneyVal = money.value;
      final powerOut = currentPowerOutput.value;
      final maxCap = currentMaxCapacity.value;

      final radiationPercent = (radiationVal * 100).clamp(0.0, 100.0);
      final canBuyPanel = moneyVal >= 1000;

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                      child: _CupertinoProgressBar(
                        value: radiationPercent / 100,
                        backgroundColor: CupertinoColors.systemGrey5,
                        valueColor: CupertinoColors.systemOrange,
                      ),
                    ),
                  ],
                ),
                _IconValue(
                  icon: CupertinoIcons.sun_max_fill,
                  value:
                      '${powerOut.toStringAsFixed(0)}/${maxCap.toStringAsFixed(0)}W',
                  iconColor: CupertinoColors.systemYellow,
                ),
                _IconValue(
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
                  return _CupertinoChip(
                    icon: CupertinoIcons.sun_max_fill,
                    label: '#${panel.id}',
                    isSelected: panel.status,
                    onTap: () => togglePanelActivation(panel),
                  );
                }).toList(),
              ),
            ],
            const SizedBox(height: 8),
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: canBuyPanel
                  ? () {
                      createPanel();
                      debitMoney(1000);
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
      );
    });
  }
}

// ============================================================================
// BATTERY SECTION
// ============================================================================
class _BatterySection extends StatelessWidget {
  const _BatterySection();

  @override
  Widget build(BuildContext context) {
    return Watch((context) {
      final energyVal = energyInWattHours.value;
      final maxCap = maxCapacity.value;
      final chargingVal = isCharging.value;
      final tierNameVal = tierName.value;
      final currentUpgrade = currentBatteryUpgrade.value;
      final nextUpgrade = nextBatteryUpgrade.value;
      final moneyVal = money.value;

      final batteryPercent = maxCap > 0 ? (energyVal / maxCap * 100) : 0.0;
      final canUpgrade = nextUpgrade != null && moneyVal >= nextUpgrade.cost;

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

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                  child: _CupertinoProgressBar(
                    value: batteryPercent / 100,
                    backgroundColor: CupertinoColors.systemGrey5,
                    valueColor: batteryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Stats row
            Row(
              children: [
                _IconValue(
                  icon: CupertinoIcons.tag,
                  value: tierNameVal,
                  iconColor: CupertinoColors.systemTeal,
                ),
                const SizedBox(width: 12),
                _IconValue(
                  icon: CupertinoIcons.bolt,
                  value: '${currentUpgrade.voltage.toStringAsFixed(0)}V',
                  iconColor: CupertinoColors.systemYellow,
                ),
                const SizedBox(width: 12),
                _IconValue(
                  icon: CupertinoIcons.cube_box,
                  value: '${currentUpgrade.capacityWh.toStringAsFixed(0)}Wh',
                  iconColor: CupertinoColors.systemOrange,
                ),
                const SizedBox(width: 12),
                _IconValue(
                  icon: CupertinoIcons.gauge,
                  value:
                      '${(currentUpgrade.efficiency * 100).toStringAsFixed(0)}%',
                  iconColor: CupertinoColors.systemGreen,
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
                            debitMoney(nextUpgrade.cost.toDouble());
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
      );
    });
  }
}

// ============================================================================
// LOADS SECTION
// ============================================================================
class _LoadsSection extends StatelessWidget {
  const _LoadsSection();

  @override
  Widget build(BuildContext context) {
    return Watch((context) {
      final loadsList = loads.value;
      final powerOut = currentPowerOutput.value;
      final moneyVal = money.value;
      final activeLoadsVal = totalActiveLoads.value;
      final activeRevenueVal = totalActiveRevenue.value;

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Balance row
            Wrap(
              spacing: 8,
              runSpacing: 4,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                _IconValue(
                  icon: CupertinoIcons.sun_max_fill,
                  value: '${powerOut.toStringAsFixed(0)}W',
                  iconColor: CupertinoColors.systemYellow,
                ),
                Icon(
                  CupertinoIcons.arrow_right,
                  size: 14,
                  color: CupertinoColors.systemGrey,
                ),
                _IconValue(
                  icon: CupertinoIcons.bolt_fill,
                  value: '${activeLoadsVal.toStringAsFixed(0)}W',
                  iconColor: CupertinoColors.systemTeal,
                ),
                Text('|', style: TextStyle(color: CupertinoColors.systemGrey)),
                _IconValue(
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
                  return _CupertinoChip(
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
                final canBuy = moneyVal >= loadType.cost;
                return _CupertinoActionChip(
                  icon: CupertinoIcons.lightbulb,
                  label:
                      '${loadType.wattage.toStringAsFixed(0)}W ₨${loadType.cost.toStringAsFixed(0)}',
                  onTap: canBuy
                      ? () {
                          purchaseLoad(loadType.id);
                          debitMoney(loadType.cost);
                        }
                      : null,
                );
              }).toList(),
            ),
          ],
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

// ============================================================================
// INVERTER UPGRADES SECTION
// ============================================================================
class _InverterUpgradesSection extends StatelessWidget {
  const _InverterUpgradesSection();

  @override
  Widget build(BuildContext context) {
    return Watch((context) {
      final current = currentInverterUpgrade.value;
      final nextUpgrade = nextInverterUpgrade.value;
      final moneyVal = money.value;
      final canUpgrade = nextUpgrade != null && moneyVal >= nextUpgrade.cost;

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Icon(
              CupertinoIcons.bolt,
              size: 20,
              color: CupertinoColors.systemYellow,
            ),
            const SizedBox(width: 8),
            Text(
              '${current.watt.toStringAsFixed(0)}W ${current.tier.label}',
              style: const TextStyle(fontSize: 12),
            ),
            if (nextUpgrade != null) ...[
              const SizedBox(width: 8),
              Icon(
                CupertinoIcons.arrow_right,
                size: 14,
                color: CupertinoColors.systemGrey,
              ),
              const SizedBox(width: 8),
              Text(
                '${nextUpgrade.watt.toStringAsFixed(0)}W ${nextUpgrade.tier.label}',
                style: TextStyle(
                  fontSize: 12,
                  color: CupertinoColors.systemGreen,
                ),
              ),
              const Spacer(),
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: canUpgrade
                    ? () {
                        purchaseInverterUpgrade(nextUpgrade.id);
                        debitMoney(nextUpgrade.cost.toDouble());
                      }
                    : null,
                child: Text('₨${nextUpgrade.cost}'),
              ),
            ] else ...[
              const Spacer(),
              Text(
                'MAX',
                style: TextStyle(
                  fontSize: 12,
                  color: CupertinoColors.systemGreen,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      );
    });
  }
}

// ============================================================================
// UTILITY SECTION
// ============================================================================
class _UtilitySection extends StatelessWidget {
  const _UtilitySection();

  static const _presetAmounts = [10.0, 50.0, 100.0, 500.0];

  @override
  Widget build(BuildContext context) {
    return Watch((context) {
      final isActive = utilityStatus.value;
      final moneyVal = money.value;
      final remainingSeconds = utilityRemainingSeconds.value;
      final power = utilityPower.value;

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status row
            Row(
              children: [
                Icon(
                  CupertinoIcons.power,
                  size: 20,
                  color: isActive
                      ? CupertinoColors.systemGreen
                      : CupertinoColors.systemRed,
                ),
                const SizedBox(width: 8),
                Text(
                  isActive ? 'Connected' : 'Disconnected',
                  style: TextStyle(
                    fontSize: 12,
                    color: isActive
                        ? CupertinoColors.systemGreen
                        : CupertinoColors.systemRed,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (isActive) ...[
                  const SizedBox(width: 8),
                  _IconValue(
                    icon: CupertinoIcons.time,
                    value: '${remainingSeconds}s',
                    iconColor: CupertinoColors.systemTeal,
                  ),
                  const SizedBox(width: 8),
                  _IconValue(
                    icon: CupertinoIcons.bolt,
                    value: '${power.toStringAsFixed(0)}W',
                    iconColor: CupertinoColors.systemYellow,
                  ),
                ],
              ],
            ),
            const SizedBox(height: 8),
            // Buy buttons
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: _presetAmounts.map((amount) {
                final canBuy = moneyVal >= amount;
                return CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: canBuy
                      ? () {
                          purchaseUtility(amount);
                          debitMoney(amount);
                        }
                      : null,
                  child: Text('+${amount.toStringAsFixed(0)}₨'),
                );
              }).toList(),
            ),
          ],
        ),
      );
    });
  }
}

// ============================================================================
// SETTINGS DIALOG
// ============================================================================
class _SettingsDialog extends StatelessWidget {
  const _SettingsDialog();

  @override
  Widget build(BuildContext context) {
    return Watch((context) {
      final dark = darkMode.value;
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
                    value: dark,
                    onChanged: (_) => toggleDarkMode(),
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
              _CupertinoProgressBar(
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

// ============================================================================
// CUSTOM CUPERTINO PROGRESS BAR
// ============================================================================
class _CupertinoProgressBar extends StatelessWidget {
  final double value;
  final Color backgroundColor;
  final Color valueColor;

  const _CupertinoProgressBar({
    required this.value,
    required this.backgroundColor,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 6,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(3),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: value.clamp(0.0, 1.0),
        child: Container(
          decoration: BoxDecoration(
            color: valueColor,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// CUSTOM CUPERTINO CHIP
// ============================================================================
class _CupertinoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _CupertinoChip({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected
              ? CupertinoColors.systemBlue.withValues(alpha: 0.2)
              : CupertinoColors.systemGrey5,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? CupertinoColors.systemBlue
                : CupertinoColors.systemGrey3,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: isSelected
                  ? CupertinoColors.systemBlue
                  : CupertinoColors.systemGrey,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: isSelected
                    ? CupertinoColors.systemBlue
                    : CupertinoColors.label,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// CUSTOM CUPERTINO ACTION CHIP
// ============================================================================
class _CupertinoActionChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _CupertinoActionChip({
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: onTap != null
              ? CupertinoColors.systemBlue.withValues(alpha: 0.1)
              : CupertinoColors.systemGrey5,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: onTap != null
                  ? CupertinoColors.systemBlue
                  : CupertinoColors.systemGrey,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: onTap != null
                    ? CupertinoColors.systemBlue
                    : CupertinoColors.systemGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
