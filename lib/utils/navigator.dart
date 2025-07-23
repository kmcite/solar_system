import 'package:navigation_builder/navigation_builder.dart';
import 'package:signals_flutter/signals_core.dart' as core;
import 'package:signals_flutter/signals_flutter.dart';

import 'package:flutter/material.dart';

final navigator = NavigationBuilder.navigate;

extension DynamicExtensions on dynamic {
  Text text({
    Key? key,
    TextStyle? style,
    StrutStyle? strutStyle,
    TextAlign? textAlign,
    TextDirection? textDirection,
    Locale? locale,
    bool? softWrap,
    TextOverflow? overflow,
    double? textScaleFactor,
    TextScaler? textScaler,
    int? maxLines,
    String? semanticsLabel,
    TextWidthBasis? textWidthBasis,
    TextHeightBehavior? textHeightBehavior,
    Color? selectionColor,
  }) {
    return Text(
      toString(),
      key: key,
      style: style,
      strutStyle: strutStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      overflow: overflow,
      // ignore: deprecated_member_use
      textScaleFactor: textScaleFactor,
      textScaler: textScaler,
      maxLines: maxLines,
      semanticsLabel: semanticsLabel,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
      selectionColor: selectionColor,
    );
  }
}

extension WidgetExtensions on Widget {
  Padding pad({
    double? all,
    double? right,
    double? left,
    double? top,
    double? bottom,
    double? horizontal,
    double? vertical,
  }) {
    EdgeInsetsGeometry edgeInsets = EdgeInsets.zero;

    if (all != null) {
      edgeInsets = EdgeInsets.all(all);
    } else if (horizontal != null || vertical != null) {
      edgeInsets = EdgeInsets.symmetric(
        vertical: vertical ?? 0.0,
        horizontal: horizontal ?? 0.0,
      );
    } else if (right != null || left != null || top != null || bottom != null) {
      edgeInsets = EdgeInsets.only(
        left: left ?? 0.0,
        right: right ?? 0.0,
        top: top ?? 0.0,
        bottom: bottom ?? 0.0,
      );
    } else {
      edgeInsets = EdgeInsets.all(8.0);
    }

    return Padding(padding: edgeInsets, child: this);
  }

  Widget center() => Center(child: this);
  Card card({
    Key? key,
    Color? color,
    Color? shadowColor,
    Color? surfaceTintColor,
    double? elevation,
    ShapeBorder? shape,
    bool borderOnForeground = true,
    EdgeInsetsGeometry? margin,
    Clip? clipBehavior,
    bool semanticContainer = true,
  }) {
    return Card(
      key: key,
      color: color,
      shadowColor: shadowColor,
      surfaceTintColor: surfaceTintColor,
      elevation: elevation,
      shape: shape,
      borderOnForeground: borderOnForeground,
      margin: margin,
      clipBehavior: clipBehavior,
      semanticContainer: semanticContainer,
      child: this,
    );
  }
}

class GUI extends UI {
  const GUI(
    this.builder, {
    this.didMount,
    this.didUnmount,
    super.key,
    super.debugLabel,
    super.dependencies,
  });
  final Widget Function() builder;
  @override
  Widget build(BuildContext context) => builder();
  final void Function()? didMount;
  final void Function()? didUnmount;
  @override
  void initState() {
    super.initState();
    didMount?.call();
  }

  @override
  void dispose() {
    didUnmount?.call();
    super.dispose();
  }
}

abstract class UI<T extends Widget> extends StatefulWidget {
  const UI({
    super.key,
    this.debugLabel,
    this.dependencies = const [],
  });

  T build(BuildContext context);
  final String? debugLabel;
  final List<core.ReadonlySignal<dynamic>> dependencies;

  @override
  State<UI<T>> createState() => _WatchState<T>();

  void initState() {}

  void dispose() {}
}

class _WatchState<T extends Widget> extends State<UI<T>> with SignalsMixin {
  late final result = createComputed(() {
    return widget.build(context);
  }, debugLabel: widget.debugLabel);
  bool _init = true;

  @override
  void initState() {
    super.initState();
    for (final dep in widget.dependencies) {
      bindSignal(dep);
    }
    widget.initState();
  }

  @override
  void reassemble() {
    super.reassemble();
    final target = core.SignalsObserver.instance;
    if (target is core.DevToolsSignalsObserver) {
      target.reassemble();
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      result.recompute();
      if (mounted) setState(() {});
      result.value;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_init) {
      _init = false;
      return;
    }
    result.recompute();
  }

  @override
  void didUpdateWidget(covariant UI<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.dependencies != widget.dependencies) {
      for (final dep in oldWidget.dependencies) {
        final idx = widget.dependencies.indexOf(dep);
        if (idx == -1) unbindSignal(dep);
      }
      for (final dep in widget.dependencies) {
        bindSignal(dep);
      }
    } else if (oldWidget.build != widget.build) {
      result.recompute();
    }
  }

  @override
  Widget build(BuildContext context) {
    return result.value;
  }

  @override
  void dispose() {
    widget.dispose();
    super.dispose();
  }
}
