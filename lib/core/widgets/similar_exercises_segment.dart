import 'package:flutter/material.dart';
import 'package:rahener/core/models/exercise.dart';
import 'package:rahener/utils/constants.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'exercise_card.dart';

class SimilarExercisesSegment extends StatelessWidget {
  final List<Exercise> similarExercises;
  final Function onExerciseTapped;
  const SimilarExercisesSegment(
      {super.key,
      required this.similarExercises,
      required this.onExerciseTapped});

  @override
  Widget build(BuildContext context) {
    return similarExercises.isNotEmpty
        ? ListView.builder(
            itemCount: similarExercises.length,
            itemBuilder: (BuildContext context, int index) {
              Exercise exercise = similarExercises[index];
              return ExerciseCard(
                equipmentName: exercise.equipment,
                exerciseName: exercise.name,
                firstPrimaryMuscle: exercise.primaryMuscles.first,
                onTap: () {
                  onExerciseTapped(context, exercise);
                },
              );
            })
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Constants.emptyListIcon,
                color: Theme.of(context).disabledColor,
                size: 80,
              ),
              Container(height: Constants.margin4),
              Text(
                AppLocalizations.of(context)!.emptySimilarExercises,
                style: const TextStyle(fontSize: Constants.fontSize5),
              ),
              Container(height: Constants.margin11),
            ],
          );
  }
}
