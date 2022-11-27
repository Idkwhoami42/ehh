// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:provider/provider.dart';

import '../constants/spacing.dart';
import '../constants/theme.dart';
import '../controllers/auth_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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

    await Provider.of<AuthController>(context, listen: false).logIn(_phoneNumber.phoneNumber!);
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 100),

                    // LOGO
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Icon(Icons.favorite_border_rounded, color: Colors.red, size: 70.0),
                      SizedBox(width: 15),
                      Column(children: [
                        Text(
                          "HEARTSTART",
                          style: const TextStyle(color: Color.fromRGBO(255, 0, 0, 1.0), fontSize: 30, fontWeight: FontWeight.w700),
                        ),
                        Text("Save hearts with love", style: TextStyle(color: Color.fromRGBO(240, 0, 0, 1.0), fontSize: 20, fontWeight: FontWeight.w500))
                      ]),
                    ]),
                    SizedBox(height: 200),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 70,
                        vertical: Spacing.screenPadding,
                      ),
                      child: InternationalPhoneNumberInput(
                          initialValue: _phoneNumber,
                          maxLength: 13,
                          inputBorder: InputBorder.none,
                          spaceBetweenSelectorAndTextField: 0,
                          inputDecoration: InputDecoration(
                              errorBorder: InputBorder.none,
                              border: InputBorder.none,
                              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.red, width: 1.0)),
                              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.red, width: 2.0)),
                              hintText: 'Your phone number',
                              hintStyle: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w200)),
                          selectorConfig: SelectorConfig(selectorType: PhoneInputSelectorType.BOTTOM_SHEET),
                          onInputChanged: updatePhone),
                    ),
                    SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: primary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextButton(
                            onPressed: () async => {await _login()},
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 7.0),
                              child: Text("Log in", style: TextStyle(color: white, fontSize: 17, fontWeight: FontWeight.w700)),
                            ),
                          ),
                        ),

                        const SizedBox(width: 20),

                        // REGISTER
                        Container(
                          decoration: BoxDecoration(
                            color: primary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextButton(
                            onPressed: () async => context.go('/register'),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 7.0),
                              child: Text(
                                "Sign up",
                                style: TextStyle(color: white, fontSize: 17, fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                        ),
                      ],
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
                            style: const TextStyle(color: white, fontSize: 18),
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
