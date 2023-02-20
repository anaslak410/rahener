import 'dart:convert';

import 'package:collection/collection.dart';

class MuscleGroup {
  final String name;
  final List<String> subMuscles;

  MuscleGroup({
    required this.name,
    required this.subMuscles,
  });

  MuscleGroup copyWith({
    String? name,
    List<String>? subMuscles,
  }) {
    return MuscleGroup(
      name: name ?? this.name,
      subMuscles: subMuscles ?? this.subMuscles,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'subMuscles': subMuscles,
    };
  }

  factory MuscleGroup.fromMap(Map<String, dynamic> map) {
    return MuscleGroup(
      name: map['name'],
      subMuscles: List<String>.from(map['subMuscles']),
    );
  }

  String toJson() => json.encode(toMap());

  factory MuscleGroup.fromJson(String source) =>
      MuscleGroup.fromMap(json.decode(source));

  @override
  String toString() => 'MuscleGroup(name: $name, subMuscles: $subMuscles)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other is MuscleGroup &&
        other.name == name &&
        listEquals(other.subMuscles, subMuscles);
  }

  @override
  int get hashCode => name.hashCode ^ subMuscles.hashCode;
}
