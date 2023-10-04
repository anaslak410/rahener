// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:rahener/core/models/exercise.dart';

class UserModel {
  final String userName;
  final String id;
  final List<Exercise> customExercises;
  final String phoneNum;
  UserModel({
    required this.userName,
    required this.id,
    required this.customExercises,
    required this.phoneNum,
  });

  @override
  String toString() {
    return 'UserModel(userName: $userName, id: $id, customExercises: $customExercises, phoneNum: $phoneNum)';
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userName': userName,
      'id': id,
      'customExercises': customExercises.map((x) => x.toMap()).toList(),
      'phoneNum': phoneNum,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userName: map['userName'] as String,
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

  UserModel copyWith({
    String? userName,
    String? id,
    List<Exercise>? customExercises,
    String? phoneNum,
  }) {
    return UserModel(
      userName: userName ?? this.userName,
      id: id ?? this.id,
      customExercises: customExercises ?? this.customExercises,
      phoneNum: phoneNum ?? this.phoneNum,
    );
  }
}
