import 'package:go_router/go_router.dart';

import '../screens/login_screen.dart';
import '../screens/home_screen.dart';
import '../screens/mapScreen.dart';
import '../screens/register_screen.dart';
import '../screens/settings.dart';
import '../screens/welcome.dart';

final router = GoRouter(
  routes: [
    GoRoute(path: "/", builder: (contex, state) => WelcomeScreen()),
    GoRoute(
      path: "/login",
      builder: (context, state) {
        return LoginScreen();
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
    GoRoute(
      path: "/register",
      builder: (context, state) {
        return RegisterScreen();
      },
    ),
    GoRoute(
      path: "/map",
      builder: (context, state) {
        return MapScreen();
      },
    ),
  ],
);
