import 'package:ehh/app.dart';
import 'package:ehh/constants/firebase_options.dart';
import 'package:ehh/controllers/auth_controller.dart';
import 'package:ehh/controllers/permissions_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Required by FlutterConfig
  await FlutterConfig.loadEnvVariables();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PermissionsController()),
        ChangeNotifierProvider(create: (_) => AuthController()),
      ],
      child: const App(),
    ),
  );
}
