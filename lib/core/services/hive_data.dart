import 'package:hive_flutter/hive_flutter.dart';
import 'package:rahener/core/models/exercise.dart';

class HiveDataService {
  final Box _customExercisesBox;
  final Box _builtInExercisesBox;

  HiveDataService._create(
      {required customExercisesBox, required builtInExercisesBox})
      : _customExercisesBox = customExercisesBox,
        _builtInExercisesBox = builtInExercisesBox;

  static Future<HiveDataService> create() async {
    var customExercisesBox = await Hive.openBox("customExercises");
    var builtInExercisesBox = await Hive.openBox("builtInExercises");

    HiveDataService dataService = HiveDataService._create(
        customExercisesBox: customExercisesBox,
        builtInExercisesBox: builtInExercisesBox);

    return dataService;
  }

  List<String> getBuiltInExerciseIDs() {
    var buildInExercisesIds = List<String>.from(_builtInExercisesBox.keys);

    return buildInExercisesIds;
  }

  void deleteBuiltInExercise(String id) {
    _builtInExercisesBox.delete(id);
  }

  void addBuiltInExercise(String id, Map<String, dynamic> exercise) {
    _builtInExercisesBox.put(id, exercise);
  }

  List<Map<String, dynamic>> getBuiltInExercises() {
    var buildInExercisesDynamic = _builtInExercisesBox.values;
    List<Map<String, dynamic>> builtIn = [];
    for (var element in buildInExercisesDynamic) {
      builtIn.add(Map<String, dynamic>.from(element));
    }
    return builtIn;
  }

  List<Map<String, dynamic>> getCustomExercises() {
    var customExercisesDynamic = _customExercisesBox.values;
    List<Map<String, dynamic>> customExercises = [];
    for (var element in customExercisesDynamic) {
      customExercises.add(Map<String, dynamic>.from(element));
    }
    return customExercises;
  }

  void addCustomExercise(String id, Map<String, dynamic> exercise) {
    _customExercisesBox.put(id, exercise);
  }

  void createSession() {}
  void removeSession() {}
  void getSessions() {}

  void createMeasurement() {}
  void removeMeasurement() {}
  void getMeasurements() {}

  void getMeasurementEntries() {}
  void createMeasurementEntry() {}
  void removeMeasurementEntry() {}
  void editMeasurementEntry() {}
  // AssetImage getExerciseImage(String exerciseId) {
  //   return AssetImage("assets/data/images/$exerciseId.gif");
  // }
}
