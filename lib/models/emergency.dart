import 'package:cloud_firestore/cloud_firestore.dart';

class Emergency {
  Emergency({
    required this.id,
    required this.location,
    required this.ongoing,
    required this.description,
  });

  final String id;
  final GeoPoint location;
  final bool ongoing;
  final String description;

  factory Emergency.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Emergency(
      id: doc.id,
      location: data["location"],
      ongoing: data["ongoing"],
      description: data["description"],
    );
  }
}
