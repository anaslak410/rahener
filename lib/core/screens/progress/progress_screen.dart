// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:developer';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rahener/core/blocs/exercise_progress_cubit.dart';
import 'package:rahener/core/screens/progress/progress_chart.dart';
import 'package:rahener/core/widgets/exercise_card.dart';
import 'package:rahener/utils/constants.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  late final ExerciseProgressCubit _bloc;

  @override
  void initState() {
    _bloc = BlocProvider.of<ExerciseProgressCubit>(context);
    super.initState();
  }

  void _onSelectExercisePressed(List<ExerciseLog> availableExercises) {
    showDialog(
      context: context,
      builder: (context) {
        if (availableExercises.isEmpty) {
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
            height: 300,
            width: 200,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: availableExercises.length,
              itemBuilder: (context, index) {
                ExerciseLog exercise = availableExercises[index];
                return ExerciseCard(
                    exerciseName: exercise.name,
                    firstPrimaryMuscle: "",
                    equipmentName: "",
                    onTap: () {
                      Navigator.of(context).pop();
                      _bloc.selectExercise(exercise.id);
                    });
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Progress")),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(
              left: Constants.sideMargin,
              right: Constants.sideMargin,
              top: Constants.sideMargin),
          child: BlocBuilder<ExerciseProgressCubit, ExerciseProgressState>(
              builder: (context, state) {
            if (state is ExerciseProgressLoaded) {
              return Column(
                children: [
                  ElevatedButton(
                      onPressed: () =>
                          _onSelectExercisePressed(state.availableExercises),
                      child: Text("Select Exercise")),
                  SizedBox(
                    height: Constants.margin4,
                  ),
                  state.selectedExercise != null
                      ? LineChartImp(name: state.selectedExercise!.name, values:
                          // state.selectedExercise!.entries
                          [
                          // (64.25, DateTime.parse("2021-02-13T00:00:00")),
                          (124.0, DateTime.parse("2022-03-13T00:00:00")),
                          (100.0, DateTime.parse("2022-11-01T00:00:00")),
                          (124.56, DateTime.parse("2022-11-03T00:00:00")),
                          (80.56, DateTime.parse("2022-11-07T00:00:00")),
                          (45.67, DateTime.parse("2022-11-09T00:00:00")),
                          (90.67, DateTime.parse("2022-11-20T00:00:00")),
                          (100.67, DateTime.parse("2022-11-22T00:00:00")),
                          (189.23, DateTime.parse("2023-03-18T00:00:00")),
                          (78.45, DateTime.parse("2023-05-16T00:00:00")),
                          (8.0, DateTime.parse("2023-09-17T00:00:00")),
                          (6.0, DateTime.parse("2023-10-17T00:00:00")),
                          (12.34, DateTime.parse("2023-11-17T00:00:00")),
                        ])
                      : Container(),
                ],
              );
            } else {
              return const CircularProgressIndicator(
                semanticsLabel: "Loading",
              );
            }
          }),
        ),
      ),
    );
  }
}
