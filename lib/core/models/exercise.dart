import 'dart:convert';
import 'package:collection/collection.dart';

class Exercise {
  final String id;
  final String name;
  final String muscleGroupName;
  final String equipment;
  final List<String> commonMistakes;
  final List<String> steps;
  final List<String> similarExercises;

  Exercise({
    required this.id,
    required this.name,
    required this.equipment,
    required this.muscleGroupName,
    required this.commonMistakes,
    required this.steps,
    required this.similarExercises,
  });

  Exercise copyWith({
    String? id,
    String? name,
    String? equipment,
    String? muscleGroupName,
    List<String>? commonMistakes,
    List<String>? steps,
    List<String>? similarExercises,
  }) {
    return Exercise(
      id: id ?? this.id,
      name: name ?? this.name,
      equipment: equipment ?? this.equipment,
      muscleGroupName: muscleGroupName ?? this.muscleGroupName,
      commonMistakes: commonMistakes ?? this.commonMistakes,
      steps: steps ?? this.steps,
      similarExercises: similarExercises ?? this.similarExercises,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'equipment': equipment,
      'muscleGroupName': muscleGroupName,
      'commonMistakes': commonMistakes,
      'steps': steps,
      'similarExercises': similarExercises,
    };
  }

  factory Exercise.fromMap(Map<String, dynamic> map) {
    return Exercise(
      id: map['id'],
      name: map['name'],
      equipment: map['equipment'],
      muscleGroupName: map['muscleGroupName'],
      commonMistakes: List<String>.from(map['commonMistakes']),
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
      muscleGroupName: $muscleGroupName,
       commonMistakes: $commonMistakes,
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
        other.muscleGroupName == muscleGroupName &&
        listEquals(other.commonMistakes, commonMistakes) &&
        listEquals(other.steps, steps) &&
        listEquals(other.similarExercises, similarExercises);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        muscleGroupName.hashCode ^
        commonMistakes.hashCode ^
        steps.hashCode ^
        similarExercises.hashCode;
  }
}
