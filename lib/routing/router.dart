import 'package:ehh/screens/auth_screen/auth_screen.dart';
import 'package:ehh/screens/home/home_screen.dart';
import 'package:ehh/screens/mapScreen.dart';
import 'package:ehh/screens/mapbox.dart';
import 'package:ehh/screens/settings/settings_dart.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  routes: [
    GoRoute(path: "/", builder: (contex, state) => AuthScreen()),
    GoRoute(
      path: "/a",
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
    GoRoute(path: "/map", builder: (contex, state) => MapScreen()),
    GoRoute(path: "/mapBox", builder: (context, state) => PlaceCircleBody())
  ],
);
