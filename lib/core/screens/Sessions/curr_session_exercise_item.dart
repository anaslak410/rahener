import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rahener/core/blocs/ExerciseSet.dart';
import 'package:rahener/core/models/exercise.dart';
import 'package:rahener/utils/constants.dart';

class SessionExerciseItem extends StatefulWidget {
  final SessionExercise exercise;
  final Function onAddSet;
  final Function onRemoveExercise;
  final Function onRepsChanged;
  final Function onWeightChanged;

  const SessionExerciseItem({
    Key? key,
    required this.exercise,
    required this.onAddSet,
    required this.onRemoveExercise,
    required this.onRepsChanged,
    required this.onWeightChanged,
  }) : super(key: key);

  @override
  State<SessionExerciseItem> createState() => _SessionExerciseItemState();
}

class _SessionExerciseItemState extends State<SessionExerciseItem> {
  late SessionExercise exercise;
  @override
  void initState() {
    exercise = widget.exercise;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              exercise.name,
              style: const TextStyle(
                  fontSize: Constants.fontSize4, fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 30,
              width: 40,
              child: ElevatedButton(
                  style: TextButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(Constants.borderRadius),
                    ),
                  ),
                  onPressed: () => widget.onRemoveExercise(exercise.id),
                  child: Text(
                    "x",
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.error),
                  )),
            )
          ],
        ),
        const SizedBox(
          height: Constants.margin5,
        ),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Container(
              padding:
                  const EdgeInsets.only(left: 13, right: 13, bottom: 6, top: 6),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: const BorderRadius.all(
                      Radius.circular(Constants.borderRadius))),
              child: Text(
                'Set',
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onSecondary),
              )),
          Container(
              padding:
                  const EdgeInsets.only(left: 13, right: 13, bottom: 6, top: 6),
              margin: EdgeInsets.only(right: 80),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: const BorderRadius.all(
                      Radius.circular(Constants.borderRadius))),
              child: Text(
                'Reps',
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onSecondary),
              )),
          Container(
              padding: EdgeInsets.only(left: 13, right: 13, bottom: 6, top: 6),
              margin: EdgeInsets.only(right: 45),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.all(
                      Radius.circular(Constants.borderRadius))),
              child: Text(
                'Weight',
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onSecondary),
              )),
        ]),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: exercise.sets.length,
          padding: const EdgeInsets.symmetric(vertical: 16),
          itemBuilder: (BuildContext context, int index) {
            ExerciseSet entry = exercise.sets[index];
            TextEditingController repsController = TextEditingController(
                text: entry.reps == 0 ? "" : entry.reps.toString());

            TextEditingController weightController = TextEditingController(
                text: entry.weight == 0.0 ? "" : entry.weight.toString());

            return Dismissible(
              direction: DismissDirection.endToStart,
              background: Container(
                padding: const EdgeInsets.only(left: 300),
                color: Theme.of(context).colorScheme.error,
                child: Center(
                    child: Text(
                  "remove",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onSecondary,
                      fontWeight: FontWeight.w600,
                      fontSize: Constants.fontSize4),
                )),
              ),
              onDismissed: (direction) {
                setState(() {
                  exercise.sets.removeAt(index);
                });
              },
              key: UniqueKey(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    child: TextField(
                      decoration: const InputDecoration(
                          filled: true, counterText: "", hintText: "0"),
                      maxLength: 8,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      controller: repsController,
                      onChanged: (value) {
                        entry.reps = int.tryParse(value) ?? 0;
                        // weightController.text = entry.reps.toString();
                      },
                    ),
                  ),
                  SizedBox(
                    width: 150,
                    child: TextField(
                      decoration: const InputDecoration(
                          filled: true, counterText: "", hintText: "0"),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
                        TextInputFormatter.withFunction((oldValue, newValue) {
                          final text = newValue.text;
                          return text.isEmpty
                              ? newValue
                              : double.tryParse(text) == null
                                  ? oldValue
                                  : newValue;
                        }),
                      ],
                      maxLength: 5,
                      keyboardType: TextInputType.number,
                      controller: weightController,
                      onChanged: (value) {
                        entry.weight = double.tryParse(value) ?? 0.0;
                      },
                    ),
                  ),
                ],
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return Divider();
          },
        ),
        ButtonBar(
          alignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () => widget.onAddSet(exercise.id),
              child: const Text('Set +'),
            ),
          ],
        ),
      ],
    );
  }
}
