import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:heartstart/models/emergency.dart';
import 'package:heartstart/services/firestore/firestore_references.dart';

class EmergencyController extends ChangeNotifier {
  StreamSubscription? _emergencyStream;

  bool get isOngoing => _isOngoing;
  bool _isOngoing = false;

  Emergency? get emergency => _emergency;
  Emergency? _emergency;

  EmergencyController();

  void _init(String emergencyId) {}

  void startEmergency(String emergencyId) {
    DocumentReference emergencyDocRef = DocRefs.emergency(emergencyId);
    _emergencyStream =
        emergencyDocRef.snapshots().listen((event) => onEmergencyUpdate);
    _isOngoing = true;

    // If somehow an ended emergency was accepted, end it here
    if (_emergency?.ongoing == true) {
      endEmergency();
    }
  }

  void onEmergencyUpdate(DocumentSnapshot doc) {
    _emergency = Emergency.fromDoc(doc);
  }

  void endEmergency() {
    _emergencyStream?.cancel();
    _emergency = null;
    _isOngoing = false;
  }

  @override
  void dispose() {
    _emergencyStream?.cancel();
    super.dispose();
  }
}