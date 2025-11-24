import 'package:flutter/material.dart';

/// Reusable settings tile widget
class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget trailing;
  final VoidCallback? onTap;
  final bool enabled;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    required this.trailing,
    this.onTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1.0 : 0.5,
      child: ListTile(
        leading: Icon(
          icon,
          color: enabled ? Theme.of(context).colorScheme.primary : Colors.grey,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: enabled ? null : Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle!,
                style: TextStyle(
                  color: enabled ? Colors.grey.shade600 : Colors.grey,
                ),
              )
            : null,
        trailing: trailing,
        onTap: enabled ? onTap : null,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
    );
  }
}

/// Settings tile with switch
class SettingsSwitchTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool>? onChanged;
  final bool enabled;

  const SettingsSwitchTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    required this.value,
    this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return SettingsTile(
      icon: icon,
      title: title,
      subtitle: subtitle,
      trailing: Switch(
        value: value,
        onChanged: enabled ? onChanged : null,
      ),
      enabled: enabled,
    );
  }
}

/// Settings tile with dropdown
class SettingsDropdownTile<T> extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final T value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final bool enabled;

  const SettingsDropdownTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    required this.value,
    required this.items,
    this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return SettingsTile(
      icon: icon,
      title: title,
      subtitle: subtitle,
      trailing: DropdownButton<T>(
        value: value,
        items: items,
        onChanged: enabled ? onChanged : null,
        underline: const SizedBox(),
        isDense: true,
      ),
      enabled: enabled,
    );
  }
}

/// Settings tile with slider
class SettingsSliderTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final ValueChanged<double>? onChanged;
  final String Function(double)? valueFormatter;
  final bool enabled;

  const SettingsSliderTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.min,
    required this.max,
    this.divisions = 10,
    this.onChanged,
    this.valueFormatter,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: enabled
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: enabled ? null : Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: enabled ? Colors.grey.shade600 : Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                valueFormatter?.call(value) ?? value.toStringAsFixed(1),
                style: TextStyle(
                  color: enabled
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            onChanged: enabled ? onChanged : null,
          ),
        ],
      ),
    );
  }
}
