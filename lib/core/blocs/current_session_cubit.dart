// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rahener/core/blocs/current_session_state.dart';
import 'package:rahener/core/models/exercise.dart';
import 'package:rahener/core/models/session.dart';
import 'package:rahener/core/repositories/exercises_repository.dart';

class CurrentSessionCubit extends Cubit<CurrentSessionState> {
  final ExercisesRepository _repository;
  final DateTime datePerformed = DateTime.now();
  CurrentSessionCubit({required repository})
      : _repository = repository,
        super(CurrentSessionState(isInProgress: false)) {
    emit(CurrentSessionState(isInProgress: false));
  }

  void startSession() {
    emit(CurrentSessionState(isInProgress: true));
  }

  void discardSession() {
    emit(CurrentSessionState(isInProgress: false));
  }

  void saveAndEndSession(Duration timeLasted) {
    emit(CurrentSessionState(isInProgress: false));
  }

  Session getSession(Duration duration) {
    return Session(
        datePerformed: datePerformed,
        duration: duration,
        exercisesPerfomed: state.exercisesPerfomed);
  }

  void addExercise(Exercise exercise) {
    SessionExercise sessionExercise = SessionExercise.fromExercise(exercise);
    emit(state.copyWith(
      exercisesPerfomed: [...state.exercisesPerfomed, sessionExercise],
    ));
  }

  void removeExercise(String id) {
    List<SessionExercise> newExercisesPerformed =
        List.from(state.exercisesPerfomed);
    for (var element in newExercisesPerformed) {
      if (element.id == id) {
        newExercisesPerformed.remove(element);
        break;
      }
    }
    emit(state.copyWith(exercisesPerfomed: newExercisesPerformed));
  }

  List<Exercise> getAvailableExercises() {
    List<Exercise> exercises = List.from(_repository.exercises);
    exercises.removeWhere((element) {
      for (var exercise in state.exercisesPerfomed) {
        if (element.id == exercise.id) {
          return true;
        }
      }
      return false;
    });

    return exercises;
  }

  void addSet(String id) {
    SessionExercise exercise =
        state.exercisesPerfomed.firstWhere((element) => element.id == id);
    exercise.addSet();
    emit(state.copyWith(
      exercisesPerfomed: [...state.exercisesPerfomed],
    ));
  }

  void removeSet(String id, int index) {
    List<SessionExercise> newExercisesPerformed =
        List.from(state.exercisesPerfomed);
    newExercisesPerformed.removeWhere((exercise) => exercise.id == id);
    emit(state.copyWith(exercisesPerfomed: newExercisesPerformed));
  }
}
