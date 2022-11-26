import 'package:ehh/constants/spacing.dart';
import 'package:ehh/constants/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  PhoneNumber _phone = PhoneNumber();

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (_) => MaterialPageRoute(
        builder: (ctx) => Scaffold(
          body: SafeArea(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: Spacing.screenPadding,
                    ),
                    child: InternationalPhoneNumberInput(
                      onInputChanged: (value) => _phone = value,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextButton(
                      onPressed: () {
                        losefocus(context);
                        if (_formKey.currentState!.validate()) {
                          // debugPrint(_phone);
                        }
                      },
                      child: const Text("Send OTP", style: TextStyle(color: white, fontSize: 20)),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
