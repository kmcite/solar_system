import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';

class Observer extends BlocObserver {
  @override
  void onEvent(Bloc<dynamic, dynamic> bloc, Object? event) {
    super.onEvent(bloc, event);
    log(event.runtimeType.toString(), name: bloc.runtimeType.toString());
  }
}
