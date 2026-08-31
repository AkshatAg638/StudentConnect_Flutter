import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studentconnect/bloc/bottomNavBarBloc/events.dart';
import 'package:studentconnect/bloc/bottomNavBarBloc/states.dart';

class NavBarBloc extends Bloc<NavBarEvents, NavBarStates> {
  NavBarBloc() : super(pageNavigate(index: 0)) {
    on<currentPage>((event, emit) {
      emit(pageNavigate(index: event.index));
    });
  }
}
