import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StatusMessageTypes {
  static const pickingUpAed = 'pickingUpAed';
  static const haveAed = 'haveAed';
  static const onRoute = 'onRoute';
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
    try {
      final time = data["time"] as Timestamp;
      debugPrint(time.toString());
    } catch (e) {
      e.toString();
    }

    return StatusMessage(
      type: data['type'],
      text: data["text"],
      responderName: data["responderName"],
      time: DateTime.now(),
    );
  }
}