import 'package:ehh/app.dart';
import 'package:ehh/controllers/permissions_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
 runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PermissionsController()),
      ],
      child: const App(),
    ),
  );
}
