import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rahener/core/services/auth_service.dart';
import 'user_state.dart';

enum AuthError {
  userExists,
  wrongCode,
  invalidPhoneNumber,
  codeTimeout,
}

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
    emit(const UserState(status: UserStatus.notLogged));
  }

  void abortAuthentication() {
    _authService.signOut();
    emit(const UserState(status: UserStatus.notLogged));
  }

  Future<void> sendSms(String phoneNum) async {
    log("sending sms");
    try {
      _authService.sendSms(phoneNum);
    } catch (e) {}
  }

  Future<void> verifySms(String smsCode) async {
    try {
      _authService.verifyCode(smsCode, state.verificationNumber);
    } catch (e) {}
  }
}
