import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:rahener/core/models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth;
  // String _verificationId = "";

  AuthService(this._auth);

  Stream<User?> authUpdates() {
    return _auth.idTokenChanges().map((User? user) {
      return user;
    });
  }

  Future<String> sendSms(
    String number,
  ) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: number,
      verificationCompleted: (_) {},
      verificationFailed: (FirebaseAuthException e) {
        log("verification failed");
        log("${e.toString()}");
        throw e;
      },
      codeSent: (String verificationId, int? resendToken) async {
        log("code sent");
        // String smsCode = '111111';
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
    return "";
  }

  Future<void> verifySms(String code, verificationId) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: code);

      await _auth.signInWithCredential(credential);
      log(_auth.currentUser.toString());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    _auth.signOut();
  }
}
