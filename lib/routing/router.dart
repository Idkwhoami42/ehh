import 'package:ehh/routing/routes.dart';
import 'package:ehh/screens/auth_screen/auth_screen.dart';
import 'package:ehh/screens/home/home_screen.dart';
import 'package:ehh/screens/settings/settings_dart.dart';
import 'package:flutter/material.dart';

// final router = GoRouter(
//   routes: [
//     GoRoute(
//       name: RouteNames.auth,
//       path: '/',
//       builder: (context, state) {
//         return AuthScreen();
//       },
//       routes: [
//         GoRoute(
//           name: RouteNames.phoneVerification,
//           path: 'phoneVerification',
//           builder: (context, state) {
//             return PhoneVerificationScreen(
//               phoneNumber: state.queryParams["phoneNumber"]!,
//               verificationId: state.queryParams["verificationId"]!,
//             );
//           },
//         ),
//       ],
//     ),
//     GoRoute(
//       path: '/home',
//       name: RouteNames.home,
//       builder: (context, state) {
//         return HomeScreen();
//       },
//     ),
//     GoRoute(
//       name: RouteNames.settings,
//       path: '/settings',
//       builder: (context, state) {
//         return SettingsScreen();
//       },
//     ),
//   ],
// );

final routes = {
  '/': (context) => AuthScreen(),
  '/auth': (context) => AuthScreen(),
  '/home': (context) => HomeScreen(),
  '/settings': (context) => SettingsScreen(),
};

Route<dynamic>? onGenerateRoute(RouteSettings settings) {
  for (Routes route in Routes.values) {
    return MaterialPageRoute(
      builder: (context) => buildRoute(context, route),
    );
  }

  return null;
}

Widget buildRoute(BuildContext context, Routes route) {
  switch (route) {
    case Routes.homeScreen:
      return HomeScreen();
    case Routes.authScreen:
      return AuthScreen();
    case Routes.settingsScreen:
      return SettingsScreen();
  }
}
