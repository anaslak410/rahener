import 'dart:async';

import 'package:rahener/core/models/measurement.dart';
import 'package:rahener/core/models/measurement_entry.dart';
import 'package:rahener/core/services/local_data.dart';
import 'package:rahener/utils/constants.dart';

class MeasurementsRepository {
  final LocalDataService _localJsonDataService;

  final List<Measurement> _measurements = Constants.testMeasurements;
  final Map<String, List<MeasurementEntry>> _measurementEntries = {};

  final _measurementsController =
      StreamController<List<Measurement>>.broadcast();
  Stream<List<Measurement>> get measurementsStream =>
      _measurementsController.stream;

  MeasurementsRepository._create(
      {required LocalDataService localJsonDataService})
      : _localJsonDataService = localJsonDataService;
  static Future<MeasurementsRepository> create(
      {required LocalDataService localDataService}) async {
    var measurementsRepository =
        MeasurementsRepository._create(localJsonDataService: localDataService);

    return measurementsRepository;
  }

  List<Measurement> get measurements {
    return _measurements;
  }

  void addMeasurement(Measurement measurement) {
    _measurements.add(measurement);
    _measurementsController.sink.add(_measurements);
  }

  void removeMeasurement(String name) {
    _measurements.removeWhere((element) => element.name == name);
    _measurementsController.sink.add(_measurements);
  }
}
