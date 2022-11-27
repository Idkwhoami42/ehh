import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:heartstart/controllers/emergency_controller.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'constants/firebase_options.dart';
import 'controllers/auth_controller.dart';
import 'controllers/notification_controller.dart';
import 'controllers/permission_controller.dart';
import 'models/user_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Required by FlutterConfig
  await FlutterConfig.loadEnvVariables();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PermissionsController()),
        ChangeNotifierProvider(create: (_) => AuthController()),
        ChangeNotifierProvider(
            create: (context) => NotificationController(context)),
        ChangeNotifierProvider(create: (context) => EmergencyController()),
        ChangeNotifierProxyProvider2<AuthController, EmergencyController,
            NotificationController>(
          create: (context) => NotificationController(context),
          lazy: false,
          update: (context, authController, emergencyController,
              notificationController) {
            try {
              notificationController ??= NotificationController(context);
              UserData? currentUser = authController.currentUser;
              if (currentUser != null) {
                notificationController.updateUser(currentUser);
              }
            } catch (e) {
              debugPrint(e.toString());
            }
            return NotificationController(context);
          },
        ),
      ],
      child: const App(),
    ),
  );
}
