import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EmergencyScreen extends StatefulWidget {
  EmergencyScreen({Key? key}) : super(key: key);

  @override
  State<EmergencyScreen> createState() => EmergencyScreenState();
}

class EmergencyScreenState extends State<EmergencyScreen> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (_) => MaterialPageRoute(
        builder: (ctx) => Scaffold(
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Center(
                  child: Text(
                    "Emergency @ IKEM\nPraha 4",
                    style: TextStyle(fontSize: 35, color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {
                        context.go("/map2");
                      },
                      child: const Text("Accept", style: TextStyle(fontSize: 30, color: Colors.green)),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text("Decline", style: TextStyle(fontSize: 30, color: Colors.black)),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
