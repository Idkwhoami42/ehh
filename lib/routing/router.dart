import 'package:go_router/go_router.dart';

import '../screens/auth_screen.dart';
import '../screens/home_screen.dart';
import '../screens/mapScreen.dart';
import '../screens/settings.dart';

final router = GoRouter(
  routes: [
    GoRoute(path: "/", builder: (contex, state) => MapScreen2()),
    GoRoute(
      path: "/auth",
      builder: (context, state) {
        return AuthScreen();
      },
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) {
        return HomeScreen();
      },
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) {
        return SettingsScreen();
      },
    ),
  ],
);
