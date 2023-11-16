// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rahener/core/blocs/ExerciseSet.dart';
import 'package:rahener/core/models/session.dart';
import 'package:rahener/core/repositories/sessions_repository.dart';

class ExerciseProgressCubit extends Cubit<ExerciseProgressState> {
  SessionsRepository _repository;
  ExerciseProgressCubit(this._repository)
      : super(ExerciseProgressState(exercises: [])) {
    emit(state.copyWith(
        exercises: _convertSessionsToLogs(_repository.sessions)));
  }
}

List<ExerciseLog> _convertSessionsToLogs(List<Session> sessions) {
  List<ExerciseLog> exerciseLogs = [];
  for (Session session in sessions) {
    for (var exercise in session.exercisesPerfomed) {
      String id = exercise.id;
      ExerciseLog log =
          exerciseLogs.firstWhere((element) => element.id == id, orElse: () {
        ExerciseLog newLog = ExerciseLog(id: id, entries: []);
        exerciseLogs.add(newLog);
        return newLog;
      });
      double highestWeightLifted = 0;
      for (ExerciseSet set in exercise.sets) {
        if (set.weight > highestWeightLifted) {
          highestWeightLifted = set.weight;
        }
      }

      log.entries.add((highestWeightLifted, session.datePerformed));
    }
  }
  return exerciseLogs;
}

class ExerciseProgressState {
  final List<ExerciseLog> exercises;
  ExerciseProgressState({
    required this.exercises,
  });

  ExerciseProgressState copyWith({
    List<ExerciseLog>? exercises,
  }) {
    return ExerciseProgressState(
      exercises: exercises ?? this.exercises,
    );
  }
}

class ExerciseLog {
  final String id;
  List<(double, DateTime)> entries;

  ExerciseLog({
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
    List<(double, DateTime)>? entries,
  }) {
    return ExerciseLog(
      id: id ?? this.id,
      entries: entries ?? this.entries,
    );
  }
}
