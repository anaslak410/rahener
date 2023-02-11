import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rahener/core/repositories/exercises_repository.dart';
import 'package:rahener/core/screens/exercise_details.dart';
import 'ExerciseListState.dart';

class ExerciseListCubit extends Cubit<ExerciseListState> {
  final ExercisesRepository _exercisesRepository;

  ExerciseListCubit({required exercisesRepository})
      : _exercisesRepository = exercisesRepository,
        super(ExerciseListState()) {
    emit(state.copyWith(status: ExerciseListStatus.loading));

    emit(state.copyWith(
        status: ExerciseListStatus.success,
        exercises: _exercisesRepository.exercises,
        selectedEquipment: {
          for (var equipment in _exercisesRepository.equipment) equipment: false
        },
        selectedMuscleGroups: {
          for (var muscleGroup in _exercisesRepository.muscleGroupNames)
            muscleGroup: false
        }));
  }

  void onSearchFiledChanged(String query) {
    emit(state.copyWith());
  }

  void onMuscleFilterChipTapped(bool selected, String muscleGroupName) {
    var newSelectedMuscleGroups = state.selectedMuscleGroups;
    newSelectedMuscleGroups[muscleGroupName] = selected;
    emit(state.copyWith(selectedMuscleGroups: newSelectedMuscleGroups));
    selected = !selected;
  }

  void onEquipmentFilterChipTapped(bool selected, String equipmentName) {
    var newSelectedEquipment = state.selectedEquipment;
    newSelectedEquipment[equipmentName] = selected;
    emit(state.copyWith(selectedEquipment: newSelectedEquipment));
    selected = !selected;
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    log('$error, $stackTrace');
    super.onError(error, stackTrace);
  }

  void onCancelQueryTapped() {
    state.clearSearchQuery();
    emit(state.copyWith());
  }

  bool shouldShowCancelIcon() {
    return state.searchFieldController.text != "";
  }

  void onChipDeleteTapped(String chipName) {
    if (state.muscleGroupNames.contains(chipName)) {
      onMuscleFilterChipTapped(false, chipName);
    } else if (state.equipmentNames.contains(chipName)) {
      onEquipmentFilterChipTapped(false, chipName);
    }
  }

  onExerciseTapped(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ExerciseDetailsScreen()),
    );
  }

  bool chipFiltersAreSelected() => state.selectedChipFilters.isNotEmpty;
}
