import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide TimeOfDay;

import 'package:solar_system/business/dark.dart';
import 'package:solar_system/business/navigator.dart';
import 'package:solar_system/screens/battery_section.dart';
import 'package:solar_system/screens/day_night_cycle_section.dart';
import 'package:solar_system/screens/hud_bar.dart';
import 'package:solar_system/screens/inverter_section.dart';
import 'package:solar_system/screens/inverter_upgrades_section.dart';
import 'package:solar_system/screens/loads_section.dart';
import 'package:solar_system/screens/settings_dialog.dart';
import 'package:solar_system/screens/solar_farm_section.dart';
import 'package:solar_system/screens/utility_section.dart';
import 'package:solar_system/utils/builder.dart';

Widget gameScreen() => listenTo(
  [],
  (_) {
    final darkState = dark.value;
    return Scaffold(
      appBar: AppBar(
        title: Text('SolarSystem'),
        actions: [
          IconButton(
            onPressed: () => dark.toggleDark(),
            icon: Icon(darkState ? Icons.dark_mode : Icons.light_mode),
          ),
          IconButton(
            onPressed: () => navigateToDialog((_) => SettingsDialog()),
            icon: const Icon(Icons.settings),
          ),
          SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            hudBar(),
            SizedBox(height: 16),
            DayNightCycleSection(),
            SizedBox(height: 16),
            InverterSection(),
            SizedBox(height: 16),
            InverterUpgradesSection(),
            SizedBox(height: 16),
            SolarFarmSection(),
            SizedBox(height: 16),
            batterySection(),
            SizedBox(height: 16),
            LoadsSection(),
            SizedBox(height: 16),
            utilitySection(),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  },
);

// ============================================================================
// ICON + VALUE WIDGET - Core pattern for iconic design
// ============================================================================
class IconValue extends StatelessWidget {
  final IconData icon;
  final String value;
  final Color? iconColor;

  const IconValue({
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
// CUSTOM CUPERTINO PROGRESS BAR
// ============================================================================
class CupertinoProgressBar extends StatelessWidget {
  final double value;
  final Color backgroundColor;
  final Color valueColor;

  const CupertinoProgressBar({
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
class CupertinoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const CupertinoChip({
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
class CupertinoActionChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const CupertinoActionChip({
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
