import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:heartstart/models/notification.dart';

import '../models/user_data.dart';
import '../services/functions/user_service.dart';

class NotificationController extends ChangeNotifier {
  BuildContext? _context;
  UserData? _currentUser;
  String? _currentFcmToken;
  NotificationController(BuildContext context) {
    _context = context;
    _init();
  }
  Future<void> _init() async {
    FirebaseMessaging.onMessage
        .listen((RemoteMessage message) => _messageReceived(message, _context));
  }

  void updateUser(UserData newUser) async {
    if (_currentUser != newUser) {
      _currentUser = newUser;
    }
    String? token = await FirebaseMessaging.instance.getToken();
    if (token != _currentFcmToken && token != null) {
      _currentFcmToken = token;
      UserService().updateFcmToken(newUser.id, token);
    }
  }
}

@pragma('vm:entry-point')
void _messageReceived(RemoteMessage message, BuildContext? context) {
  Map<String, dynamic> payload = message.data;
  String? messageType = payload["msgType"];

  if (messageType == null) {
    return;
  }

  switch (messageType) {
    case NotificationType.newEmergency:
      handleNewEmergencyNotification(payload, context);
  }
}

void handleNewEmergencyNotification(
    Map<String, dynamic> payload, BuildContext? context) {
  if (context == null) {
    return;
  }
  String emergencyId = payload["emergencyId"];

  // If there's already an ongoing emergency, don't interrupt this responder

  showBottomSheet(
    context: context,
    builder: (context) {
      return BottomSheet(
        onClosing: () {},
        builder: (context) {
          return Column(
            children: [
              Text(
                "New emergency",
                style: TextStyle(fontSize: 35, color: Colors.red),
                textAlign: TextAlign.center,
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      context.goNamed("map", queryParams: {
                        "emergencyId": emergencyId,
                      });
                    },
                    child: const Text(
                      "Accept",
                      style: TextStyle(fontSize: 30, color: Colors.green),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      "Decline",
                      style: TextStyle(fontSize: 30, color: Colors.black),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      );
    },
  );
}
