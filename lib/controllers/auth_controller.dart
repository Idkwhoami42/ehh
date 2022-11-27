import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ehh/models/user_data.dart';
import 'package:ehh/services/firestore/firestore_queries.dart';
import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:ehh/constants/firebase_functions.dart';

class AuthController extends ChangeNotifier {
  // Singleton
  AuthController._();

  factory AuthController() {
    instance._initialize();
    return instance;
  }

  final _functions = FirebaseFunctions.instanceFor(region: functionsRegion);
  static final AuthController instance = AuthController._();

  /// Whether the current user is logged in.
  bool? get isLoggedIn => _isLoggedIn;
  bool? _isLoggedIn;

  /// The currently logged in user data.
  UserData? get currentUser => _currentUser;
  UserData? _currentUser;

  _initialize() {
    _currentUser = null;
    _isLoggedIn = false;
  }

  logIn(String phoneNumber) async {
    try {
      DocumentSnapshot? doc =
          await FirestoreQueries().getUserByPhone(phoneNumber);
      if (doc != null) {
        _currentUser = UserData.fromDoc(doc);
        _isLoggedIn = true;
        notifyListeners();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  register(String phoneNumber, String firstName, String lastName,
      bool hasTraining) async {
    // Call the registration endpoint
    HttpsCallable createUser = _functions.httpsCallable('users-createUser');
    var res = await createUser.call({
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'hasTraining': hasTraining,
      'location': {'latitude': 0.0, 'longitude': 0.0},
      'deviceToken': await FirebaseMessaging.instance.getToken()
    });

    // Check if registration was successful
    if (res.data != "") {
      _currentUser = UserData(
          id: res.data as String,
          firstName: firstName,
          lastName: lastName,
          phoneNumber: phoneNumber,
          hasTraining: hasTraining);
      _isLoggedIn = true;
      return true;
    }

    return false;
  }

  /// Signs out the current user.
  signOut() async {
    _currentUser = null;
    _isLoggedIn = false;
    notifyListeners();
  }
}
