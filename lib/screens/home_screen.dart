import 'package:flutter/material.dart';

import '../constants/theme.dart';

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