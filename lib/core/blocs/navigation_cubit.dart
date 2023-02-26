import 'package:flutter_bloc/flutter_bloc.dart';

import 'navigation_state.dart';

class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit({required NavItems startingNavItem})
      : super(NavigationState(currentNavItem: startingNavItem));
}
