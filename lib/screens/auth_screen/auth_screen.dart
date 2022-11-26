import 'package:ehh/constants/spacing.dart';
import 'package:ehh/constants/theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
  PhoneNumber _phone = PhoneNumber(isoCode: 'CZ');
  String _otp = "";
  bool otpRequested = false, isCertified = false;
  String correctOTP = "000000"; // to change

  void updatePhone(PhoneNumber newNumber) {
    _phone = newNumber;
  }

  void updateOPT(String otp) {
    _otp = otp;
  }

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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: Spacing.screenPadding,
                    ),
                    child: InternationalPhoneNumberInput(
                      initialValue: _phone,
                      onInputChanged: updatePhone,
                      cursorColor: black,
                    ),
                  ),
                  Visibility(
                    visible: otpRequested,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 130,
                        vertical: Spacing.screenPadding,
                      ),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          hintText: "OTP",
                        ),
                        validator: (value) {
                          debugPrint(value);
                          if (value != correctOTP) return "Invalid OTP";
                        },
                        maxLength: 6,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: otpRequested,
                    child: Row(
                      children: [
                        const Spacer(),
                        Checkbox(
                          value: isCertified,
                          onChanged: (value) => setState(() {
                            isCertified = value!;
                          }),
                        ),
                        const Text(
                          "Are you certified to perform a CPR?",
                          style: TextStyle(color: black, fontSize: 16),
                        ),
                        const Spacer(),
                      ],
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
                          if (otpRequested) {
                            context.go("/emergency");
                          }
                          // debugPrint(_phone);
                          setState(() {
                            otpRequested = true;
                          });
                        }
                      },
                      child: Text(
                        otpRequested ? "Sign UP" : "Send OTP",
                        style: const TextStyle(color: white, fontSize: 20),
                      ),
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
