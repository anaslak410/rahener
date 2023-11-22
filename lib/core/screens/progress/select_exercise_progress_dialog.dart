import 'package:flutter/material.dart';
import 'package:rahener/core/blocs/exercise_progress_cubit.dart';
import 'package:rahener/core/widgets/exercise_card.dart';
import 'package:rahener/utils/constants.dart';

// class SelectExerciseProgressDialog extends StatelessWidget {
//   final List<ExerciseLog> availableExercises;
//   final Function onExerciseSelected;
//   const SelectExerciseProgressDialog(
//       this.availableExercises, this.onExerciseSelected,
//       {super.key});

//   @override
//   Widget build(BuildContext context) {
//     if (availableExercises.isEmpty) {
//       return AlertDialog(
//         title: const Text("No Exercises Available"),
//         content: const Text(
//             "You haven't performed any sessions to extract exercises from."),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//             child: const Text("OK"),
//           ),
//         ],
//       );
//     }
//     return AlertDialog(
//       content: SizedBox(
//         height: 200,
//         width: 150,
//         child: ListView.builder(
//           shrinkWrap: true,
//           itemCount: availableExercises.length,
//           itemBuilder: (context, index) {
//             ExerciseLog exercise = availableExercises[index];
//             return ListTile(
//               horizontalTitleGap: 1,
//               title: Text(
//                 exercise.name,
//                 style: TextStyle(),
//                 textAlign: TextAlign.center,
//               ),
//               onTap: () => onExerciseSelected(exercise.id),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

class SelectExerciseProgressDialog extends StatefulWidget {
  final List<ExerciseLog> availableExercises;
  final Function onExerciseSelected;

  SelectExerciseProgressDialog(this.availableExercises, this.onExerciseSelected,
      {Key? key})
      : super(key: key);

  @override
  _SelectExerciseProgressDialogState createState() =>
      _SelectExerciseProgressDialogState();
}

class _SelectExerciseProgressDialogState
    extends State<SelectExerciseProgressDialog> {
  late List<ExerciseLog> filteredExercises;

  @override
  void initState() {
    super.initState();
    filteredExercises = widget.availableExercises;
  }

  void _filterExercises(String query) {
    setState(() {
      filteredExercises = widget.availableExercises
          .where((exercise) =>
              exercise.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.availableExercises.isEmpty) {
      return AlertDialog(
        title: const Text("No Exercises Available"),
        content: const Text(
            "You haven't performed any sessions to extract exercises from."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("OK"),
          ),
        ],
      );
    }

    return AlertDialog(
      content: SizedBox(
        height: 250,
        width: 200,
        child: Column(
          children: [
            TextField(
                onChanged: _filterExercises,
                decoration: const InputDecoration(
                  hintText: "Search For Exercises",
                  filled: true,
                  prefixIcon: Icon(Constants.searchBarPrefixIcon),
                )),
            ListView.builder(
              shrinkWrap: true,
              itemCount: filteredExercises.length,
              itemBuilder: (context, index) {
                ExerciseLog exercise = filteredExercises[index];
                return ListTile(
                  horizontalTitleGap: 1,
                  title: Text(
                    exercise.name,
                    textAlign: TextAlign.center,
                  ),
                  onTap: () {
                    widget.onExerciseSelected(exercise.id);
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
