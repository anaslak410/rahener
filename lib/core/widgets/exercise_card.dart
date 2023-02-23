import 'package:flutter/material.dart';

class ExerciseCard extends StatelessWidget {
  final String exerciseName;
  final String firstPrimaryMuscle;
  final String equipmentName;
  final Function() onTap;

  const ExerciseCard({
    super.key,
    required this.exerciseName,
    required this.firstPrimaryMuscle,
    required this.equipmentName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      horizontalTitleGap: 1,
      title: Text(exerciseName),
      subtitle: Text("$firstPrimaryMuscle | $equipmentName"),
      trailing: const Icon(Icons.arrow_right),
      onTap: onTap,
    );
  }
}
