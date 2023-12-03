// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:rahener/core/models/auth_exception.dart';

import 'package:rahener/core/models/exercise.dart';
import 'package:rahener/core/models/user_model.dart';

enum UserStatus { initial, loading, notLogged, logged }

class UserState {
  const UserState(
      {required this.status,
      UserModel? user,
      String? verificationID,
      AuthException? authException})
      : _user = user,
        verificationID = verificationID ?? "",
        authException = authException ?? AuthException.none;

  final UserStatus status;
  final AuthException authException;
  final UserModel? _user;
  final String verificationID;

  UserModel get user {
    if (_user == null) {
      throw Exception("attempted to get empty user");
    }
    return _user!;
  }

  UserState copyWith({
    UserStatus? status,
    UserModel? user,
    AuthException? authException,
    String? verificationID,
  }) {
    return UserState(
      user: user ?? _user,
      status: status ?? this.status,
      authException: authException ?? this.authException,
      verificationID: verificationID ?? this.verificationID,
    );
  }
}
