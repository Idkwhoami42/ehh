import 'dart:math';

import 'package:ehh/constants/theme.dart';
import 'package:ehh/controllers/cpr_locations.dart';
import 'package:ehh/controllers/permissions_controller.dart';
import 'package:ehh/screens/auth_screen/auth_screen.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatefulWidget {
  MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  List<String> messages = ["Help me", "No"];

  MapboxMapController? mapController;
  LocationData? location;
  Circle? selectedCpr;
  late BuildContext context2;
  Map<LatLng, CPR> coordsToCpr = {};

  void getLocation(BuildContext context) async {
    Provider.of<PermissionsController>(context, listen: false).requestPermission([Permission.location]);
    location = await Location().getLocation();
    setState(() {});
  }

  void updateLocation() {
    if (mapController == null) return;
    mapController!.addCircle(
      CircleOptions(geometry: LatLng(location!.latitude!, location!.longitude!), circleColor: "#0000FF"),
    );
    for (CPR cpr in CPR_locations()) {
      double distance = (location!.latitude! - cpr.lat) * (location!.latitude! - cpr.lat);
      distance += (location!.longitude! - cpr.long) * (location!.longitude! - cpr.long);
      distance = sqrt(distance);

      if (distance > 0.03) continue;

      mapController!.addCircle(
        CircleOptions(geometry: LatLng(cpr.lat, cpr.long), circleColor: "#FF0000"),
      );
      coordsToCpr[LatLng(cpr.lat, cpr.long)] = cpr;
    }
    setState(() {});
  }

  void onClick(Circle circle) {
    selectedCpr = circle;
    showDialog(
      context: context2,
      builder: (BuildContext context) => AlertDialog(
        title: Text(
          coordsToCpr[selectedCpr?.options.geometry]!.name,
        ),
        content: Text(coordsToCpr[selectedCpr?.options.geometry]!.address),
        actions: [
          TextButton(
            onPressed: () {
              mapController?.removeCircle(circle);
              messages.add("Picking up CPR at from ${coordsToCpr[selectedCpr?.options.geometry]!.name}");
              Navigator.of(context).pop();
            },
            child: Text("Pick up"),
          )
        ],
      ),
    ).then((value) => setState(() {
          print("pick up");
        }));
  }

  void _onMapCreated(MapboxMapController controller) {
    mapController = controller;
    controller.onCircleTapped.add(onClick);
    Future.delayed(const Duration(milliseconds: 300)).then((_) => updateLocation());
  }

  final String mapboxapi = FlutterConfig.get("MAPBOXAPI");


  @override
  void dispose() {
    mapController?.onCircleTapped.remove(onClick);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (location == null) getLocation(context);
    context2 = context;
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
          body: Stack(
            children: [
              SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          child: location != null
                              ? MapboxMap(
                                  // styleString: MapboxStyles.DARK,
                                  accessToken: FlutterConfig.get("MAPBOXAPI"),
                                  onMapCreated: _onMapCreated,
                                  initialCameraPosition: CameraPosition(target: LatLng(location!.latitude!, location!.longitude!), zoom: 13.5),
                                )
                              : null,
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
            ],
          ),
        ),
      ),
    );
  }
}
