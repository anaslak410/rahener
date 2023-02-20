import 'package:flutter/widgets.dart';

import '../models/exercise.dart';

enum ExerciseListStatus { initial, loading, success, failure }

class ExerciseListState {
  ExerciseListStatus status;
  final List<Exercise> _exercises;

  late TextEditingController searchFieldController;

  final Map<String, bool> selectedMuscleGroups;
  final Map<String, bool> selectedEquipment;

  ExerciseListState({
    List<Exercise> exercises = const [],
    TextEditingController? searchFieldController,
    this.selectedMuscleGroups = const {},
    this.selectedEquipment = const {},
    this.status = ExerciseListStatus.initial,
  }) : _exercises = exercises {
    this.searchFieldController =
        searchFieldController ?? TextEditingController();
  }

  List<Exercise> get filteredExercises {
    bool muscleGroupFilterIsOn = _muscleGroupFilterIsOn();
    bool equipmentFilterIsOn = _equipmentFilterIsOn();

    List<Exercise> filteredExercises = _exercises.where((exercise) {
      if (muscleGroupFilterIsOn) {
        if (!_muscleGroupFilterApplies(exercise.muscleGroupName)) {
          return false;
        }
      }
      if (equipmentFilterIsOn) {
        if (!_equipmentFilterApplies(exercise.equipment)) {
          return false;
        }
      }
      return _queryFilterApplies(exercise.name);
    }).toList();
    return filteredExercises;
  }

  List<Exercise> get allExercises {
    return _exercises;
  }

  List<String> get muscleGroupNames => selectedMuscleGroups.keys.toList();
  List<String> get equipmentNames => selectedEquipment.keys.toList();

  List<String> get selectedChipFilters {
    return [
      ...selectedMuscleGroups.entries
          .where((element) => element.value == true)
          .map((e) => e.key)
          .toList(),
      ...selectedEquipment.entries
          .where((element) => element.value == true)
          .map((e) => e.key)
          .toList(),
    ];
  }

  bool _queryFilterApplies(String exerciseName) {
    var regex = RegExp(searchFieldController.text, caseSensitive: false);
    return regex.hasMatch(exerciseName);
  }

  bool _muscleGroupFilterIsOn() {
    for (MapEntry element in selectedMuscleGroups.entries) {
      if (element.value) return true;
    }
    return false;
  }

  void clearSearchQuery() {
    searchFieldController.text = "";
  }

  bool _equipmentFilterIsOn() {
    for (MapEntry element in selectedEquipment.entries) {
      if (element.value) return true;
    }
    return false;
  }

  bool muscleGroupIsSelected(String muscleGroupName) {
    return selectedMuscleGroups.entries
        .firstWhere((element) => element.key == muscleGroupName)
        .value;
  }

  bool equipmentIsSelected(String equipmentName) {
    return selectedEquipment.entries
        .firstWhere((element) => element.key == equipmentName)
        .value;
  }

  bool _muscleGroupFilterApplies(String muscleGroupName) {
    return selectedMuscleGroups[muscleGroupName]!;
  }

  bool _equipmentFilterApplies(String equipmentName) {
    return selectedEquipment[equipmentName]!;
  }

  ExerciseListState copyWith({
    List<Exercise>? exercises,
    TextEditingController? searchFieldController,
    Map<String, bool>? selectedMuscleGroups,
    Map<String, bool>? selectedEquipment,
    List<String>? equipments,
    ExerciseListStatus? status,
  }) {
    return ExerciseListState(
      exercises: exercises ?? _exercises,
      searchFieldController:
          searchFieldController ?? this.searchFieldController,
      selectedMuscleGroups: selectedMuscleGroups ?? this.selectedMuscleGroups,
      selectedEquipment: selectedEquipment ?? this.selectedEquipment,
      status: status ?? this.status,
    );
  }

  @override
  String toString() {
    return '''ExerciseListState(exercises: $_exercises,
             query: query,
             selected muscle groups: $selectedMuscleGroups,
             selected equipment: $selectedEquipment,
             status: $status)''';
  }
}
