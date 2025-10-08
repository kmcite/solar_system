import 'package:solar_system/main.dart';
import 'package:solar_system/utils/bloc/bloc.dart';

class Locator {
  final services = <Type, Object>{};
  final repositories = <Type, Repository>{};

  void repository<R extends Repository>(R repository) {
    repositories[R] = repository;
  }

  void service<S extends Object>(S service) {
    services[S] = service;
  }

  R find<R extends Repository>() {
    final repository = repositories[R];
    if (repository == null) {
      throw ('Repository $R not found.');
    }
    return repository as R;
  }

  S serve<S extends Object>() {
    final service = services[S];
    if (service == null) {
      throw 'Service $S not found.';
    }
    return service as S;
  }

  /// TRANSITIVE BLOC MANAGEMENT
  void putBloc<B extends BlocBase>(B bloc) {
    blocs[bloc.runtimeType] = bloc;
  }

  void removeBloc<B extends BlocBase>() {
    blocs.remove(B);
  }

  B findBloc<B extends BlocBase>() {
    final bloc = blocs[B];
    if (bloc == null) {
      print('Bloc not found $B');
    }
    return bloc as B;
  }

  final blocs = <Type, BlocBase>{};
}

final locator = Locator();

final repository = locator.repository;
final service = locator.service;
