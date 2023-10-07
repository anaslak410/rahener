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

  Future<String> sendSms(String phoneNum) async {
    String verificationNum = "";
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNum,
      verificationCompleted: (_) {},
      codeAutoRetrievalTimeout: (_) {},
      verificationFailed: (FirebaseAuthException e) {
        throw e;
      },
      codeSent: (String verificationId, int? resendToken) async {
        log("code sent");
        verificationNum = verificationId;
      },
    );
    return verificationNum;
  }

  /*
  wrong veri,
  wrong number,
  timeout,
  phone already exists, 
  
  
   */
  Future<void> verifyCode(String code, verificationId) async {
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

  // void logIn() {}
  // void onVerifyCodeTapped() {}
  void createUserAccount() {}
}
