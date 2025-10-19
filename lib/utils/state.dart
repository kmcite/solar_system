// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:solar_system/main.dart';
// import 'package:solar_system/utils/bloc/bloc.dart';

// abstract class Feature<B extends BlocBase> extends StatefulWidget {
//   const Feature({Key? key}) : super(key: key);

//   B create();
//   B get controller => locator.findBloc<B>();

//   Widget build(BuildContext context, B controller);

//   @override
//   State<Feature<B>> createState() => _FeatureState<B>();
// }

// class _FeatureState<B extends BlocBase> extends State<Feature<B>> {
//   late final B _bloc;
//   StreamSubscription? _subscription;

//   @override
//   void initState() {
//     super.initState();
//     _bloc = widget.create();
//     _subscription = _bloc.stream.listen((_) => notfiy());
//     locator.putBloc(_bloc);
//     _bloc.initState().then((_) => notfiy());
//   }

//   void notfiy() {
//     if (!mounted) return;
//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     return widget.build(context, _bloc);
//   }

//   @override
//   void dispose() {
//     _subscription?.cancel();
//     _subscription = null;
//     locator.removeBloc<B>();
//     super.dispose();
//   }
// }

// // mixin _State<W extends material.StatefulWidget> on material.State<W> {
// //   /// keep one subscription per repo instance
// //   final _subscriptions = <StreamSubscription>{};

// //   /// Watch a repository and trigger setState on changes.
// //   /// If `callImmediately` is true, `update()` is invoked right away.
// //   T watch<T extends Repository>({bool callImmediately = true}) {
// //     final instance = locator.find<T>();

// //     // only subscribe once per repo instance
// //     _subscriptions.add(() {
// //       final sub = instance.changes.listen(
// //         (_) {
// //           notfiy();
// //         },
// //         onError: (e, st) {
// //           // let repository handle/log errors; still update UI optionally
// //           notfiy();
// //         },
// //       );
// //       // immediate update if requested
// //       if (callImmediately) notfiy();
// //       return sub;
// //     }());
// //     return instance;
// //   }

// //   /// Force UI update with optional message/debug
// //   void notfiy([Object? message]) {
// //     if (!mounted) return;
// //     setState(() {});
// //   }

// //   @override
// //   void dispose() {
// //     for (final sub in _subscriptions) {
// //       sub.cancel();
// //     }
// //     _subscriptions.clear();
// //     super.dispose();
// //   }
// // }
