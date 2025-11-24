import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:manager/manager.dart';
import 'package:solar_system/domain/entities/home_device.dart';
import 'package:solar_system/domain/repositories/home_repository.dart';
import 'package:solar_system/features/bottom_navigation/reset_system_dialog.dart';
import '../../utils/router.dart';

class BottomActionBarProvider extends ChangeNotifier {
  late final IHomeRepository _homeRepository = find();
  StreamSubscription<HomeDevices>? _subscription;

  BottomActionBarProvider() {
    _subscription = _homeRepository.watchHomeDevices().listen((event) {
      totalConsumption = event.totalConsumption;
      notifyListeners();
    });
  }

  late double totalConsumption = 0.0;

  void resetDevices() {
    totalConsumption = 0;
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

class BottomActionBar extends StatelessWidget {
  const BottomActionBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Feature(
      created: () => BottomActionBarProvider(),
      builder: (_, provider) {
        final currentRoute = GoRouterState.of(context).matchedLocation;

        return BottomAppBar(
          child: Row(
            children: [
              IconButton(
                onPressed: currentRoute == AppRouter.dashboard
                    ? null
                    : () => context.goToDashboard(),
                icon: const Icon(Icons.dashboard),
                tooltip: 'Dashboard',
                color: currentRoute == AppRouter.dashboard
                    ? Theme.of(context).colorScheme.primary
                    : null,
              ),
              IconButton(
                onPressed: currentRoute == AppRouter.home
                    ? null
                    : () => context.goToHome(),
                icon: const Icon(Icons.home),
                tooltip: 'Home Devices',
                color: currentRoute == AppRouter.home
                    ? Theme.of(context).colorScheme.primary
                    : null,
              ),
              IconButton(
                onPressed: currentRoute == AppRouter.settings
                    ? null
                    : () => context.goToSettings(),
                icon: const Icon(Icons.settings),
                tooltip: 'Settings',
                color: currentRoute == AppRouter.settings
                    ? Theme.of(context).colorScheme.primary
                    : null,
              ),
              const Spacer(),
              AnimatedBuilder(
                animation: provider,
                builder: (context, child) {
                  final totalConsumption = provider.totalConsumption;
                  return Text(
                    '${totalConsumption.toStringAsFixed(0)}w',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  );
                },
              ),
              const Spacer(),
              IconButton(
                onPressed: () {
                  // Reset system
                  context.toDialog(ResetSystemDialog());
                },
                icon: const Icon(Icons.refresh),
                tooltip: 'Reset System',
              ),
            ],
          ),
        );
      },
    );
  }
}
