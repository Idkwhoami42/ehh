import 'package:ehh/app.dart';
import 'package:ehh/controllers/permissions_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:provider/provider.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await FlutterConfig.loadEnvVariables();

  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => PermissionsController()),
        ],
        child: const App(),
      ),
    );
}
