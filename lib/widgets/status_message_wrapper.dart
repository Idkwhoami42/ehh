import 'package:flutter/material.dart';
import 'package:heartstart/constants/theme.dart';
import 'package:heartstart/models/status_message.dart';

class _StatusMessagesWrapper extends StatefulWidget {
  const _StatusMessagesWrapper({
    Key? key,
  }) : super(key: key);

  @override
  State<_StatusMessagesWrapper> createState() => _StatusMessagesWrapperState();
}

class _StatusMessagesWrapperState extends State<_StatusMessagesWrapper> {
  List<StatusMessage> messages = [];

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          color: Colors.red,
          child: ListView.builder(
            itemCount: messages.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8),
                child: Container(
                  width: 30,
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.cyan,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    messages[index % messages.length].text,
                    style: TextStyle(color: white, fontSize: 18),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
