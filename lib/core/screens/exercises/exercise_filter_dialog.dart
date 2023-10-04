import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rahener/core/blocs/exercise_list_cubit.dart';
import 'package:rahener/core/blocs/exercise_list_state.dart';
import 'package:rahener/utils/constants.dart';

class ExerciseFilterDialog extends StatefulWidget {
  const ExerciseFilterDialog({
    super.key,
  });

  @override
  State<ExerciseFilterDialog> createState() => _ExerciseFilterDialogState();
}

class _ExerciseFilterDialogState extends State<ExerciseFilterDialog> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocBuilder<ExerciseListCubit, ExerciseListState>(
      bloc: BlocProvider.of<ExerciseListCubit>(context),
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.only(
              left: Constants.sideMargin, right: Constants.sideMargin),
          child: Column(children: [
            Container(
              height: Constants.margin7,
            ),
            Text(AppLocalizations.of(context)!.muscleFilter),
            Container(
              height: Constants.margin3,
            ),
            Wrap(
              spacing: Constants.chipSpacing,
              runSpacing: Constants.chipRunSpacing,
              children:
                  List.generate(state.primaryMuscleGroupNames.length, (index) {
                bool isSelected = state.primaryMuscleIsSelected(
                    state.primaryMuscleGroupNames[index]);
                String name = state.primaryMuscleGroupNames[index];
                return FilterChip(
                    label: Text(name),
                    selected: isSelected,
                    onSelected: (bool selected) {
                      BlocProvider.of<ExerciseListCubit>(context)
                          .onMuscleFilterChipTapped(selected, name);
                    });
              }),
            ),
            Container(
              height: Constants.margin7,
            ),
            Text(AppLocalizations.of(context)!.equipmentFilter),
            Container(
              height: Constants.margin3,
            ),
            Wrap(
              spacing: Constants.chipSpacing,
              runSpacing: Constants.chipRunSpacing,
              children: List.generate(state.equipmentNames.length, (index) {
                bool isSelected =
                    state.equipmentIsSelected(state.equipmentNames[index]);
                String name = state.equipmentNames[index];
                return FilterChip(
                    label: Text(name),
                    selected: isSelected,
                    onSelected: (bool selected) {
                      BlocProvider.of<ExerciseListCubit>(context)
                          .onEquipmentFilterChipTapped(selected, name);
                    });
              }),
            ),
            Container(
              height: Constants.margin5,
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(AppLocalizations.of(context)!.filterDialogClose),
            ),
          ]),
        );
      },
    ));
  }
}
