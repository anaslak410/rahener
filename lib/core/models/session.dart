// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:rahener/core/models/exercise.dart';

class Session {
  final DateTime datePerformed;
  final Duration duration;
  final List<SessionExercise> exercisesPerfomed;

  Session({
    required this.datePerformed,
    required this.duration,
    required this.exercisesPerfomed,
  });
}
