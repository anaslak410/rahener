import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rahener/core/blocs/user_state.dart';
import 'package:rahener/core/models/muscle_group.dart';
import 'package:rahener/core/services/firebase_auth_service.dart';
import 'package:rahener/core/services/firestore_data.dart';
import 'package:rahener/core/services/hive_data.dart';
import 'package:rahener/core/services/local_data.dart';

import '../models/exercise.dart';

class ExercisesRepository {
  // ignore: unused_field
  final LocalDataService _localJsonDataService;
  final FirestoreService _fireStoreService;
  final FireBaseAuthService _fireBaseAuthService;
  final HiveDataService _hiveDataService;

  final List<Exercise> _buildInExercises = [];
  List<Exercise> _customExercises = [];
  List<MuscleGroup> _muscleGroups = [];
  List<String> _equipment = [];

  final _controller = StreamController<void>.broadcast();
  Stream<void> get listenToChanges => _controller.stream;

  ExercisesRepository._create(
      {required LocalDataService localJsonDataService,
      required FireBaseAuthService fireBaseAuthService,
      required HiveDataService hiveDataService,
      required FirestoreService fireStoreService})
      : _localJsonDataService = localJsonDataService,
        _fireBaseAuthService = fireBaseAuthService,
        _hiveDataService = hiveDataService,
        _fireStoreService = fireStoreService {}

  void _subscribeToUserAuthChanges() async {
    _fireBaseAuthService.authUpdates().listen((User? user) async {
      if (user == null) {
        log("user out");
        // _customExercises = [];
        // _controller.sink.add(null);
      } else {
        log("user in");
        // await _getCustomExercises(user);
      }
    });
  }

  // Future<void> _getCustomExercises(User user) async {
  //   List<dynamic> customExercisesJson =
  //       await _fireStoreService.getCustomExercises(user.uid);

  //   for (var exerciseJson in customExercisesJson) {
  //     _customExercises
  //         .add(Exercise.fromMap(exerciseJson as Map<String, dynamic>));
  //     _controller.sink.add(null);
  //   }
  // }

  void addCustomExercise(Exercise exercise) {
    // _fireStoreService.createCustomExercise(
    //     "EpsK55HExuQYXEVRL8JnyXtloUq2", exercise.toMap());
    // _customExercises.add(exercise);
    // _hiveDataService.addCustomExercise(exercise.id, exercise.toMap());
    _hiveDataService.addCustomExercise(exercise.id, exercise.toMap());
    // _controller.sink.add(null);
  }

  List<Exercise> get exercises {
    return [..._buildInExercises, ..._customExercises];
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
      {required LocalDataService localDataService,
      required FireBaseAuthService fireBaseAuthService,
      required HiveDataService hiveDataService,
      required FirestoreService fireStoreService}) async {
    var exercisesRepository = ExercisesRepository._create(
        localJsonDataService: localDataService,
        fireBaseAuthService: fireBaseAuthService,
        fireStoreService: fireStoreService,
        hiveDataService: hiveDataService);

    List<dynamic> muscleGroupsJson = await localDataService.getMuscleGroups();
    exercisesRepository._muscleGroups = muscleGroupsJson
        .map((muscleGroupJson) => MuscleGroup.fromMap(muscleGroupJson))
        .toList();

    List<dynamic> equipmentJson = await localDataService.getEquipment();
    exercisesRepository._equipment =
        equipmentJson.map((equipmentJson) => equipmentJson as String).toList();

    List<String> fireStoreExerciseIds =
        await fireStoreService.getBuiltInExerciseIDs();
    List<String> hiveExerciseIds = hiveDataService.getBuiltInExerciseIDs();

    for (var id in hiveExerciseIds) {
      if (!fireStoreExerciseIds.contains(id)) {
        hiveDataService.deleteBuiltInExercise(id);
      }
    }

    for (var id in fireStoreExerciseIds) {
      if (!hiveExerciseIds.contains(id)) {
        Map<String, dynamic> exercise =
            await fireStoreService.getBuiltInExercise(id);
        hiveDataService.addBuiltInExercise(id, exercise);
      }
    }

    var customExercisesJson = hiveDataService.getCustomExercises();

    for (var exerciseJson in customExercisesJson) {
      exercisesRepository._customExercises.add(Exercise.fromMap(exerciseJson));
      exercisesRepository._controller.sink.add(null);
    }

    List<Map<String, dynamic>> builtinExercisesJson =
        hiveDataService.getBuiltInExercises();

    for (var exerciseJson in builtinExercisesJson) {
      exercisesRepository._buildInExercises.add(Exercise.fromMap(exerciseJson));
    }

    exercisesRepository._subscribeToUserAuthChanges();

    return exercisesRepository;
  }
}
