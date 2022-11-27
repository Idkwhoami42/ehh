import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/user_data.dart';

import '../services/firestore/firestore_queries.dart';

class AuthController extends ChangeNotifier {
  // Singleton
  AuthController._();

  factory AuthController() {
    instance._initialize();
    return instance;
  }

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
      DocumentSnapshot? doc = await FirestoreQueries().getUserByPhone(phoneNumber);
      if (doc != null) {
        _currentUser = UserData.fromDoc(doc);
        _isLoggedIn = true;
        notifyListeners();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  /// Signs out the current user.
  signOut() async {
    _currentUser = null;
    _isLoggedIn = false;
    notifyListeners();
  }
}
