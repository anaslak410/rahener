// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:rahener/core/models/exercise.dart';
import 'package:rahener/core/models/user_model.dart';

enum UserStatus { initial, loading, notLogged, logged }

class UserState {
  const UserState(
      {required this.status, UserModel? user, this.verificationNumber})
      : _user = user;
  final UserStatus status;
  final UserModel? _user;
  final String? verificationNumber;

  UserState copyWith({
    UserStatus? status,
    UserModel? user,
    String? verificationNumber,
  }) {
    return UserState(
      status: status ?? this.status,
      user: user ?? _user,
      verificationNumber: verificationNumber ?? this.verificationNumber,
    );
  }
}
