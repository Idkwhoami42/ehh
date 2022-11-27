import 'package:ehh/models/status_message.dart';
import 'package:flutter/material.dart';

class ResponderMessageBubble extends StatelessWidget {
  const ResponderMessageBubble({
    Key? key,
    required this.statusMessage,
  }) : super(key: key);

  final StatusMessage statusMessage;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [Text(statusMessage.authorName)]),
    );
  }
}
