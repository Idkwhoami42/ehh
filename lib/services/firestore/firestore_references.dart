import 'package:cloud_firestore/cloud_firestore.dart';

class ColRefs {
  // Collections
  static final colUsers = FirebaseFirestore.instance.collection("users");
  static final colEmergencies =
      FirebaseFirestore.instance.collection("emergencies");
}

class DocRefs {
  static DocumentReference<Map<String, dynamic>> user(String userId) {
    return ColRefs.colUsers.doc(userId);
  }

  static DocumentReference<Map<String, dynamic>> emergency(String emergencyId) {
    return ColRefs.colEmergencies.doc(emergencyId);
  }
}
