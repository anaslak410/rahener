import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth;
  String _verificationId = "";
  AuthService(this._auth);

  Future<void> sendSms(
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
        _verificationId = verificationId;
        // String smsCode = '111111';
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
    return;
  }

  Future<void> verifySms(String code) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: _verificationId, smsCode: code);

      await _auth.signInWithCredential(credential);
      log(_auth.currentUser.toString());
    } catch (e) {
      rethrow;
    }
  }
}
