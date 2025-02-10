import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'battery_bloc.dart';

class BatteryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Battery Status'),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            EnergyProgressBar(
              value: batteryBloc.currentCapacity / batteryBloc.maximumCapacity,
              label: 'Battery Capacity',
              color: Colors.green,
            ),
            SizedBox(height: 20),
            StatusCard(
              icon: FontAwesomeIcons.batteryFull,
              title: 'Battery Status',
              status: batteryBloc.isPoweringLoads ? 'ON' : 'OFF',
              onToggle: batteryBloc.togglePower,
            ),
          ],
        ),
      ),
    );
  }
}

class StatusCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String status;
  final VoidCallback onToggle;

  const StatusCard({
    required this.icon,
    required this.title,
    required this.status,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            FaIcon(icon, size: 50, color: Colors.blue),
            SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              status,
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: onToggle,
              child: Text('Toggle Status'),
            ),
          ],
        ),
      ),
    );
  }
}

class EnergyProgressBar extends StatelessWidget {
  final double value;
  final String label;
  final Color color;

  const EnergyProgressBar({
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        LinearProgressIndicator(
          value: value,
          backgroundColor: Colors.grey[200],
          valueColor: AlwaysStoppedAnimation(color),
        ),
        SizedBox(height: 8),
        Text(
          '${(value * 100).toStringAsFixed(1)}%',
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
