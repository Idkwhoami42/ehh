import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StatusMessageTypes {
  static const pickingUpAed = 'pickingUpAed';
  static const haveAed = 'haveAed';
  static const onRoute = 'onRoute';
}

String? getStatusMessageText(String type) {
  switch (type) {
    case StatusMessageTypes.pickingUpAed:
      return " is picking up the defibrilator";
    case StatusMessageTypes.haveAed:
      return " has the defibrilator";
    case StatusMessageTypes.onRoute:
      return " is on route to the emergency";
  }
}

class StatusMessage {
  StatusMessage({
    required this.type,
    required this.text,
    required this.responderName,
    required this.time,
  });

  final String type;
  final String text;
  final String responderName;
  final DateTime time;

  factory StatusMessage.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    String type = data['type'];
    try {
      final time = data["time"] as Timestamp;
      debugPrint(time.toString());
    } catch (e) {
      e.toString();
    }

    String? statusMessageText = getStatusMessageText(type);

    if (statusMessageText == null) {
      throw Exception("Invalid data in status message");
    }

    return StatusMessage(
      type: type,
      text: statusMessageText,
      // text: data["text"],
      responderName: data["responderName"],
      time: DateTime.now(),
    );
  }
}
