import 'package:flutter/material.dart';
import 'package:rahener/core/models/exercise_set.dart';
import 'package:rahener/core/models/exercise.dart';
import 'package:rahener/core/models/measurement.dart';
import 'package:rahener/core/models/measurement_entry.dart';
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

  // value constraints

  static const int maxMeasurementEntry = 6;

  // testing
  static List<Measurement> testMeasurements = [
    Measurement(name: "Weight", unit: "kg"),
  ];

  static List<Session> testSessions = generateProgressTestingSessions();

  static Map<String, List<MeasurementEntry>> testMeasurementEntries = {
    testMeasurements[0].name: [
      MeasurementEntry(
          value: 79,
          entryDate: DateTime.now().subtract(const Duration(days: 400))),
      MeasurementEntry(
          value: 80,
          entryDate: DateTime.now().subtract(const Duration(days: 90))),
      MeasurementEntry(
          value: 74,
          entryDate: DateTime.now().subtract(const Duration(days: 80))),
      MeasurementEntry(
          value: 73.2,
          entryDate: DateTime.now().subtract(const Duration(days: 35))),
      MeasurementEntry(
          value: 50,
          entryDate: DateTime.now().subtract(const Duration(days: 30))),
      MeasurementEntry(
          value: 65.3,
          entryDate: DateTime.now().subtract(const Duration(days: 7))),
      MeasurementEntry(
          value: 65.4,
          entryDate: DateTime.now().subtract(const Duration(days: 3))),
      MeasurementEntry(
          value: 70,
          entryDate: DateTime.now().subtract(const Duration(days: 1))),
      MeasurementEntry(
          value: 65,
          entryDate: DateTime.now().subtract(const Duration(days: 0))),
    ]
  };

  static List<Session> generateProgressTestingSessions() {
    List<Session> sessions = [];
    List<double> weights = [
      100.0,
      120.0,
      140.0,
      110.0,
      130.0,
      150.0,
      120.0,
      140.0,
      160.0,
      130.0,
      150.0,
      170.0,
      140.0,
      160.0,
      180.0,
      150.0,
      170.0,
      190.0,
      160.0,
      180.0
    ];
    List<DateTime> dates = [
      DateTime.now().subtract(Duration(days: 300, hours: 5, minutes: 45)),
      DateTime.now().subtract(Duration(days: 250, hours: 6, minutes: 15)),
      DateTime.now().subtract(Duration(days: 225, hours: 7, minutes: 0)),
      DateTime.now().subtract(Duration(days: 222, hours: 6, minutes: 30)),
      DateTime.now().subtract(Duration(days: 200, hours: 5, minutes: 0)),
      DateTime.now().subtract(Duration(days: 190, hours: 6, minutes: 45)),
      DateTime.now().subtract(Duration(days: 180, hours: 7, minutes: 15)),
      DateTime.now().subtract(Duration(days: 177, hours: 6, minutes: 0)),
      DateTime.now().subtract(Duration(days: 160, hours: 5, minutes: 30)),
      DateTime.now().subtract(Duration(days: 100, hours: 5, minutes: 15)),
      DateTime.now().subtract(Duration(days: 60, hours: 5, minutes: 30)),
      DateTime.now().subtract(Duration(days: 55, hours: 6, minutes: 45)),
      DateTime.now().subtract(Duration(days: 13, hours: 5, minutes: 15)),
      DateTime.now().subtract(Duration(days: 11, hours: 7, minutes: 0)),
      DateTime.now().subtract(Duration(days: 9, hours: 6, minutes: 30)),
      DateTime.now().subtract(Duration(days: 7, hours: 5, minutes: 0)),
      DateTime.now().subtract(Duration(days: 5, hours: 6, minutes: 15)),
      DateTime.now().subtract(Duration(days: 3, hours: 7, minutes: 45)),
      DateTime.now().subtract(Duration(days: 2, hours: 6, minutes: 30)),
      DateTime.now().subtract(Duration(days: 1, hours: 5, minutes: 15)),
    ];
    for (var i = 0; i < 20; i++) {
      Session session = Session(
        // datePerformed: DateTime.parse("${dates[i]}T19:45:00"),
        datePerformed: dates[i],
        duration: const Duration(hours: 1),
        exercisesPerfomed: [
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
              ExerciseSet(reps: 8, weight: weights[i]),
            ],
            similarExercises: <String>[],
          ),
        ],
      );

      sessions.add(session);
    }

    return sessions;
  }
}
