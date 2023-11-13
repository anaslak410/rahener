// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:rahener/core/models/exercise.dart';

class UserModel {
  final String username;
  final String id;
  final List<Exercise> customExercises;
  final String phoneNum;
  UserModel({
    required this.username,
    required this.id,
    required this.customExercises,
    required this.phoneNum,
  });

  UserModel copyWith({
    String? username,
    String? id,
    List<Exercise>? customExercises,
    String? phoneNum,
  }) {
    return UserModel(
      username: username ?? this.username,
      id: id ?? this.id,
      customExercises: customExercises ?? this.customExercises,
      phoneNum: phoneNum ?? this.phoneNum,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'username': username,
      'id': id,
      'customExercises': customExercises.map((x) => x.toMap()).toList(),
      'phoneNum': phoneNum,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      username: map['username'] as String,
      id: map['id'] as String,
      customExercises: List<Exercise>.from(
        (map['customExercises'] as List<int>).map<Exercise>(
          (x) => Exercise.fromMap(x as Map<String, dynamic>),
        ),
      ),
      phoneNum: map['phoneNum'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(username: $username, id: $id, customExercises: $customExercises, phoneNum: $phoneNum)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.username == username &&
        other.id == id &&
        listEquals(other.customExercises, customExercises) &&
        other.phoneNum == phoneNum;
  }

  @override
  int get hashCode {
    return username.hashCode ^
        id.hashCode ^
        customExercises.hashCode ^
        phoneNum.hashCode;
  }
}
