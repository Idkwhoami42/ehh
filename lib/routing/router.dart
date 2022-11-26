import 'package:ehh/screens/auth_screen/auth_screen.dart';
import 'package:ehh/screens/auth_screen/otp_screen.dart';
import 'package:ehh/screens/home/home_screen.dart';
import 'package:ehh/screens/settings/settings_dart.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: "/",
      builder: (context, state) {
        return AuthScreen();
      },
    ),
    GoRoute(
      path: '/otp',
      builder: (context, state) {
        return OtpScreen();
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
