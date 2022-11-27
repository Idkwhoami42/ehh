import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:heartstart/controllers/emergency_controller.dart';
import 'package:heartstart/models/emergency.dart';
import 'package:provider/provider.dart';

class EmergencyScreen extends StatefulWidget {
  const EmergencyScreen({
    Key? key,
    required this.emergencyId,
  }) : super(key: key);

  final String emergencyId;

  @override
  State<EmergencyScreen> createState() => EmergencyScreenState();
}

class EmergencyScreenState extends State<EmergencyScreen> {
  String? emergencyId;
  Emergency? emergency;

  @override
  void initState() {
    emergencyId = widget.emergencyId;
    EmergencyController emergencyController =
        Provider.of<EmergencyController>(context, listen: false);
    emergencyController.startEmergency(emergencyId!);
    emergency = emergencyController.emergency;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (emergency == null) {
      return CircularProgressIndicator();
    }

    return Navigator(
      onGenerateRoute: (_) => MaterialPageRoute(
        builder: (ctx) => Scaffold(
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Center(
                  child: Text(
                    emergency!.description,
                    style: TextStyle(fontSize: 35, color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {
                        context.go("/map");
                      },
                      child: const Text("Accept",
                          style: TextStyle(fontSize: 30, color: Colors.green)),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text("Decline",
                          style: TextStyle(fontSize: 30, color: Colors.black)),
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
