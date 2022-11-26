import 'package:ehh/routing/routes.dart';
import 'package:ehh/services/functions/user_service.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class PhoneVerificationScreen extends StatefulWidget {
  const PhoneVerificationScreen({
    Key? key,
    required this.phoneNumber,
    required this.verificationId,
  }) : super(key: key);

  final String phoneNumber;
  final String verificationId;

  @override
  State<PhoneVerificationScreen> createState() =>
      _PhoneVerificationScreenState();
}

class _PhoneVerificationScreenState extends State<PhoneVerificationScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  TextEditingController _pinController = TextEditingController();
  String? verificationError;

  void _verifyAndLogin() {
    Navigator.pushNamed(context, RouteNames.home);

    if (_formKey.currentState!.validate()) {
      _loading = true;
    }

    try {
      UserService()
          .loginWithSmsCode(_pinController.text, widget.verificationId);
      Navigator.pushNamed(context, RouteNames.home);
    } catch (e) {
      setState(() {
        verificationError = "Invalid verification code.";
        _loading = false;
      });
    }
  }

  String? _validate(String? value) {
    if (value != null) {
      if (value.length < 6) {
        return "Please input the whole code.";
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Verify phone number"),
        SizedBox(height: 20),
        Pinput(
          controller: _pinController,
          length: 6,
          validator: _validate,
        ),
        SizedBox(height: 20),
        TextButton(
          child: Text("Verify"),
          onPressed: _verifyAndLogin,
        ),
      ],
    );
  }
}
