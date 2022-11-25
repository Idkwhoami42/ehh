import 'package:ehh/constants/theme.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: white,
      body: SafeArea(
        child: Center(
          child: Text("lmao"),
        ),
      ),
    );
  }
}
