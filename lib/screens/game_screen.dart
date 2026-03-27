import 'package:flutter/material.dart';
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

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Solar Tycoon'),
      ),
      floatingActionButton: FloatingActionButton.small(
        onPressed: () => _showSettingsDialog(context),
        child: const Icon(Icons.settings, size: 20),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: const [
          _HudBar(),
          Divider(),
          _InverterSection(),
          Divider(),
          _SolarFarmSection(),
          Divider(),
          _BatterySection(),
          Divider(),
          _LoadsSection(),
          Divider(),
          _InverterUpgradesSection(),
          Divider(),
          _UtilitySection(),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  void _showSettingsDialog(BuildContext context) {
    showDialog(
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
          style: Theme.of(context).textTheme.bodySmall,
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
      final moneyVal = money.value;
      final revenueVal = currentRevenuePerSecond.value;
      final powerOut = currentPowerOutput.value;
      final energyVal = energyInWattHours.value;
      final maxCap = maxCapacity.value;

      final batteryPercent = maxCap > 0 ? (energyVal / maxCap * 100) : 0.0;
      final batteryColor = batteryPercent > 20 ? Colors.green : Colors.red;

      return Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: Wrap(
          spacing: 16,
          runSpacing: 8,
          children: [
            _IconValue(
              icon: Icons.account_balance_wallet,
              value: '₨${moneyVal.toStringAsFixed(0)}',
              iconColor: Colors.amber,
            ),
            _IconValue(
              icon: Icons.trending_up,
              value: '+${revenueVal.toStringAsFixed(1)}/s',
              iconColor: Colors.green,
            ),
            _IconValue(
              icon: Icons.wb_sunny,
              value: '${powerOut.toStringAsFixed(0)}W',
              iconColor: Colors.orange,
            ),
            _IconValue(
              icon: Icons.battery_std,
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
            InkWell(
              onTap: () => toggleInverter(),
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Icon(
                      Icons.power,
                      size: 32,
                      color: isOn ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      isOn ? 'ON' : 'OFF',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isOn ? Colors.green : Colors.red,
                      ),
                    ),
                    const Spacer(),
                    Switch(
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
                  icon: Icons.bolt,
                  value: '${currentUpgrade.watt.toStringAsFixed(0)}W',
                  iconColor: Colors.amber,
                ),
                const SizedBox(width: 16),
                _IconValue(
                  icon: Icons.electrical_services,
                  value: currentUpgrade.tier.label,
                  iconColor: Colors.cyan,
                ),
                const SizedBox(width: 16),
                _IconValue(
                  icon: Icons.speed,
                  value:
                      '${(currentUpgrade.tier.efficiency * 100).toStringAsFixed(0)}%',
                  iconColor: Colors.green,
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
                    Icon(Icons.wb_sunny, size: 16, color: Colors.orange),
                    const SizedBox(width: 4),
                    Text(
                      '${radiationPercent.toStringAsFixed(0)}%',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(width: 4),
                    SizedBox(
                      width: 40,
                      child: LinearProgressIndicator(
                        value: radiationPercent / 100,
                        backgroundColor: Colors.grey.shade300,
                      ),
                    ),
                  ],
                ),
                _IconValue(
                  icon: Icons.solar_power,
                  value:
                      '${powerOut.toStringAsFixed(0)}/${maxCap.toStringAsFixed(0)}W',
                  iconColor: Colors.amber,
                ),
                _IconValue(
                  icon: Icons.grid_view,
                  value: '${panelsList.length}',
                  iconColor: Colors.cyan,
                ),
              ],
            ),
            if (panelsList.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 4,
                runSpacing: 4,
                children: panelsList.map((panel) {
                  return FilterChip(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                    avatar: Icon(
                      Icons.solar_power,
                      size: 14,
                      color: panel.status ? Colors.amber : Colors.grey,
                    ),
                    label: Text(
                      '#${panel.id}',
                      style: const TextStyle(fontSize: 11),
                    ),
                    selected: panel.status,
                    onSelected: (_) => togglePanelActivation(panel),
                  );
                }).toList(),
              ),
            ],
            const SizedBox(height: 8),
            TextButton.icon(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              onPressed: canBuyPanel
                  ? () {
                      createPanel();
                      debitMoney(1000);
                    }
                  : null,
              icon: const Icon(Icons.add_circle, size: 16),
              label: const Text('₨1,000'),
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
          ? Colors.green
          : batteryPercent > 20
          ? Colors.amber
          : Colors.red;
      final batteryIcon = chargingVal
          ? Icons.battery_charging_full
          : batteryPercent > 50
          ? Icons.battery_std
          : Icons.battery_alert;

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
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: batteryColor,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: LinearProgressIndicator(
                    value: batteryPercent / 100,
                    backgroundColor: Colors.grey.shade300,
                    color: batteryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Stats row
            Row(
              children: [
                _IconValue(
                  icon: Icons.label,
                  value: tierNameVal,
                  iconColor: Colors.cyan,
                ),
                const SizedBox(width: 12),
                _IconValue(
                  icon: Icons.bolt,
                  value: '${currentUpgrade.voltage.toStringAsFixed(0)}V',
                  iconColor: Colors.amber,
                ),
                const SizedBox(width: 12),
                _IconValue(
                  icon: Icons.storage,
                  value: '${currentUpgrade.capacityWh.toStringAsFixed(0)}Wh',
                  iconColor: Colors.orange,
                ),
                const SizedBox(width: 12),
                _IconValue(
                  icon: Icons.speed,
                  value:
                      '${(currentUpgrade.efficiency * 100).toStringAsFixed(0)}%',
                  iconColor: Colors.green,
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Upgrade row
            Row(
              children: [
                Icon(Icons.upgrade, size: 16, color: Colors.purple),
                const SizedBox(width: 4),
                if (nextUpgrade != null) ...[
                  Text(
                    nextUpgrade.name,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
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
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
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
                  icon: Icons.solar_power,
                  value: '${powerOut.toStringAsFixed(0)}W',
                  iconColor: Colors.amber,
                ),
                Icon(Icons.arrow_forward, size: 14, color: Colors.grey),
                _IconValue(
                  icon: Icons.electrical_services,
                  value: '${activeLoadsVal.toStringAsFixed(0)}W',
                  iconColor: Colors.cyan,
                ),
                Text('|', style: TextStyle(color: Colors.grey)),
                _IconValue(
                  icon: Icons.attach_money,
                  value: '+${activeRevenueVal.toStringAsFixed(1)}₨/s',
                  iconColor: Colors.green,
                ),
              ],
            ),
            if (loadsList.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 4,
                runSpacing: 4,
                children: loadsList.map((load) {
                  return FilterChip(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                    avatar: Icon(
                      _getLoadIcon(load.name),
                      size: 14,
                      color: load.isActive ? Colors.green : Colors.grey,
                    ),
                    label: Text(
                      '${load.load.toStringAsFixed(0)}W',
                      style: const TextStyle(fontSize: 11),
                    ),
                    selected: load.isActive,
                    onSelected: (_) => toggleLoad(load.id),
                  );
                }).toList(),
              ),
            ],
            const SizedBox(height: 8),
            // Marketplace
            Row(
              children: [
                Icon(Icons.shopping_cart, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  'Buy:',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ),
            const SizedBox(height: 4),
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: loadTypeCatalog.values.map((loadType) {
                final canBuy = moneyVal >= loadType.cost;
                return ActionChip(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                  avatar: Icon(
                    IconData(
                      loadType.iconCodePoint,
                      fontFamily: 'MaterialIcons',
                    ),
                    size: 14,
                  ),
                  label: Text(
                    '${loadType.wattage.toStringAsFixed(0)}W ₨${loadType.cost.toStringAsFixed(0)}',
                    style: const TextStyle(fontSize: 11),
                  ),
                  onPressed: canBuy
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
      return Icons.lightbulb;
    } else if (lowerName.contains('iron')) {
      return Icons.iron;
    } else if (lowerName.contains('wash') || lowerName.contains('laundry')) {
      return Icons.local_laundry_service;
    } else if (lowerName.contains('sew') || lowerName.contains('machine')) {
      return Icons.precision_manufacturing;
    }
    return Icons.electrical_services;
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
            Icon(Icons.bolt, size: 20, color: Colors.amber),
            const SizedBox(width: 8),
            Text(
              '${current.watt.toStringAsFixed(0)}W ${current.tier.label}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            if (nextUpgrade != null) ...[
              const SizedBox(width: 8),
              Icon(Icons.arrow_forward, size: 14, color: Colors.grey),
              const SizedBox(width: 8),
              Text(
                '${nextUpgrade.watt.toStringAsFixed(0)}W ${nextUpgrade.tier.label}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.green,
                ),
              ),
              const Spacer(),
              TextButton(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
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
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
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
                  Icons.power_input,
                  size: 20,
                  color: isActive ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 8),
                Text(
                  isActive ? 'Connected' : 'Disconnected',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isActive ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (isActive) ...[
                  const SizedBox(width: 8),
                  _IconValue(
                    icon: Icons.timer,
                    value: '${remainingSeconds}s',
                    iconColor: Colors.cyan,
                  ),
                  const SizedBox(width: 8),
                  _IconValue(
                    icon: Icons.bolt,
                    value: '${power.toStringAsFixed(0)}W',
                    iconColor: Colors.amber,
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
                return TextButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
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

      return AlertDialog(
        title: const Text('Settings'),
        content: SizedBox(
          width: 280,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SwitchListTile(
                dense: true,
                title: const Text('Dark Mode'),
                value: dark,
                onChanged: (_) => toggleDarkMode(),
              ),
              const Divider(),
              ListTile(
                dense: true,
                title: const Text('Cycle Duration'),
                trailing: Text('${cycleDur}s'),
              ),
              Slider(
                value: cycleDur.toDouble(),
                min: 10,
                max: 300,
                divisions: 29,
                label: '${cycleDur}s',
                onChanged: (value) {
                  configureRadiationCycle(value.toInt());
                },
              ),
              const Divider(),
              ListTile(
                dense: true,
                leading: Icon(isDay ? Icons.wb_sunny : Icons.nightlight_round),
                title: Text(isDay ? 'Day' : 'Night'),
                trailing: Text('${cyclePos}s / ${cycleDur}s'),
              ),
              LinearProgressIndicator(
                value: cyclePos / cycleDur,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      );
    });
  }
}
