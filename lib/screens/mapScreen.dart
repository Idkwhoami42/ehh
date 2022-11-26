import 'dart:async';

import 'package:ehh/constants/theme.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  List<String> messages = ["Help me", "No fuck you"];

  final Completer<GoogleMapController> _controller = Completer();

  static const CameraPosition mapview = CameraPosition(
    bearing: 0,
    target: LatLng(51.998889665838334, 4.3772578802178455),
    zoom: 15,
  );

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (_) => MaterialPageRoute(
        builder: (ctx) => Scaffold(
          appBar: AppBar(
            backgroundColor: primary,
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                onPressed: () {
                  context.go('/settings');
                },
                icon: const Icon(Icons.settings, color: white),
              )
            ],
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: GoogleMap(
                        mapType: MapType.normal,
                        initialCameraPosition: mapview,
                        onMapCreated: (GoogleMapController controller) {
                          _controller.complete(controller);
                        },
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(color: Colors.blue),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      color: Colors.red,
                      child: ListView.builder(
                        // itemCount: messages.length,
                        itemBuilder: ((context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8),
                            child: Container(
                              width: 30,
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.cyan,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                messages[index % 2],
                                style: TextStyle(color: white, fontSize: 18),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
