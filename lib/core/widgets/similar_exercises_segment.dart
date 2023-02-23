import 'package:flutter/material.dart';
import 'package:rahener/core/models/exercise.dart';

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
    return ListView.builder(
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
        });
  }
}
