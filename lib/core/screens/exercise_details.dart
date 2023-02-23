import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rahener/core/models/muscle_group.dart';
import 'package:rahener/core/widgets/equipment_label.dart';
import 'package:rahener/core/widgets/exercise_steps_segment.dart';
import 'package:rahener/core/widgets/exercise_tips_segment.dart';
import 'package:rahener/core/widgets/muscle_label.dart';
import 'package:rahener/core/widgets/similar_exercises_segment.dart';
import 'package:rahener/utils/constants.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../blocs/exercise_list_cubit.dart';
import '../models/exercise.dart';

class ExerciseDetailsScreen extends StatefulWidget {
  final Exercise exercise;
  final List<Exercise> similarExercises;
  final AssetImage exerciseImage;
  const ExerciseDetailsScreen(
      {super.key,
      required this.exercise,
      required this.exerciseImage,
      required this.similarExercises});

  @override
  State<ExerciseDetailsScreen> createState() => _ExerciseDetailsScreenState();
}

class _ExerciseDetailsScreenState extends State<ExerciseDetailsScreen> {
  String _selectedSegment = 'steps';
  final List<String> _segmentValues = ['steps', 'tips', 'similarExercises'];

  void _onSegmentChanged(Set<String> newSelection) {
    setState(() {
      _selectedSegment = newSelection.first;
    });
  }

  Widget _lowerPanel() {
    var bloc = BlocProvider.of<ExerciseListCubit>(context);
    if (_selectedSegment == _segmentValues[0]) {
      return ExerciseStepsSegment(steps: widget.exercise.steps);
    } else if (_selectedSegment == _segmentValues[1]) {
      return ExerciseTipsSegment(tips: widget.exercise.tips);
    } else if (_selectedSegment == _segmentValues[2]) {
      return SimilarExercisesSegment(
          similarExercises: widget.similarExercises,
          onExerciseTapped: bloc.onExerciseTapped);
    }
    throw Exception("segment value not present in segmentvalue list");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        margin: const EdgeInsets.only(
            left: Constants.sideMargin, right: Constants.sideMargin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 2,
              child: Stack(
                  fit: StackFit.loose,
                  alignment: Alignment.center,
                  children: [
                    Image(image: widget.exerciseImage),
                    MusclesLabel(
                        primaryMuscles: widget.exercise.primaryMuscles,
                        secondaryMuscles: widget.exercise.secondaryMuscles),
                    EquipmentLabel(
                      equipment: widget.exercise.equipment,
                    ),
                  ]),
            ),
            Container(height: Constants.margin5),
            Flexible(
                flex: 1,
                child: SegmentedButton<String>(
                  multiSelectionEnabled: false,
                  showSelectedIcon: false,
                  segments: <ButtonSegment<String>>[
                    ButtonSegment<String>(
                        value: _segmentValues[0],
                        label: Text(AppLocalizations.of(context)!.stepsSegment),
                        icon: const Icon(Constants.exerciseStepsIcon)),
                    ButtonSegment<String>(
                        value: _segmentValues[1],
                        label: Text(AppLocalizations.of(context)!.tipsSegment),
                        icon: const Icon(Constants.exerciseTipsIcon)),
                    ButtonSegment<String>(
                        value: _segmentValues[2],
                        label: FittedBox(
                          child: Text(
                            AppLocalizations.of(context)!
                                .similarExercisesSEgment,
                            maxLines: 1,
                          ),
                        ),
                        icon: const Icon(Constants.similarExercisesIcon)),
                  ],
                  selected: <String>{_selectedSegment},
                  onSelectionChanged: (Set<String> newSelection) {
                    _onSegmentChanged(newSelection);
                  },
                )),
            Container(height: Constants.margin5),
            Expanded(
              flex: 3,
              child: _lowerPanel(),
            ),
          ],
        ),
      ),
    );
  }
}
