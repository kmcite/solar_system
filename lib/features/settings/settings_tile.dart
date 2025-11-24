import 'package:flutter/material.dart';

/// Reusable settings tile with loading and error handling
class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget trailing;
  final VoidCallback? onTap;
  final bool isLoading;
  final String? error;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.trailing,
    this.onTap,
    this.isLoading = false,
    this.error,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: Icon(icon),
            title: Text(title),
            subtitle: Text(subtitle),
            trailing: trailing,
            onTap: onTap,
          ),
          if (isLoading) const LinearProgressIndicator(),
          if (error != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                error!,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Reusable switch settings tile
class SwitchSettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool>? onChanged;
  final bool isLoading;
  final String? error;

  const SwitchSettingsTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    this.onChanged,
    this.isLoading = false,
    this.error,
  });

  @override
  Widget build(BuildContext context) {
    return SettingsTile(
      icon: icon,
      title: title,
      subtitle: subtitle,
      trailing: Switch(
        value: value,
        onChanged: onChanged,
      ),
      isLoading: isLoading,
      error: error,
    );
  }
}

/// Reusable dropdown settings tile
class DropdownSettingsTile<T> extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final T value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final bool isLoading;
  final String? error;

  const DropdownSettingsTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.items,
    this.onChanged,
    this.isLoading = false,
    this.error,
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
        onChanged: onChanged,
      ),
      isLoading: isLoading,
      error: error,
    );
  }
}

/// Reusable slider settings tile
class SliderSettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final double value;
  final double min;
  final double max;
  final int? divisions;
  final String Function(double)? valueFormatter;
  final ValueChanged<double>? onChanged;
  final bool isLoading;
  final String? error;

  const SliderSettingsTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.min,
    required this.max,
    this.divisions,
    this.valueFormatter,
    this.onChanged,
    this.isLoading = false,
    this.error,
  });

  @override
  Widget build(BuildContext context) {
    return SettingsTile(
      icon: icon,
      title: title,
      subtitle: subtitle,
      trailing: SizedBox(
        width: 150,
        child: Slider(
          value: value,
          min: min,
          max: max,
          divisions: divisions,
          label: valueFormatter?.call(value) ?? value.toString(),
          onChanged: onChanged,
        ),
      ),
      isLoading: isLoading,
      error: error,
    );
  }
}
