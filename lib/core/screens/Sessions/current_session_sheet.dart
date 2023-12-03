// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rahener/core/blocs/current_session_cubit.dart';
import 'package:rahener/core/blocs/current_session_state.dart';
import 'package:rahener/core/blocs/session_timer_cubit.dart';
import 'package:rahener/core/blocs/sessions_cubit.dart';
import 'package:rahener/core/models/exercise.dart';
import 'package:rahener/core/screens/sessions/curr_session_exercise_item.dart';
import 'package:rahener/core/screens/sessions/discard_session_button.dart';
import 'package:rahener/core/screens/sessions/finish_session_button.dart';
import 'package:rahener/core/widgets/custom_dragging_handle.dart';
import 'package:rahener/core/widgets/exercise_card.dart';
import 'package:rahener/utils/constants.dart';

class CurrentSessionSheet extends StatefulWidget {
  const CurrentSessionSheet({
    super.key,
  });

  @override
  State<CurrentSessionSheet> createState() => _CurrentSessionSheetState();
}

class _CurrentSessionSheetState extends State<CurrentSessionSheet>
    with SingleTickerProviderStateMixin {
  late final CurrentSessionCubit _bloc;
  late AnimationController _animationController;
  late Animation<Offset> _animation;

  void _onDiscardButtonPressed() async {
    bool result = await _showCancelWorkoutDialog();
    if (result) {
      _bloc.discardSession();
    }
  }

  SnackBar _buildSessionSavedSnackbar({
    required String message,
    required BuildContext context,
  }) {
    return SnackBar(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(message, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4), // Add some spacing
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      duration: const Duration(seconds: 5),
      behavior: SnackBarBehavior.floating,
      action: SnackBarAction(
        label: 'OK',
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    );
  }

  Future<bool> _showCancelWorkoutDialog() async {
    bool wantsToCancel = false;
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Cancel Workout?'),
          content: Text(
              'Are you sure you want to cancel this session? All progress will be lost.'),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: <Widget>[
            FilledButton(
              child: Text('Cancel Session'),
              onPressed: () {
                wantsToCancel = true;
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Constants.borderRadius),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('resume'),
            ),
          ],
        );
      },
    );
    return wantsToCancel;
  }

  void _onFinishSessionButtonPressed() {
    if (_bloc.state.exercisesPerfomed.isEmpty) {
      _onDiscardButtonPressed();
    } else {
      Duration duration = context.read<SessionTimerCubit>().state;
      log(_bloc.state.exercisesPerfomed.toString());
      context.read<SessionsCubit>().addSession(_bloc.getSession(duration));
      var snackbar = _buildSessionSavedSnackbar(
          message: "Session Saved", context: context);
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
      _bloc.saveAndEndSession(duration);
    }
  }

  void _onRemoveExerciseButtonPressed(String id) {
    _bloc.removeExercise(id);
  }

  void _onAddSetButtonPressed(String id) {
    _bloc.addSet(id);
  }

  void _onAddExerciseButtonPressed(
      BuildContext context, CurrentSessionState blocstate) {
    showDialog(
      context: context,
      builder: (context) {
        List<Exercise> availableExercises = _bloc.getAvailableExercises();
        return AlertDialog(
          content: SizedBox(
            height: 300,
            width: 200,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: availableExercises.length,
              itemBuilder: (context, index) {
                Exercise exercise = availableExercises[index];
                return ExerciseCard(
                    exerciseName: exercise.name,
                    firstPrimaryMuscle: exercise.primaryMuscle,
                    equipmentName: exercise.equipment,
                    onTap: () {
                      Navigator.of(context).pop();
                      _bloc.addExercise(exercise);
                    });
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildTopRow() {
    return Container(
      height: 100,
      padding: const EdgeInsets.only(top: Constants.margin3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FinishSessionButton(onPressed: _onFinishSessionButtonPressed),
          BlocBuilder<SessionTimerCubit, Duration>(
            builder: (context, stat) {
              return Text(
                  "${stat.inHours}:${stat.inMinutes.remainder(60)}:${(stat.inSeconds.remainder(60))}");
            },
          ),
          DiscardSessionButton(onPress: _onDiscardButtonPressed),
        ],
      ),
    );
  }

  Widget _buildPerformedExercisesList(BuildContext context,
      ScrollController scrollController, CurrentSessionState blocstate) {
    return SizedBox(
        height: MediaQuery.of(context).size.height * 0.9,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: Constants.margin10,
              ),
              ListView.builder(
                itemCount: blocstate.exercisesPerfomed.length,
                shrinkWrap: true,
                key: UniqueKey(),
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return SessionExerciseItem(
                    onRemoveExercise: _onRemoveExerciseButtonPressed,
                    onAddSet: _onAddSetButtonPressed,
                    exercise: blocstate.exercisesPerfomed[index],
                    onRepsChanged: () {},
                    onWeightChanged: () {},
                  );
                },
              ),
              ElevatedButton(
                  onPressed: () {
                    _onAddExerciseButtonPressed(context, blocstate);
                  },
                  child: const Text("Exercise  +")),
            ],
          ),
        ));
  }

  @override
  void initState() {
    _bloc = BlocProvider.of<CurrentSessionCubit>(context);
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _animation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: const Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    log("session ended");
    _animationController.dispose();
    _bloc.discardSession();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrentSessionCubit, CurrentSessionState>(
      builder: (context, blocState) {
        return SlideTransition(
            position: _animation,
            child: () {
              return _bloc.state.isInProgress
                  ? DraggableScrollableSheet(
                      initialChildSize: 0.30,
                      minChildSize: 0.10,
                      maxChildSize: 0.9,
                      expand: false,
                      builder: (BuildContext context,
                          ScrollController scrollController) {
                        _animationController.forward();
                        return Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .secondaryContainer,
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(24),
                                topRight: Radius.circular(24)),
                          ),
                          padding: const EdgeInsets.only(
                              left: Constants.sideMargin,
                              right: Constants.sideMargin),
                          child: Stack(
                            children: [
                              _buildPerformedExercisesList(
                                  context, scrollController, blocState),
                              CustomDraggingHandle(),
                              _buildTopRow(),
                            ],
                          ),
                        );
                      },
                    )
                  : Container();
            }());
      },
    );
  }
}
