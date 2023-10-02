import 'package:flutter/material.dart';
import 'package:rahener/core/models/muscle_group.dart';
import 'package:rahener/core/services/local_data.dart';

import '../models/exercise.dart';

class ExercisesRepository {
  // ignore: unused_field
  final LocalDataService _localJsonDataService;

  final List<Exercise> _exercises = [];
  List<MuscleGroup> _muscleGroups = [];
  List<String> _equipment = [];

  ExercisesRepository._create({required LocalDataService localJsonDataService})
      : _localJsonDataService = localJsonDataService;

  void addExercise(Exercise exercise) {
    _exercises.add(exercise);
  }

  List<Exercise> get exercises {
    return _exercises;
  }

  AssetImage getExerciseImage(String exerciseId) {
    var image = _localJsonDataService.getExerciseImage(exerciseId);
    return image;
  }

  List<String> get muscleNames {
    return _muscleGroups.map((e) => e.name).toList();
  }

  List<String> get equipment {
    return _equipment;
  }

  static Future<ExercisesRepository> create(
      {required LocalDataService localDataService}) async {
    var exercisesRepository =
        ExercisesRepository._create(localJsonDataService: localDataService);
    Map<dynamic, dynamic> exercisesJson = await localDataService.getExercises();

    List<dynamic> muscleGroupsJson = await localDataService.getMuscleGroups();

    List<dynamic> equipmentJson = await localDataService.getEquipment();

    exercisesRepository._muscleGroups = muscleGroupsJson
        .map((muscleGroupJson) => MuscleGroup.fromMap(muscleGroupJson))
        .toList();

    exercisesRepository._equipment =
        equipmentJson.map((equipmentJson) => equipmentJson as String).toList();

    exercisesJson.forEach((id, exerciseJson) {
      exercisesRepository._exercises
          .add(Exercise.fromMap({'id': id, ...exerciseJson as Map}));
    });

    return exercisesRepository;
  }
}
