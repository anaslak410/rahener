import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rahener/core/models/auth_exception.dart';
import 'package:rahener/core/models/user_model.dart';
import 'package:rahener/core/services/firebase_auth_service.dart';
import 'package:rahener/core/services/firestore_data.dart';
import 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final FireBaseAuthService _authService;
  final FirestoreService _firestoreService;

  UserCubit({required authService, required firestoreService})
      : _authService = authService,
        _firestoreService = firestoreService,
        super(const UserState(status: UserStatus.loading)) {
    _listenToAuthChanges();
  }

  void _listenToAuthChanges() {
    _authService.authUpdates().listen((User? user) async {
      if (user == null) {
        emit(const UserState(status: UserStatus.notLogged));
      } else {
        emit(UserState(
            status: UserStatus.logged, user: await _getUser(user.uid)));
      }
    });
  }

  Future<UserModel> _getUser(String id) async {
    var userMap = await _firestoreService.getUser(id);
    var userModel = UserModel.fromMap(userMap);
    return userModel;
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
      await _authService.sendSms(phoneNum, onCodeSent);
    } on Exception catch (e) {
      AuthException exception = _handleException(e);
      emit(state.copyWith(authException: exception));
    }
  }

  void onCodeSent(String id) {
    emit(state.copyWith(verificationID: id));
  }

  Future<void> verifySms(String smsCode) async {
    try {
      await _authService.verifyCode(smsCode, state.verificationID);
    } on Exception catch (e) {
      AuthException exception = _handleException(e);
      emit(state.copyWith(authException: exception));
    }
  }

  Future<void> _createUserAccount(UserModel user) async {
    _firestoreService.createUser(user.toMap());
  }

  AuthException _handleException(Exception e) {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'invalid-phone-number':
          return AuthException.invalidPhoneNumber;
        case 'invalid-verification-code':
          return AuthException.wrongCode;
        case 'too-many-requests':
          return AuthException.tooManyRequests;
        // case 'user-disabled':
        //   return AuthException.wrongCode;
        // case 'timeout':
        //   return AuthException.codeTimeout;
        case 'network-request-failed':
          return AuthException.noInternetConnection;
        default:
          throw Exception(
              "Unhandled firebase exception, code does not match any case, exception ${e.toString()}");
      }
    } else {
      throw Exception(
          "Exception not of type FirebaseAuthException, exception: ${e.toString()}");
    }
  }
}
