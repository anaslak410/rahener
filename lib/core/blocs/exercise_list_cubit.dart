import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rahener/core/repositories/exercises_repository.dart';
import 'package:rahener/core/screens/exercise_details.dart';
import 'package:rahener/core/screens/exercise_filter_dialog.dart';
import '../models/exercise.dart';
import 'exercise_list_state.dart';

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
        selectedPrimaryMuscles: {
          for (var muscleGroup in _exercisesRepository.muscleNames)
            muscleGroup: false
        }));
  }

  void onSearchFiledChanged(String query) {
    emit(state.copyWith());
  }

  void onMuscleFilterChipTapped(bool selected, String muscleGroupName) {
    var newSelectedMuscleGroups = state.selectedPrimaryMuscles;
    newSelectedMuscleGroups[muscleGroupName] = selected;
    emit(state.copyWith(selectedPrimaryMuscles: newSelectedMuscleGroups));
    selected = !selected;
  }

  void onEquipmentFilterChipTapped(bool selected, String equipmentName) {
    var newSelectedEquipment = state.selectedEquipment;
    newSelectedEquipment[equipmentName] = selected;
    emit(state.copyWith(selectedEquipment: newSelectedEquipment));
    selected = !selected;
  }

  void onCancelQueryTapped() {
    state.clearSearchQuery();
    emit(state.copyWith());
  }

  void onChipDeleteTapped(String chipName) {
    if (state.primaryMuscleGroupNames.contains(chipName)) {
      onMuscleFilterChipTapped(false, chipName);
    } else if (state.equipmentNames.contains(chipName)) {
      onEquipmentFilterChipTapped(false, chipName);
    }
  }

  void onExerciseTapped(BuildContext context, Exercise exercise) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => BlocProvider.value(
              value: this,
              child: ExerciseDetailsScreen(
                exercise: exercise,
                exerciseImage: _getExerciseImage(exercise.id),
                similarExercises: _getSimilarExercises(exercise),
              ))),
    );
  }

  List<Exercise> _getSimilarExercises(Exercise exercise) {
    List<Exercise> similarExercises = state.allExercises.where((element) {
      for (var muscle in exercise.primaryMuscles) {
        if (element.primaryMuscles.contains(muscle)) {
          return true;
        }
      }
      return false;
    }).toList();

    // remove current exercise
    similarExercises.removeWhere((element) => element.id == exercise.id);

    return similarExercises;
  }

  void onFilterButtonTapped(BuildContext context) {
    showDialog<String>(
      context: context,
      builder: (_) => Dialog.fullscreen(
        child: BlocProvider.value(
          value: this,
          child: const ExerciseFilterDialog(),
        ),
      ),
    );
  }

  bool chipFiltersAreSelected() => state.selectedChipFilters.isNotEmpty;

  bool shouldShowCancelIcon() {
    return state.searchFieldController.text != "";
  }

  AssetImage _getExerciseImage(String id) {
    return _exercisesRepository.getExerciseImage(id);
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    log('$error, $stackTrace');
    super.onError(error, stackTrace);
  }
}
