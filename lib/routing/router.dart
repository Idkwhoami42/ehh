import 'package:ehh/routing/routes.dart';
import 'package:ehh/screens/auth_screen/auth_screen.dart';
import 'package:ehh/screens/auth_screen/phone_verification_screen.dart';
import 'package:ehh/screens/home/home_screen.dart';
import 'package:ehh/screens/settings/settings_dart.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      name: RouteNames.auth,
      path: '/',
      builder: (context, state) {
        return AuthScreen();
      },
      routes: [
        GoRoute(
          name: RouteNames.phoneVerification,
          path: 'phoneVerification',
          builder: (context, state) {
            return PhoneVerificationScreen(
              phoneNumber: state.queryParams["phoneNumber"]!,
              verificationId: state.queryParams["verificationId"]!,
            );
          },
        ),
      ],
    ),
    GoRoute(
      path: '/home',
      name: RouteNames.home,
      builder: (context, state) {
        return HomeScreen();
      },
    ),
    GoRoute(
      name: RouteNames.settings,
      path: '/settings',
      builder: (context, state) {
        return SettingsScreen();
      },
    ),
  ],
);
