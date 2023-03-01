import 'package:flutter_bloc/flutter_bloc.dart';

import 'navigation_state.dart';

class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit({required int startingIndex})
      : super(NavigationState(currentIndex: startingIndex));

  void onNavItemTapped(context, int value) {
    emit(state.copyWith(currentIndex: value));
  }
}
