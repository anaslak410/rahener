import 'dart:async';

import 'package:rahener/core/models/measurement.dart';
import 'package:rahener/core/models/measurement_entry.dart';
import 'package:rahener/core/services/local_data.dart';
import 'package:rahener/utils/constants.dart';

class MeasurementsRepository {
  final LocalDataService _localJsonDataService;

  final List<Measurement> _measurements = Constants.testMeasurements;
  final Map<String, List<MeasurementEntry>> _measurementEntries =
      Constants.testMeasurementEntries;

  final _measurementsController =
      StreamController<List<Measurement>>.broadcast();
  Stream<List<Measurement>> get measurementsStream =>
      _measurementsController.stream;

  final _measurementEntriesController =
      StreamController<Map<String, List<MeasurementEntry>>>.broadcast();
  Stream<Map<String, List<MeasurementEntry>>> get measurementEntriesStream =>
      _measurementEntriesController.stream;

  Map<String, List<MeasurementEntry>> get measurementEntries =>
      _measurementEntries;
  List<Measurement> get measurements => _measurements;

  MeasurementsRepository._create(
      {required LocalDataService localJsonDataService})
      : _localJsonDataService = localJsonDataService;

  static Future<MeasurementsRepository> create(
      {required LocalDataService localDataService}) async {
    var measurementsRepository =
        MeasurementsRepository._create(localJsonDataService: localDataService);

    return measurementsRepository;
  }

  void addMeasurement(Measurement measurement) {
    _measurements.add(measurement);
    _measurementEntries[measurement.name] = [];
    _measurementsController.sink.add(_measurements);
  }

  void removeMeasurement(String name) {
    _measurements.removeWhere((element) => element.name == name);
    _measurementEntries.removeWhere((key, value) => key == name);
    _measurementsController.sink.add(_measurements);
  }

  void addMeasurementEntry(MeasurementEntry entry, String name) {
    _measurementEntries[name]!.add(entry);
    _measurementEntriesController.sink.add(_measurementEntries);
  }

  void removeMeasurementEntry(int index, String name) {
    _measurementEntries[name]!.removeAt(index);
    _measurementEntriesController.sink.add(_measurementEntries);
  }

  void editMeasurementEntry(int index, String name, MeasurementEntry newEntry) {
    _measurementEntries[name]![index] = newEntry;
    _measurementEntriesController.sink.add(_measurementEntries);
  }
}
