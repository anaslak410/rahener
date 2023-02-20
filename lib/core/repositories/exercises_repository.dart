import 'package:flutter/material.dart';
import 'package:rahener/core/models/muscle_group.dart';
import 'package:rahener/core/services/local_json_data.dart';

import '../models/exercise.dart';

class ExercisesRepository {
  // ignore: unused_field
  final LocalJsonDataService _localJsonDataService;

  final List<Exercise> _exercises = [];
  List<MuscleGroup> _muscleGroups = [];
  List<String> _equipment = [];

  ExercisesRepository._create(
      {required LocalJsonDataService localJsonDataService})
      : _localJsonDataService = localJsonDataService;

  List<Exercise> get exercises {
    return _exercises;
  }

  AssetImage getExerciseImage(String exerciseId) {
    var image = _localJsonDataService.getExerciseImage(exerciseId);
    return image;
  }

  List<MuscleGroup> get muscleGroups {
    return _muscleGroups;
  }

  List<String> get muscleGroupNames {
    return _muscleGroups.map((e) => e.name).toList();
  }

  List<String> get equipment {
    return _equipment;
  }

  static Future<ExercisesRepository> create(
      {required LocalJsonDataService localJsonDataService}) async {
    var exercisesRepository =
        ExercisesRepository._create(localJsonDataService: localJsonDataService);
    Map<dynamic, dynamic> exercisesJson =
        await localJsonDataService.getExercises();

    List<dynamic> muscleGroupsJson =
        await localJsonDataService.getMuscleGroups();

    List<dynamic> equipmentJson = await localJsonDataService.getEquipment();

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
