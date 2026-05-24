import 'package:flutter/material.dart';

/// NAVIGATION UTILITY

final navigatorKey = GlobalKey<NavigatorState>();
void navigateTo(WidgetBuilder builder) {
  navigatorKey.currentState?.push(
    MaterialPageRoute(builder: builder),
  );
}

void navigateToDialog(WidgetBuilder dialogBuilder) {
  final context = navigatorKey.currentContext;
  if (context != null) {
    showDialog(context: context, builder: dialogBuilder);
  }
}

void navigateBack() {
  navigatorKey.currentState?.pop();
}
