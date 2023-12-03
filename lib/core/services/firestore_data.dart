import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rahener/core/models/user_model.dart';

class FirestoreService {
  final FirebaseFirestore _instance;

  FirestoreService({required instance}) : _instance = instance;

  Future<Map<String, dynamic>> getBuiltInExercises() async {
    try {
      var snapshot = await _instance.collection("exercises").get();

      Map<String, dynamic> data = {
        for (var doc in snapshot.docs) doc.id: doc.data()
      };

      return data;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getBuiltInExercise(String id) async {
    try {
      var snapshot = await _instance.collection("exercises").doc(id).get();

      Map<String, dynamic> data = {
        "id": id,
        ...snapshot.data() as Map<String, dynamic>
      };

      return data;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<String>> getBuiltInExerciseIDs() async {
    try {
      var snapshot =
          await _instance.collection("meta").doc("builtInExerciseIds").get();
      var ids =
          List.from(snapshot.data()!["ids"]).map((e) => e.toString()).toList();

      return ids;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createCustomExercise(
      String userid, Map<dynamic, dynamic> exercise) async {
    try {
      await _instance.collection("users").doc(userid).update({
        "customExercises": FieldValue.arrayUnion([exercise])
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<List<dynamic>> getCustomExercises(String id) async {
    try {
      var snapshot = await _instance.collection("users").doc(id).get();
      if (!snapshot.exists ||
          snapshot.data() == null ||
          snapshot.data()!.isEmpty) {
        throw Exception("No user data, snapshot: ${snapshot.toString()}");
      }
      List<dynamic> data = [
        ...snapshot.data()!["customExercises"] as List<dynamic>
      ];
      return data;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getUser(String id) async {
    try {
      var snapshot = await _instance.collection("users").doc(id).get();
      if (!snapshot.exists ||
          snapshot.data() == null ||
          snapshot.data()!.isEmpty) {
        throw Exception("No user data, snapshot: ${snapshot.toString()}");
      }
      Map<String, dynamic> data = {
        "id": id,
        ...snapshot.data() as Map<String, dynamic>
      };
      return data;
    } catch (e) {
      rethrow;
    }
  }

  // Future<Map<dynamic,dynamic>> getUserSessions(String userID) async {}
  Future<void> createSession() async {}
  Future<void> removeSession() async {}

  Future<void> createMeasurement() async {}
  Future<void> removeMeasurement() async {}

  Future<void> getUserMeasurementEntries(String userID) async {}
  Future<void> createMeasurementEntry() async {}
  Future<void> removeMeasurementEntry() async {}
  Future<void> editMeasurementEntry() async {}

  Future<void> createUser(Map<String, dynamic> userMap) async {
    try {
      await _instance.collection("users").add(userMap);
    } catch (e) {
      rethrow;
    }
  }

  // Future<Map<String, dynamic>> getAllSessionsUser(String id) async {

  // }

  // update user
}
