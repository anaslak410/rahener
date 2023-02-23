import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rahener/core/services/local_data.dart';

void main() {
  late LocalDataService localDataService;
  setUp(() async {
    WidgetsFlutterBinding.ensureInitialized();
    localDataService = await LocalDataService.create("en");
  });
  // test(
  //     "exercises should have no primaryMuscle that does not exist in muscleGroups list",
  //     () async {
  //   List<String> primaryMuscleGroups = [];
  //   await localDataService.getMuscleGroups().then((value) {
  //     for (var element in value) {
  //       primaryMuscleGroups.add(element['name'] as String);
  //     }
  //   });

  //   Map<dynamic, dynamic> exercises = await localDataService.getExercises();

  //   exercises.forEach((key, value) {
  //     expect(primaryMuscleGroups.contains(value['primaryMuscle']), true);
  //   });
  // });
  // test(
  //     "exercises should have no equipment that does not exist in equipment list",
  //     () async {
  //   List<String> equipment =
  //       await localDataService.getEquipment().then((value) => );

  //   Map<dynamic, dynamic> exercises = await localDataService.getExercises();

  //   exercises.forEach((key, value) {
  //     expect(equipment.contains(value['equipment']), true);
  //   });
  // });
}
