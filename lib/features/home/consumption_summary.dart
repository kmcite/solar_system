import 'package:flutter/material.dart';

/// Widget showing consumption summary for home devices
class ConsumptionSummary extends StatelessWidget {
  final double totalConsumption;
  final int activeDevices;
  final int totalDevices;

  const ConsumptionSummary({
    super.key,
    required this.totalConsumption,
    required this.activeDevices,
    required this.totalDevices,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Row(
              children: [
                Icon(
                  Icons.home,
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Overview',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Main consumption display
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Consumption',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.outline,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${totalConsumption.toStringAsFixed(0)}W',
                      style: theme.textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: _getConsumptionColor(theme, totalConsumption),
                      ),
                    ),
                  ],
                ),

                // Power indicator
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _getConsumptionColor(
                      theme,
                      totalConsumption,
                    ).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.electric_bolt,
                    size: 32,
                    color: _getConsumptionColor(theme, totalConsumption),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Device statistics
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    context,
                    'Active Devices',
                    '$activeDevices',
                    Icons.power_settings_new,
                    theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    context,
                    'Total Devices',
                    '$totalDevices',
                    Icons.devices,
                    theme.colorScheme.outline,
                  ),
                ),
              ],
            ),

            // Energy cost estimation (optional)
            if (totalConsumption > 0) ...[
              const SizedBox(height: 16),
              _buildEnergyEstimation(context, totalConsumption),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 4),
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnergyEstimation(BuildContext context, double consumptionW) {
    final theme = Theme.of(context);

    // Calculate estimated daily and monthly consumption
    const dailyHours = 8.0; // Assume 8 hours of usage per day
    const daysInMonth = 30.0;
    const ratePerKwh = 0.12; // $0.12 per kWh (example rate)

    final dailyKwh = (consumptionW * dailyHours) / 1000.0;
    final monthlyKwh = dailyKwh * daysInMonth;
    final dailyCost = dailyKwh * ratePerKwh;
    final monthlyCost = monthlyKwh * ratePerKwh;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Energy Estimation',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Daily: ${dailyKwh.toStringAsFixed(2)}kWh',
                      style: theme.textTheme.bodySmall,
                    ),
                    Text(
                      'Monthly: ${monthlyKwh.toStringAsFixed(1)}kWh',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Daily: \$${dailyCost.toStringAsFixed(2)}',
                      style: theme.textTheme.bodySmall,
                    ),
                    Text(
                      'Monthly: \$${monthlyCost.toStringAsFixed(1)}',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getConsumptionColor(ThemeData theme, double consumption) {
    if (consumption < 500) {
      return Colors.green; // Low consumption
    } else if (consumption < 1500) {
      return Colors.orange; // Medium consumption
    } else {
      return Colors.red; // High consumption
    }
  }
}
