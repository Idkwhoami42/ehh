import 'package:cloud_firestore/cloud_firestore.dart';
import 'firestore_references.dart';

class FirestoreQueries {
  Future<DocumentSnapshot?> getUserByPhone(String phoneNumber) async {
    QuerySnapshot query =
        await ColRefs.colUsers.where('phone', isEqualTo: phoneNumber).get();
    if (query.docs.isNotEmpty) {
      return query.docs.first;
    } else {
      return null;
    }
  }
}
