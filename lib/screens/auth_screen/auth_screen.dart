import 'package:ehh/constants/spacing.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  String _phone = "";

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
                        final czechFormat = RegExp(r"(2[0-9]{2}|3[0-9]{2}|4[0-9]{2}|5[0-9]{2}|72[0-9]|73[0-9]|77[0-9]|60[1-8]|56[0-9]|70[2-5]|79[0-9])[0-9]{3}[0-9]{3}$");
                        if (value == null) return "Enter a phone number";
                        if (!czechFormat.hasMatch(value)) return "Invalid phone number";
                      },
                      onChanged: (value) => _phone = value,
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        debugPrint(_phone);
                        context.go("/otp");
                      }
                    },
                    child: Text("Send OTP"),
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
