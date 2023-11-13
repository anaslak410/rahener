import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rahener/core/models/user_model.dart';

class FirestoreService {
  final FirebaseFirestore _instance;

  FirestoreService({required instance}) : _instance = instance;

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
