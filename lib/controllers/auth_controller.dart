import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ehh/models/user_data.dart';
import 'package:ehh/services/firestore/firestore_references.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthController extends ChangeNotifier {
  // Singleton
  AuthController._();

  factory AuthController() {
    instance._initialize();
    return instance;
  }

  static final AuthController instance = AuthController._();

  late StreamSubscription _authState;
  StreamSubscription? _userDoc;

  /// Whether the current user is logged in.
  bool? get isLoggedIn => _isLoggedIn;
  bool? _isLoggedIn;

  /// The currently logged in user data.
  UserData? get currentUser => _currentUser;
  UserData? _currentUser;

  _initialize() {
    // subscribe to auth changes from firebase
    _authState =
        FirebaseAuth.instance.authStateChanges().listen(_onAuthStateChanged);
  }

  /// Signs out the current user.
  signOut() async {
    // sign out
    await FirebaseAuth.instance.signOut();
  }

  /// Called when the auth state of the app changes.
  _onAuthStateChanged(User? user) async {
    // cancel last doc subscription if it exists
    await _userDoc?.cancel();
    _userDoc = null;

    // reset data
    _currentUser = null;
    notifyListeners();

    // check if logged out
    if (user == null) {
      // logged out
      _isLoggedIn = false;
      notifyListeners();
      return;
    } else {
      // logged in
      _isLoggedIn = true;
      // listen to user profile updates
      _userDoc = DocRefs.user(user.uid).snapshots().listen(_onUserDocChanged);
    }
  }

  /// Called when the current user profile document changes.
  _onUserDocChanged(DocumentSnapshot documentSnapshot) {
    if (documentSnapshot.exists) {
      _currentUser = UserData.fromDoc(documentSnapshot);
      notifyListeners();
    } else {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _authState.cancel();
    _userDoc?.cancel();
    _userDoc = null;
    super.dispose();
  }
}
