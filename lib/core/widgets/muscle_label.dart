import 'package:flutter/material.dart';
import 'package:rahener/utils/constants.dart';

class MusclesLabel extends StatelessWidget {
  final String primaryMuscle;
  final List<String> secondaryMuscles;
  const MusclesLabel(
      {super.key, required this.primaryMuscle, required this.secondaryMuscles});

  String _secondaryMusclesText() {
    String text = "";
    for (var i = 0; i < secondaryMuscles.length - 1; i++) {
      text = "$text${secondaryMuscles[i]}\n\n";
    }
    text = "$text${secondaryMuscles.last}";

    return text;
  }

  String _primaryMuscleText() {
    String text = primaryMuscle;

    return text;
  }

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          constraints: const BoxConstraints(maxHeight: 150, maxWidth: 100),
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(Constants.borderRadius),
          ),
          child: IntrinsicWidth(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _primaryMuscleText(),
                  style: TextStyle(
                    fontSize: Constants.fontSize4,
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                    // decoration: TextDecoration(,
                  ),
                ),
                secondaryMuscles.isNotEmpty
                    ? const Divider(
                        height: 8,
                        indent: 20,
                        endIndent: 20,
                      )
                    : Container(),
                secondaryMuscles.isNotEmpty
                    ? Text(
                        _secondaryMusclesText(),
                        style: TextStyle(
                          fontSize: Constants.fontSize1,
                          height: 1.2,
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                          // decoration: TextDecoration(,
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        ));
  }
}
