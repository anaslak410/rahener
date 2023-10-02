import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rahener/core/blocs/exercise_list_cubit.dart';
import 'package:rahener/core/widgets/exercise_card.dart';
import 'package:rahener/utils/constants.dart';

import '../blocs/exercise_list_state.dart';
import '../models/exercise.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ExercisesListScreen extends StatefulWidget {
  const ExercisesListScreen({super.key});

  @override
  State<ExercisesListScreen> createState() => _ExercisesListScreenState();
}

class _ExercisesListScreenState extends State<ExercisesListScreen> {
  Widget _searchField(ExerciseListCubit bloc) {
    return Expanded(
      flex: 5,
      child: TextField(
          controller: bloc.state.searchFieldController,
          onChanged: (value) => bloc.onSearchFiledChanged(value),
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context)!.searchFieldHint,
            filled: true,
            prefixIcon: const Icon(Constants.searchBarPrefixIcon),
            suffixIcon: bloc.shouldShowCancelIcon()
                ? IconButton(
                    icon: const Icon(Constants.cancelSearchIcon),
                    onPressed: bloc.onCancelQueryTapped,
                  )
                : null,
          )),
    );
  }

  Widget _filterButton(ExerciseListCubit bloc) {
    return Expanded(
      flex: 1,
      child: IconButton(
        onPressed: () {
          bloc.onFilterButtonTapped(context);
        },
        color: ThemeData().primaryColor,
        icon: const Icon(Constants.filterIcon),
        iconSize: 30,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<ExerciseListCubit>(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: (() {
          bloc.onCreateExerciseButtonTapped(context);
        }),
      ),
      body: BlocBuilder<ExerciseListCubit, ExerciseListState>(
        builder: (context, state) {
          return CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [_searchField(bloc), _filterButton(bloc)],
                ),
                pinned: false,
                floating: true,
                snap: false,
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
                          bloc.onExerciseTapped(context, exercise);
                        },
                        firstPrimaryMuscle: exercise.primaryMuscles.first,
                        equipmentName: exercise.equipment))
                    .toList()
              ])),
            ],
          );
        },
      ),
    );
  }
}
