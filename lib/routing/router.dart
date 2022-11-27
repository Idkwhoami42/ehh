import 'package:go_router/go_router.dart';
import 'package:heartstart/screens/emergency.dart';

import '../screens/home_screen.dart';
import '../screens/login_screen.dart';
import '../screens/mapScreen.dart';
import '../screens/register_screen.dart';
import '../screens/settings.dart';

final router = GoRouter(
  routes: [
    GoRoute(path: "/", builder: (contex, state) => LoginScreen()),
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
      name: "map",
      path: "/map",
      builder: (context, state) {
        return MapScreen2(
          emergencyId: state.queryParams["emergencyId"],
        );
      },
    ),
    GoRoute(
      name: "emergency",
      path: "/emergency",
      builder: (context, state) {
        return EmergencyScreen(
          emergencyId: state.queryParams["emergencyId"]!,
        );
      },
    ),
  ],
);
