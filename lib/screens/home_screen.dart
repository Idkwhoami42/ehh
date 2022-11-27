import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:heartstart/controllers/auth_controller.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

import '../constants/theme.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late StreamSubscription<LocationData> stream;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Location location = Location();
    location.enableBackgroundMode(enable: true);
    location.changeSettings(interval: 10000);
    stream = location.onLocationChanged.listen((LocationData data) {
      print(data);
      Provider.of<AuthController>(context, listen: false).update(data);
    });

    return Scaffold(
      backgroundColor: bgcolor,
      body: SafeArea(
        child: Center(
          child: TextButton(
            onPressed: () {
              context.go("/map");
            },
            child: const Text("MAP"),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    stream.cancel();
    super.dispose();
  }
}
