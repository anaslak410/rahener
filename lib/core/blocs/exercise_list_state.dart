import 'package:flutter/widgets.dart';
import '../models/exercise.dart';

enum ExerciseListStatus { initial, loading, success, failure }

class ExerciseListState {
  ExerciseListStatus status;
  final List<Exercise> _exercises;

  late TextEditingController searchFieldController;

  final Map<String, bool> selectedPrimaryMuscles;
  final Map<String, bool> selectedEquipment;

  ExerciseListState({
    List<Exercise> exercises = const [],
    TextEditingController? searchFieldController,
    this.selectedPrimaryMuscles = const {},
    this.selectedEquipment = const {},
    this.status = ExerciseListStatus.success,
  }) : _exercises = exercises {
    this.searchFieldController =
        searchFieldController ?? TextEditingController();
  }

  List<Exercise> get filteredExercises {
    bool primaryMuscleFilterIsOn = _primaryMuscleFilterIsOn();
    bool equipmentFilterIsOn = _equipmentFilterIsOn();

    List<Exercise> filteredExercises = _exercises.where((exercise) {
      if (primaryMuscleFilterIsOn) {
        if (!_primaryMuscleFilterApplies(exercise.primaryMuscles)) {
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

  List<String> get primaryMuscleGroupNames =>
      selectedPrimaryMuscles.keys.toList();
  List<String> get equipmentNames => selectedEquipment.keys.toList();

  List<String> get selectedChipFilters {
    return [
      ...selectedPrimaryMuscles.entries
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

  bool _primaryMuscleFilterIsOn() {
    for (MapEntry element in selectedPrimaryMuscles.entries) {
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

  bool primaryMuscleIsSelected(String primaryMuscleGroup) {
    return selectedPrimaryMuscles.entries
        .firstWhere((element) => element.key == primaryMuscleGroup)
        .value;
  }

  bool equipmentIsSelected(String equipmentName) {
    return selectedEquipment.entries
        .firstWhere((element) => element.key == equipmentName)
        .value;
  }

  bool _primaryMuscleFilterApplies(List<String> primaryMuscles) {
    for (var muscle in primaryMuscles) {
      if (selectedPrimaryMuscles[muscle]!) {
        return true;
      }
    }
    return false;
  }

  bool _equipmentFilterApplies(String equipmentName) {
    return selectedEquipment[equipmentName]!;
  }

  ExerciseListState copyWith({
    List<Exercise>? exercises,
    TextEditingController? searchFieldController,
    Map<String, bool>? selectedPrimaryMuscles,
    Map<String, bool>? selectedEquipment,
    List<String>? equipments,
    ExerciseListStatus? status,
  }) {
    return ExerciseListState(
      exercises: exercises ?? _exercises,
      searchFieldController:
          searchFieldController ?? this.searchFieldController,
      selectedPrimaryMuscles:
          selectedPrimaryMuscles ?? this.selectedPrimaryMuscles,
      selectedEquipment: selectedEquipment ?? this.selectedEquipment,
      status: status ?? this.status,
    );
  }

  @override
  String toString() {
    return '''ExerciseListState(exercises: $_exercises,
             query: query,
             selected muscle groups: $selectedPrimaryMuscles,
             selected equipment: $selectedEquipment,
             status: $status)''';
  }
}
