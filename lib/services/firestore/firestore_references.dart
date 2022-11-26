import 'package:cloud_firestore/cloud_firestore.dart';

class ColRefs {
  // Collections
  static final colUsers = FirebaseFirestore.instance.collection("users");
}

class DocRefs {
  // Documents
  static DocumentReference<Map<String, dynamic>> user(String userId) {
    return ColRefs.colUsers.doc(userId);
  }
}
