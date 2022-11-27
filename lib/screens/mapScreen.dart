import 'dart:collection';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:go_router/go_router.dart';
import 'package:google_map_polyline_new/google_map_polyline_new.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:heartstart/controllers/emergency_controller.dart';
import 'package:heartstart/widgets/status_message_wrapper.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../constants/theme.dart';
import '../controllers/aed_locations.dart';
import '../controllers/permission_controller.dart';
import '../services/firestore/firestore_references.dart';

class MapScreen2 extends StatefulWidget {
  const MapScreen2({
    Key? key,
    this.emergencyId,
  }) : super(key: key);

  final String? emergencyId;

  @override
  State<MapScreen2> createState() => _MapScreenState2();
}

class _MapScreenState2 extends State<MapScreen2> {
  List<String> messages = [];

  GoogleMapController? mapController;
  LatLng? location;
  Circle? selectedCpr;
  late BuildContext context2;
  Map<LatLng, CPR> coordsToCpr = {};
  Set<Marker> _markers = HashSet<Marker>();
  Set<Polyline> _polylines = HashSet<Polyline>();
  List<LatLng> routeCoords = [];
  String? emergencyId;

  GoogleMapPolyline googleMapPolyline =
      GoogleMapPolyline(apiKey: FlutterConfig.get("MAPS_APIKEY"));

  @override
  void initState() {
    EmergencyController emergencyController = EmergencyController();

    emergencyId = widget.emergencyId; // may be null
    if (emergencyId != null) {
      EmergencyController emergencyController = EmergencyController();
      emergencyController.startEmergency(emergencyId!);
    }
    super.initState();
  }

  void getLocation(BuildContext context) async {
    Provider.of<PermissionsController>(context, listen: false)
        .requestPermission([Permission.location]);
    var loc = await Location().getLocation();
    location = LatLng(loc.latitude!, loc.longitude!);
    setState(() => print(location));
  }

  void updateLocation() {
    for (CPR cpr in CPR_locations()) {
      double distance =
          (location!.latitude - cpr.lat) * (location!.latitude - cpr.lat);
      distance +=
          (location!.longitude - cpr.long) * (location!.longitude - cpr.long);
      distance = sqrt(distance);

      if (distance > 0.03) continue;

      _markers.add(Marker(
          markerId: MarkerId("marker_id_${_markers.length}"),
          position: LatLng(cpr.lat, cpr.long)));
      coordsToCpr[LatLng(cpr.lat, cpr.long)] = cpr;
    }
    setState(() {});
  }

  void drawRoute() async {
    if (emergencyId == null) {
      return;
    }
    var doc = await DocRefs.emergency(emergencyId!).get();
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    GeoPoint? loc = data["location"];
    if (loc == null) return;
    LatLng end = LatLng(loc.latitude, loc.longitude); // placeholder
    routeCoords = (await googleMapPolyline.getCoordinatesWithLocation(
        origin: location!, destination: end, mode: RouteMode.walking))!;
    _polylines.add(
      Polyline(
        polylineId: const PolylineId('route'),
        visible: true,
        points: routeCoords,
        width: 4,
        color: Colors.blue,
        startCap: Cap.roundCap,
        endCap: Cap.buttCap,
      ),
    );
    setState(() {});
  }

  // void on

  @override
  Widget build(BuildContext context) {
    if (location == null) getLocation(context);
    if (location != null && _markers.isEmpty) drawRoute();
    if (location != null && routeCoords.isEmpty) drawRoute();

    EmergencyController emergencyController =
        context.watch<EmergencyController>();

    if (emergencyController.emergency != null) {
      drawRoute();
    }

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
                              ? GoogleMap(
                                  markers: _markers,
                                  myLocationEnabled: true,
                                  polylines: _polylines,
                                  initialCameraPosition: CameraPosition(
                                      target: location!, zoom: 13.5),
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
                    StatusMessagesWrapper(),
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
