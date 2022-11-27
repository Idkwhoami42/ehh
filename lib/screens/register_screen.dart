// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

import '../constants/spacing.dart';
import '../constants/theme.dart';
import '../controllers/auth_controller.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  PhoneNumber _phoneNumber = PhoneNumber(isoCode: 'CZ');
  bool _hasTraining = false;
  String _firstName = "";
  String _lastName = "";

  bool otpRequested = false, isCertified = false;

  void updatePhone(PhoneNumber newNumber) {
    _phoneNumber = newNumber;
  }

  void updateFirstName(String firstName) {
    _firstName = firstName;
  }

  void updateLastName(String lastName) {
    _lastName = lastName;
  }

  void updateHasTraining(bool? hasTraining) {
    _hasTraining = hasTraining!;
  }

  Future<void> _register(BuildContext context) async {
    // Validate
    if (_phoneNumber.phoneNumber == null || _firstName.length < 2 || _lastName.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Fill in the fields correctly')));
    } else {
      debugPrint("cool");
      var registered = await Provider.of<AuthController>(context, listen: false).register(_phoneNumber.phoneNumber!, _firstName, _lastName, _hasTraining, await Location().getLocation());

      // If registration was successful, go to X
      if (registered) {
        context.go('/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('This Username is not found! Please try again later')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    AuthController authController = context.watch<AuthController>();

    return Scaffold(
      backgroundColor: bgcolor,
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
              SizedBox(height: 60),
              Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: Spacing.screenPadding,
                  ),
                  child: Column(children: [
                    InternationalPhoneNumberInput(
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
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: TextField(
                        decoration: InputDecoration(
                            hintText: 'First name',
                            errorBorder: InputBorder.none,
                            border: InputBorder.none,
                            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.red, width: 1.0)),
                            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.red, width: 2.0))),
                        textCapitalization: TextCapitalization.words,
                        onChanged: (value) => updateFirstName(value),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Last name',
                          errorBorder: InputBorder.none,
                          border: InputBorder.none,
                          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.red, width: 1.0)),
                          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.red, width: 2.0)),
                        ),
                        textCapitalization: TextCapitalization.words,
                        onChanged: (value) => updateLastName(value),
                      ),
                    ),
                    CheckboxListTile(
                        title: Text("Do you have a CPR certificate?"),
                        value: _hasTraining,
                        onChanged: (bool? value) {
                          setState(() {
                            _hasTraining = value!;
                          });
                        })
                  ])),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextButton(
                  onPressed: () async => await _register(context),
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
        ),
      ),
    );
  }
}
