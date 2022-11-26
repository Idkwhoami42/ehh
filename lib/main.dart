import 'package:ehh/app.dart';
import 'package:ehh/controllers/auth_controller.dart';
import 'package:ehh/controllers/permissions_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PermissionsController()),
        ChangeNotifierProvider(create: (_) => AuthController()),
      ],
      child: App(),
    ),
  );
}
