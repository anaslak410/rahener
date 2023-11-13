import 'package:rahener/core/models/exercise.dart';

class CurrentSessionState {
  final bool isInProgress;
  final List<SessionExercise> exercisesPerfomed;

  CurrentSessionState(
      {required this.isInProgress, this.exercisesPerfomed = const []});

  CurrentSessionState copyWith({
    bool? isInProgress,
    List<SessionExercise>? exercisesPerfomed,
  }) {
    return CurrentSessionState(
      isInProgress: isInProgress ?? this.isInProgress,
      exercisesPerfomed: exercisesPerfomed ?? this.exercisesPerfomed,
    );
  }
}
