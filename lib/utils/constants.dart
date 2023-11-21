import 'package:flutter/material.dart';
import 'package:rahener/core/blocs/ExerciseSet.dart';
import 'package:rahener/core/models/exercise.dart';
import 'package:rahener/core/models/session.dart';

class Constants {
  // margins
  static const margin1 = 2.0;
  static const margin2 = 4.0;
  static const margin3 = 8.0;
  static const margin4 = 12.0;
  static const margin5 = 16.0;
  static const margin6 = 24.0;
  static const margin7 = 32.0;
  static const margin8 = 44.0;
  static const margin9 = 64.0;
  static const margin10 = 96.0;
  static const margin11 = 128.0;

  static const sideMargin = 16.0;
  static const chipSpacing = 12.0;
  static const chipRunSpacing = 5.0;

  // font weights
  static const double fontWeight1 = 10.0;
  static const double fontWeight2 = 12.0;
  static const double fontWeight3 = 14.0;
  static const double fontWeight4 = 16.0;
  static const double fontWeight5 = 18.0;
  static const double fontWeight6 = 20.0;
  static const double fontWeight7 = 24.0;
  static const double fontWeight8 = 30.0;
  static const double fontWeight9 = 36.0;

  // font sizes

  static const double fontSize1 = 10.0;
  static const double fontSize2 = 12.0;
  static const double fontSize3 = 14.0;
  static const double fontSize4 = 16.0;
  static const double fontSize5 = 18.0;
  static const double fontSize6 = 20.0;
  static const double fontSize7 = 24.0;
  static const double fontSize8 = 30.0;
  static const double fontSize9 = 36.0;

  // icons

  static const IconData cancelSearchIcon = Icons.cancel_sharp;
  static const IconData searchBarPrefixIcon = Icons.search;
  static const IconData filterIcon = Icons.filter_alt;
  static const IconData exerciseStepsIcon = Icons.list;
  static const IconData exerciseTipsIcon = Icons.tips_and_updates;
  static const IconData similarExercisesIcon = Icons.two_k;
  static const IconData emptyListIcon = Icons.cancel_outlined;
  static const IconData profileIcon = Icons.person_2;
  static const IconData sessionIcon =
      IconData(0xe28d, fontFamily: 'MaterialIcons');
  static const IconData exercisesListIcon = Icons.list_alt;
  static const IconData progressIcon = Icons.trending_up;

  static const double borderRadius = 10;
  static const String testPhoneNUmber = "+17700000000";
  static const String testVerificationCode = "111111";

  static List<Session> testSessions = [
    Session(
      datePerformed: DateTime.parse("2023-11-12T19:45:00"),
      duration: Duration(hours: 1),
      exercisesPerfomed: [
        SessionExercise(
          id: "10",
          name: "Plank",
          equipment: "None",
          primaryMuscles: ["Core"],
          secondaryMuscles: ["Shoulders"],
          tips: ["Keep your body in a straight line", "Engage your core"],
          steps: [
            "Start in a push-up position",
            "Hold the position with a straight back"
          ],
          sets: [
            ExerciseSet(reps: 30, weight: 0.0),
            ExerciseSet(reps: 25, weight: 0.0),
            ExerciseSet(reps: 20, weight: 0.0),
          ],
          similarExercises: <String>[],
        ),
        SessionExercise(
          id: "12",
          name: "Deadlift",
          equipment: "Barbell",
          primaryMuscles: ["Lower Back", "Hamstrings"],
          secondaryMuscles: ["Glutes"],
          tips: ["Keep your back straight", "Engage your core"],
          steps: [
            "Stand with feet hip-width apart",
            "Lower the barbell to the ground",
            "Stand back up"
          ],
          sets: [
            ExerciseSet(reps: 12, weight: 100.0),
            ExerciseSet(reps: 10, weight: 120.0),
            ExerciseSet(reps: 8, weight: 140.0),
          ],
          similarExercises: <String>[],
        ),
        SessionExercise(
          id: "15",
          name: "Lunges",
          equipment: "None",
          primaryMuscles: ["Quadriceps", "Glutes"],
          secondaryMuscles: ["Hamstrings"],
          tips: [
            "Step forward with good posture",
            "Keep your knee directly above your ankle"
          ],
          steps: [
            "Take a step forward with one leg",
            "Lower your body until both knees are bent",
            "Step back to the starting position"
          ],
          sets: [
            ExerciseSet(reps: 15, weight: 5.0),
            ExerciseSet(reps: 12, weight: 8.0),
            ExerciseSet(reps: 10, weight: 0.0),
          ],
          similarExercises: <String>[],
        ),
      ],
    ),
  ];
}
