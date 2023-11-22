// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

import 'package:rahener/core/blocs/exercise_set.dart';

class Exercise {
  final String id;
  final String name;
  final List<String> primaryMuscles;
  final List<String> secondaryMuscles;
  final String equipment;
  final List<String> tips;
  final List<String> steps;
  final List<String> similarExercises;

  Exercise({
    required this.id,
    required this.name,
    required this.equipment,
    required this.primaryMuscles,
    required this.secondaryMuscles,
    required this.tips,
    required this.steps,
    required this.similarExercises,
  });

  Exercise copyWith({
    String? id,
    String? name,
    String? equipment,
    List<String>? primaryMuscles,
    List<String>? secondaryMuscles,
    List<String>? tips,
    List<String>? steps,
    List<String>? similarExercises,
  }) {
    return Exercise(
      id: id ?? this.id,
      name: name ?? this.name,
      equipment: equipment ?? this.equipment,
      primaryMuscles: primaryMuscles ?? this.primaryMuscles,
      secondaryMuscles: secondaryMuscles ?? this.secondaryMuscles,
      tips: tips ?? this.tips,
      steps: steps ?? this.steps,
      similarExercises: similarExercises ?? this.similarExercises,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'equipment': equipment,
      'primaryMuscles': primaryMuscles,
      'secondaryMuscles': secondaryMuscles,
      'tips': tips,
      'steps': steps,
      'similarExercises': similarExercises,
    };
  }

  factory Exercise.fromMap(Map<String, dynamic> map) {
    return Exercise(
      id: map['id'],
      name: map['name'],
      equipment: map['equipment'],
      tips: List<String>.from(map['tips']),
      primaryMuscles: List<String>.from(map['primaryMuscles']),
      secondaryMuscles: List<String>.from(map['secondaryMuscles']),
      steps: List<String>.from(map['steps']),
      similarExercises: List<String>.from(map['similarExercises']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Exercise.fromJson(String source) =>
      Exercise.fromMap(json.decode(source));

  @override
  String toString() {
    return '''Exercise(id: $id,
     name: $name,
     equipment: $equipment,
       primaryMuscles: $primaryMuscles,
       secondaryMuscles: $secondaryMuscles,
       tips: $tips,
        steps: $steps,
         similarExercises: $similarExercises)''';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other is Exercise &&
        other.id == id &&
        other.name == name &&
        listEquals(other.primaryMuscles, primaryMuscles) &&
        listEquals(other.secondaryMuscles, secondaryMuscles) &&
        listEquals(other.tips, tips) &&
        listEquals(other.steps, steps) &&
        listEquals(other.similarExercises, similarExercises);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        primaryMuscles.hashCode ^
        secondaryMuscles.hashCode ^
        tips.hashCode ^
        steps.hashCode ^
        similarExercises.hashCode;
  }
}

class SessionExercise extends Exercise {
  final List<ExerciseSet> _sets;

  SessionExercise(
      {required id,
      required name,
      required equipment,
      required primaryMuscles,
      required secondaryMuscles,
      required tips,
      required steps,
      List<ExerciseSet> sets = const [],
      required similarExercises})
      : _sets = sets,
        super(
            id: id,
            name: name,
            equipment: equipment,
            primaryMuscles: primaryMuscles,
            secondaryMuscles: secondaryMuscles,
            tips: tips,
            steps: steps,
            similarExercises: similarExercises);

  SessionExercise.fromExercise(Exercise exercise)
      : _sets = [],
        super(
            id: exercise.id,
            name: exercise.name,
            equipment: exercise.equipment,
            primaryMuscles: exercise.primaryMuscles,
            secondaryMuscles: exercise.secondaryMuscles,
            tips: exercise.tips,
            steps: exercise.steps,
            similarExercises: exercise.similarExercises);

  void addSet({ExerciseSet? set}) {
    if (set == null) {
      _sets.add(ExerciseSet(reps: 0, weight: 0.00));
    } else {
      _sets.add(set);
    }
  }

  void removeSet(int index) {
    _sets.removeAt(index);
  }

  void updateSet(int index, ExerciseSet set) {
    _sets[index] = set;
  }

  get sets {
    return _sets;
  }

  @override
  String toString() => 'SessionExercise(_sets: $_sets)';
}
