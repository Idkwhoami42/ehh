// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:provider/provider.dart';

import '../constants/spacing.dart';
import '../constants/theme.dart';
import '../controllers/auth_controller.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (_) => MaterialPageRoute(
        builder: (ctx) {
          return Scaffold(
            backgroundColor: bgcolor,
            body: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextButton(
                          onPressed: () => context.go("/login"),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 7.0),
                            child: Text("Log in", style: TextStyle(color: white, fontSize: 17, fontWeight: FontWeight.w700)),
                          ),
                        ),
                      ),

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
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
