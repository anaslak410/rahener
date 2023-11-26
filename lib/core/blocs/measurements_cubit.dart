// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:core';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rahener/core/models/measurement.dart';
import 'package:rahener/core/models/measurement_entry.dart';
import 'package:rahener/core/repositories/measurement_repository.dart';

class MeasurementsCubit extends Cubit<MeasurementsState> {
  final MeasurementsRepository _repository;

  MeasurementsCubit({required MeasurementsRepository repository})
      : _repository = repository,
        super(MeasurementsLoading()) {
    var measurements = _repository.measurements;
    emit(
        MeasurementsLoaded(measurements: measurements, measurementEntries: {}));

    _subscribe();
  }
  void _subscribe() {
    _repository.measurementsStream.listen(
      (items) {
        MeasurementsLoaded newState = state as MeasurementsLoaded;
        emit(newState.copyWith(measurements: items));
      },
      onError: (error) => log(error),
    );
  }

  void addMeasurement(Measurement measurement) {
    _repository.addMeasurement(measurement);
  }

  void removeMeasurement(String name) {
    _repository.removeMeasurement(name);
  }

  bool measurementExists(String name) {
    MeasurementsLoaded stat = state as MeasurementsLoaded;
    return stat._measurements
        .any((element) => element.name.toLowerCase() == name.toLowerCase());
  }
}

class MeasurementsState {}

class MeasurementsLoaded extends MeasurementsState {
  final List<Measurement> _measurements;
  final Map<String, List<MeasurementEntry>> _measurementEntries;

  MeasurementsLoaded({
    required List<Measurement> measurements,
    required Map<String, List<MeasurementEntry>> measurementEntries,
  })  : _measurementEntries = measurementEntries,
        _measurements = measurements;

  List<Measurement> get measurements {
    return _measurements;
  }

  List<MeasurementEntry> getMeasurementEntries(String id) {
    try {
      return _measurementEntries[id]!;
    } catch (e) {
      throw Exception(
          "attempted to get entries for a measurement that does not exist");
    }
  }

  MeasurementsLoaded copyWith({
    List<Measurement>? measurements,
    Map<String, List<MeasurementEntry>>? measurementEntries,
  }) {
    return MeasurementsLoaded(
      measurements: measurements ?? _measurements,
      measurementEntries: measurementEntries ?? _measurementEntries,
    );
  }
}

class MeasurementsLoading extends MeasurementsState {}
