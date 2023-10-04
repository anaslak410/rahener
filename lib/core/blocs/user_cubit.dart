import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rahener/core/models/user_model.dart';
import 'package:rahener/core/services/auth_service.dart';

import 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final AuthService _authService;

  UserCubit({required authService})
      : _authService = authService,
        super(const UserState(status: UserStatus.loading)) {
    _authService.authUpdates().listen((User? user) {
      if (user == null) {
        emit(state.copyWith(status: UserStatus.logged));
      } else {
        emit(state.copyWith(status: UserStatus.notLogged));
      }
    });
  }

  void signout() {
    _authService.signOut();
    // emit(state.copyWith(status: UserStatus.notLogged));
  }

  void abortAuthentication() {}
  // abort authentication

  // start authentication
}
