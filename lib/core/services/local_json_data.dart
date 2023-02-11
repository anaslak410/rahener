import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class LocalJsonDataService {
  Map<dynamic, dynamic> _rahenerJsonData = {};

  LocalJsonDataService._create();

  static Future<LocalJsonDataService> create() async {
    try {
      var rahenerJsonData = await jsonDecode(
          await rootBundle.loadString('assets/data/rahener_data.json'));

      var jsonDataServiceInstance = LocalJsonDataService._create();
      jsonDataServiceInstance._rahenerJsonData = rahenerJsonData;

      return jsonDataServiceInstance;
    } on JsonUnsupportedObjectError catch (err) {
      log("could not decode json, cause: ${err.cause}\n stackTrace: ${err.stackTrace}");
      rethrow;
    } on FlutterError catch (err) {
      log('''could not load asset:,
           message: ${err.message}
           diagnostics: ${err.diagnostics}
           stacktrace: ${err.stackTrace}''');
      rethrow;
    }
  }

  Future<Map<dynamic, dynamic>> getExercises() async {
    await Future.delayed(const Duration(seconds: 1));
    return _rahenerJsonData['exercises'];
  }

  Future<List<dynamic>> getMuscleGroups() async {
    await Future.delayed(const Duration(seconds: 1));
    return _rahenerJsonData['muscleGroups'];
  }

  Future<List<dynamic>> getEquipment() async {
    await Future.delayed(const Duration(seconds: 1));
    return _rahenerJsonData['equipment'];
  }
}
