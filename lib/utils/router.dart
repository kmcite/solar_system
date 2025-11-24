import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/dashboard/dashboard_screen.dart';
import '../features/home/home_screen.dart';
import '../features/settings/settings_screen.dart';

/// App router configuration using GoRouter
class AppRouter {
  static const String dashboard = '/dashboard';
  static const String home = '/home';
  static const String settings = '/settings';

  static final GoRouter router = GoRouter(
    initialLocation: dashboard,
    debugLogDiagnostics: true,
    routes: [
      // Dashboard Route
      GoRoute(
        path: dashboard,
        name: 'dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),

      // Home Devices Route
      GoRoute(
        path: home,
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),

      // Settings Route
      GoRoute(
        path: settings,
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],

    // Error handling for unknown routes
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(
        title: const Text('Page Not Found'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Page not found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'The requested page could not be found.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(dashboard),
              child: const Text('Go to Dashboard'),
            ),
          ],
        ),
      ),
    ),
  );

  // Navigation helpers
  static void goToDashboard(BuildContext context) {
    context.go(dashboard);
  }

  static void goToHome(BuildContext context) {
    context.go(home);
  }

  static void goToSettings(BuildContext context) {
    context.go(settings);
  }

  static void pushDashboard(BuildContext context) {
    context.push(dashboard);
  }

  static void pushHome(BuildContext context) {
    context.push(home);
  }

  static void pushSettings(BuildContext context) {
    context.push(settings);
  }
}

/// Extension methods for easier navigation
extension GoRouterContext on BuildContext {
  void goToDashboard() => AppRouter.goToDashboard(this);
  void goToHome() => AppRouter.goToHome(this);
  void goToSettings() => AppRouter.goToSettings(this);
  void pushDashboard() => AppRouter.pushDashboard(this);
  void pushHome() => AppRouter.pushHome(this);
  void pushSettings() => AppRouter.pushSettings(this);
  Future<T?> toDialog<T>(Widget dialog) {
    return showDialog(context: this, builder: (context) => dialog);
  }
}
