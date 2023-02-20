import 'package:flutter/material.dart';

import '../../utils/constants.dart';

class ExerciseStepsSegment extends StatelessWidget {
  final List<String> steps;
  const ExerciseStepsSegment({super.key, required this.steps});

  TextSpan _listNumberText(BuildContext context, int index) {
    return TextSpan(
        text: "${index + 1}- ",
        style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.w700));
  }

  @override
  Widget build(BuildContext context) {
    int index = 0;

    return Text.rich(TextSpan(
        style: const TextStyle(fontSize: Constants.fontSize4),
        children: steps.map((step) {
          return TextSpan(children: [
            _listNumberText(context, index++),
            TextSpan(text: "$step\n\n")
          ]);
        }).toList()));
  }
}
