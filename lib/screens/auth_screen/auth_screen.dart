import 'package:ehh/constants/spacing.dart';
import 'package:ehh/constants/theme.dart';
import 'package:ehh/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  PhoneNumber _phoneNumber = PhoneNumber(isoCode: 'CZ');
  bool otpRequested = false, isCertified = false;

  void updatePhone(PhoneNumber newNumber) {
    _phoneNumber = newNumber;
  }

  Future<void> _login() async {
    if (_phoneNumber.phoneNumber == null) {
      return;
    }
    // losefocus(context);
    // context.go('/map');
    await Provider.of<AuthController>(context, listen: false)
        .logIn(_phoneNumber.phoneNumber!);
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (_) => MaterialPageRoute(
        builder: (ctx) {
          AuthController authController = context.watch<AuthController>();

          return Scaffold(
            body: SafeArea(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: Spacing.screenPadding,
                      ),
                      child: InternationalPhoneNumberInput(
                        initialValue: _phoneNumber,
                        onInputChanged: updatePhone,
                        cursorColor: black,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextButton(
                        onPressed: () async => {await _login()},
                        child: Text(
                          "Log in",
                          style: const TextStyle(color: white, fontSize: 20),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: authController.isLoggedIn == true,
                      child: Container(
                        decoration: BoxDecoration(
                          color: primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextButton(
                          onPressed: () => {
                            context.go('/map'),
                          },
                          child: Text(
                            "Open map",
                            style: const TextStyle(color: white, fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
