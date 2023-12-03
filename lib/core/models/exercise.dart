// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

import 'package:rahener/core/models/exercise_set.dart';

class Exercise {
  final String id;
  final String name;
  final String primaryMuscle;
  final List<String> secondaryMuscles;
  final String equipment;
  final List<String> tips;
  final List<String> steps;
  final List<String> similarExercises;

  Exercise({
    required this.id,
    required this.name,
    required this.equipment,
    required this.primaryMuscle,
    required this.secondaryMuscles,
    required this.tips,
    required this.steps,
    required this.similarExercises,
  });

  Exercise copyWith({
    String? id,
    String? name,
    String? equipment,
    String? primaryMuscle,
    List<String>? secondaryMuscles,
    List<String>? tips,
    List<String>? steps,
    List<String>? similarExercises,
  }) {
    return Exercise(
      id: id ?? this.id,
      name: name ?? this.name,
      equipment: equipment ?? this.equipment,
      primaryMuscle: primaryMuscle ?? this.primaryMuscle,
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
      'primaryMuscle': primaryMuscle,
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
      primaryMuscle: map['primaryMuscle'],
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
       primaryMuscles: $primaryMuscle,
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
        listEquals(other.primaryMuscle, primaryMuscle) &&
        listEquals(other.secondaryMuscles, secondaryMuscles) &&
        listEquals(other.tips, tips) &&
        listEquals(other.steps, steps) &&
        listEquals(other.similarExercises, similarExercises);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        primaryMuscle.hashCode ^
        secondaryMuscles.hashCode ^
        tips.hashCode ^
        steps.hashCode ^
        similarExercises.hashCode;
  }

  static String generateUniqueKey() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}

class SessionExercise extends Exercise {
  final List<ExerciseSet> _sets;

  SessionExercise(
      {required id,
      required name,
      required equipment,
      required primaryMuscle,
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
            primaryMuscle: primaryMuscle,
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
            primaryMuscle: exercise.primaryMuscle,
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
