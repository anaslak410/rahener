import 'package:rahener/core/blocs/exercise_progress_cubit.dart';

class ExerciseProgressLoading extends ExerciseProgressState {}

class ExerciseProgressLoaded extends ExerciseProgressState {
  final List<ExerciseLog> exercises;
  final ExerciseLog? selectedExercise;

  ExerciseProgressLoaded({
    this.selectedExercise,
    required this.exercises,
  });

  get availableExercises {
    List<ExerciseLog> availableExercises = List.from(exercises);
    return availableExercises;
  }

  ExerciseProgressLoaded copyWith({
    List<ExerciseLog>? exercises,
    ExerciseLog? selectedExercise,
  }) {
    return ExerciseProgressLoaded(
      exercises: exercises ?? this.exercises,
      selectedExercise: selectedExercise ?? this.selectedExercise,
    );
  }
}

class ExerciseProgressState {}
