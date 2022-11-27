import 'package:flutter/material.dart';
import 'package:heartstart/models/status_message.dart';

class StatusMessageBubble extends StatelessWidget {
  const StatusMessageBubble({
    Key? key,
    required this.statusMessage,
  }) : super(key: key);

  final StatusMessage statusMessage;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [Text(statusMessage.responderName)]),
    );
  }
}