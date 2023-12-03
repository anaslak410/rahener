import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:rahener/utils/constants.dart';

class FireBaseAuthService {
  final FirebaseAuth _auth;

  FireBaseAuthService(this._auth);

  Stream<User?> authUpdates() {
    return _auth.idTokenChanges().map((User? user) {
      return user;
    });
  }

  Future<void> sendSms(String phoneNum, Function onCodeSent) async {
    phoneNum = "+9647517406194";
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNum,
        verificationCompleted: (_) {},
        codeAutoRetrievalTimeout: (_) {},
        verificationFailed: (FirebaseAuthException e) {
          throw e;
        },
        codeSent: (String verificationId, int? resendToken) {
          log("code sent");
          // onCodeSent = verificationId;
          onCodeSent(verificationId);
        },
      );
      // if (verificationNum.isEmpty) {
      //   throw Exception("verification num is empty");
      // }
      // return verificationNum;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> verifyCode(String code, verificationId) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: code);
      await _auth.signInWithCredential(credential);
      // log(_auth.currentUser.toString());
    } on Exception {
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      log(e.toString());
    }
  }
}
