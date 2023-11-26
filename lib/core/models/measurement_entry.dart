// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:rahener/core/models/measurement.dart';

class MeasurementEntry {
  final String measurementId;
  final double value;
  final DateTime entryDate;
  MeasurementEntry({
    required this.measurementId,
    required this.value,
    required this.entryDate,
  });

  MeasurementEntry copyWith({
    String? measurementId,
    double? value,
    DateTime? entryDate,
  }) {
    return MeasurementEntry(
      measurementId: measurementId ?? this.measurementId,
      value: value ?? this.value,
      entryDate: entryDate ?? this.entryDate,
    );
  }
}
