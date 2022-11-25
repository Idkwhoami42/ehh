import 'package:ehh/constants/theme.dart';
import 'package:ehh/controllers/permissions_controller.dart';
import 'package:ehh/routing/router.dart';
import 'package:ehh/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: defaultFont,
      ),
      builder: (context, child) {
        return MultiProvider(providers: [
          ChangeNotifierProvider(
            create: (context) => PermissionsController(),
          ),
        ], child: const HomeScreen());
      },
    );
  }
}
