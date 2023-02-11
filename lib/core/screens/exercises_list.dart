import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rahener/core/blocs/filter_cubit.dart';
import 'package:rahener/core/widgets/exercise_card.dart';
import 'package:rahener/core/widgets/exercises_search_bar.dart';
import 'package:rahener/utils/constants.dart';

import '../blocs/ExerciseListState.dart';
import '../models/exercise.dart';
import 'exercise_filter_dialog.dart';

class ExercisesListScreen extends StatefulWidget {
  const ExercisesListScreen({super.key});

  @override
  State<ExercisesListScreen> createState() => _ExercisesListScreenState();
}

class _ExercisesListScreenState extends State<ExercisesListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: BlocBuilder<ExerciseListCubit, ExerciseListState>(
      builder: (context, state) {
        var bloc = BlocProvider.of<ExerciseListCubit>(context);
        return CustomScrollView(
          slivers: <Widget>[
            const ExerciseSearchBar(
              filterDialog: ExerciseFilterDialog(),
            ),
            SliverList(
                delegate: SliverChildListDelegate([
              bloc.chipFiltersAreSelected()
                  ? Container(
                      padding: const EdgeInsets.only(
                          left: Constants.sideMargin,
                          right: Constants.sideMargin,
                          bottom: Constants.margin4,
                          top: Constants.margin4),
                      child: Wrap(
                        runSpacing: Constants.chipRunSpacing,
                        spacing: Constants.chipSpacing,
                        children: List.generate(
                            state.selectedChipFilters.length, (index) {
                          String name = state.selectedChipFilters[index];
                          return InputChip(
                            label: Text(name),
                            onDeleted: () => bloc.onChipDeleteTapped(name),
                            isEnabled: true,
                          );
                        }),
                      ),
                    )
                  : Container(),
              ...state.filteredExercises
                  .map((Exercise exercise) => ExerciseCard(
                      exerciseName: exercise.name,
                      onTap: () {
                        bloc.onExerciseTapped(context);
                      },
                      muscleGroup: exercise.muscleGroupName,
                      equipmentName: exercise.equipment))
                  .toList()
            ])),
          ],
        );
      },
    ));
  }
}
