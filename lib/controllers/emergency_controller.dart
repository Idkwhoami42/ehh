import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:heartstart/models/emergency.dart';
import 'package:heartstart/services/firestore/firestore_references.dart';

class EmergencyController extends ChangeNotifier {
  Stream<DocumentSnapshot<Map<String, dynamic>>>? get emergencyStream =>
      _emergencyStream;
  Stream<DocumentSnapshot<Map<String, dynamic>>>? _emergencyStream;

  StreamSubscription? _streamSubscription;

  bool get isOngoing => _emergencyFuture == null;

  Future<Emergency>? get emergencyFuture => _emergencyFuture;
  Future<Emergency>? _emergencyFuture;

  EmergencyController() {
    _emergencyFuture = null;
    _emergencyStream = null;
  }

  Future<Emergency> _getEmergencyFuture(DocumentReference ref) async {
    DocumentSnapshot doc = await ref.get();
    return Emergency.fromDoc(doc);
  }

  Future<void> startEmergency(String emergencyId) async {
    DocumentReference<Map<String, dynamic>> emergencyDocRef =
        DocRefs.emergency(emergencyId);
    _emergencyFuture = _getEmergencyFuture(emergencyDocRef);
    // _emergency = Emergency.fromDoc(await emergencyDocRef.get());
    _emergencyStream = emergencyDocRef.snapshots();
    _streamSubscription =
        _emergencyStream!.listen((doc) => onEmergencyUpdate(doc));
  }

  void onEmergencyUpdate(DocumentSnapshot doc) {
    _emergencyFuture = Future.value(Emergency.fromDoc(doc));
  }

  void endEmergency() {
    _streamSubscription?.cancel();
    _emergencyFuture = null;
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }
}
