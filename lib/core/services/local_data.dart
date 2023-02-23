import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class LocalDataService {
  Map<dynamic, dynamic> _rahenerJsonData = {};

  LocalDataService._create();

  static Future<LocalDataService> create(String locale) async {
    try {
      String filePath;
      if (locale == 'fa') {
        filePath = 'assets/data/data_kr.json';
      } else if (locale == "en") {
        filePath = 'assets/data/data_en.json';
      } else {
        throw Exception("Locale has no data file");
      }

      var rahenerJsonData =
          await jsonDecode(await rootBundle.loadString(filePath));

      var jsonDataServiceInstance = LocalDataService._create();
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

  AssetImage getExerciseImage(String exerciseId) {
    return AssetImage("assets/data/images/$exerciseId.gif");
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
