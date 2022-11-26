import 'package:ehh/constants/spacing.dart';
import 'package:ehh/routing/routes.dart';
import 'package:flutter/material.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({Key? key}) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _formKey = GlobalKey<FormState>();
  String _otp = "";

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (_) => MaterialPageRoute(
        builder: (ctx) => Scaffold(
          body: SafeArea(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: Spacing.screenPadding,
                    ),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        hintText: "Phone number",
                        enabledBorder: UnderlineInputBorder(),
                        focusedBorder: UnderlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null) return "Enter the OTP";
                        if (_otp != "000000") return "Invalid OTP";
                      },
                      onChanged: (value) => _otp = value,
                      keyboardType: TextInputType.phone,
                      maxLength: 6,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        debugPrint(_otp);
                        Navigator.pushNamed(context, RouteNames.home);
                      }
                    },
                    child: Text("Login"),
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
