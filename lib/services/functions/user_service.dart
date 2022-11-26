import 'dart:developer';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:ehh/constants/firebase_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final _functions = FirebaseFunctions.instanceFor(region: functionsRegion);

  Future<void> register(String firstName, String lastName, String phoneNumber,
      bool hasTraining) async {
    try {
      HttpsCallable createUser = _functions.httpsCallable("users-createUser");
      await createUser.call({
        "firstName": firstName,
        "lastName": lastName,
        "phoneNumber": phoneNumber,
        "hasTraining": hasTraining,
      });
    } catch (e) {
      log('Error creating user!', error: e);
    }
  }

  Future<void> login(String phoneNumber) async {
    return;
  }

  Future<void> verifyPhoneNumber(
    String phoneNumber,
    Function(FirebaseAuthException) failedCallback,
    Function(String, int?) startVerificationCallback,
  ) async {
    FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) {
        return;
      },
      verificationFailed: (FirebaseAuthException e) {
        failedCallback(e);
      },
      codeSent: startVerificationCallback,
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  Future<void> loginWithSmsCode(
    String smsCode,
    String? verificationId,
  ) async {
    if (verificationId != null) {
      PhoneAuthCredential creds = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: smsCode);
      FirebaseAuth.instance.signInWithCredential(creds);
    } else {
      return;
    }
  }

  Future<void> updateFcmToken(String userId, String token) async {
    HttpsCallable updateFcmToken =
        _functions.httpsCallable("users-updateDeviceToken");
    await updateFcmToken.call({
      "userId": userId,
      "deviceToken": token,
    });
    return;
  }
}
