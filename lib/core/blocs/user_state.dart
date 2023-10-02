import 'package:rahener/core/models/exercise.dart';

enum UserStatus { initial, loading, notLogged, logged }

class UserState {
  const UserState(
      {this.status = UserStatus.notLogged,
      this.name = "",
      this.phoneNumber = "",
      this.customExercises = const []});
  final UserStatus status;
  final String name;
  final String phoneNumber;
  final List<Exercise> customExercises;

  // UserState copyWith() {
  //   return const UserState(
  //       this._name, this._phoneNumber, this._customExercises);
  // }

  @override
  String toString() => '';
}
