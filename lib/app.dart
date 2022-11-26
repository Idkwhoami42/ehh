import 'package:ehh/constants/theme.dart';
import 'package:ehh/routing/router.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
      // builder: (context, child) {
      //   return MultiProvider(
      //     providers: [],
      //     child: child,
      //   );
      // },
      theme: ThemeData(
        fontFamily: defaultFont,
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          isDense: true,
        ),
      ),
    );
  }
}
