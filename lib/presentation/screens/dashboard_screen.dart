import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/power_initializer_provider.dart';
import '../widgets/dashboard/dashboard_layout.dart';
import '../widgets/app_bar/custom_app_bar.dart';
import '../widgets/bottom_navigation/bottom_action_bar.dart';

/// Main dashboard screen
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize the power management system
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PowerInitializerProvider>().initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: const DashboardLayout(),
      bottomNavigationBar: const BottomActionBar(),
    );
  }
}
