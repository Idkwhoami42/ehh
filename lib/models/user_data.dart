import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  UserData({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.hasTraining,
  });

  final String id;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String hasTraining;

  factory UserData.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserData(
      id: doc.id,
      firstName: data['firstName'],
      lastName: data['lastName'],
      phoneNumber: data['phone'],
      hasTraining: data['hasTraining'],
    );
  }
}
