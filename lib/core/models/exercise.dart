import 'dart:convert';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';

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
