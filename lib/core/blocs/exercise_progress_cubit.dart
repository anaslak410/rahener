// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rahener/core/blocs/ExerciseSet.dart';
import 'package:rahener/core/models/session.dart';
import 'package:rahener/core/repositories/sessions_repository.dart';

class ExerciseProgressCubit extends Cubit<ExerciseProgressState> {
  final SessionsRepository _repository;
  ExerciseProgressCubit(this._repository) : super(ExerciseProgressLoading()) {
    _subscribe();

    var exercises = _convertSessionsToLogs(_repository.sessions);
    emit(ExerciseProgressLoaded(exercises: exercises, selectedExercise: null));
  }

  void _subscribe() {
    _repository.listen.listen(
      (items) {
        ExerciseProgressLoaded newState = state as ExerciseProgressLoaded;
        var exercises = _convertSessionsToLogs(items);
        emit(newState.copyWith(exercises: exercises));
      },
      onError: (error) => log(error),
    );
  }

  void selectExercise(String id) {
    ExerciseProgressLoaded newState = state as ExerciseProgressLoaded;
    emit(newState.copyWith(
        selectedExercise:
            newState.exercises.firstWhere((element) => element.id == id)));
  }

  List<ExerciseLog> _convertSessionsToLogs(List<Session> sessions) {
    List<ExerciseLog> exerciseLogs = [];
    for (Session session in sessions) {
      for (var exercise in session.exercisesPerfomed) {
        String id = exercise.id;
        ExerciseLog log =
            exerciseLogs.firstWhere((element) => element.id == id, orElse: () {
          ExerciseLog newLog =
              ExerciseLog(id: id, entries: [], name: exercise.name);
          exerciseLogs.add(newLog);
          return newLog;
        });
        double highestWeightLifted = 0;
        for (ExerciseSet set in exercise.sets) {
          if (set.weight > highestWeightLifted && set.reps != 0) {
            highestWeightLifted = set.weight;
          }
        }
        if (highestWeightLifted != 0) {
          log.entries.add((highestWeightLifted, session.datePerformed));
        }
      }
    }
    return exerciseLogs;
  }
}

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
    if (selectedExercise != null) {
      availableExercises
          .removeWhere((element) => element.id == selectedExercise!.id);
    }
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

class ExerciseLog {
  final String id;
  final String name;
  List<(double, DateTime)> entries;

  ExerciseLog({
    required this.name,
    required this.id,
    required this.entries,
  });

  get sortedEntries {
    return entries.sort((a, b) {
      return a.$2.compareTo(b.$2);
    });
  }

  ExerciseLog copyWith({
    String? id,
    String? name,
    List<(double, DateTime)>? entries,
  }) {
    return ExerciseLog(
      id: id ?? this.id,
      name: name ?? this.name,
      entries: entries ?? this.entries,
    );
  }
}
