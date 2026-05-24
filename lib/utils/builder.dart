import 'package:flutter/material.dart';

Widget listenTo(
  List<Listenable> listenToMany,
  WidgetBuilder listener,
) {
  // For multiple listenables, combine them using Listenable.merge
  return ListenableBuilder(
    listenable: Listenable.merge(listenToMany),
    builder: (context, child) => listener(context),
  );
}
