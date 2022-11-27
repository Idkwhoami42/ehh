import 'package:cloud_firestore/cloud_firestore.dart';

class StatusMessageTypes {
  static const pickingUpAed = 'PICKUP';
  static const haveAed = 'PICKED';
  static const onRoute = 'ONROUTE';
}

class StatusMessage {
  StatusMessage({
    required this.type,
    required this.text,
    required this.authorName,
  });

  final String type;
  final String text;
  final String authorName;

  factory StatusMessage.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return StatusMessage(
      type: data['type'],
      text: data["text"],
      authorName: data["userId"],
    );
  }
}
