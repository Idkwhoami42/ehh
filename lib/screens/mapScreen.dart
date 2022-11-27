import 'dart:collection';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:google_map_polyline_new/google_map_polyline_new.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../constants/theme.dart';
import '../controllers/aed_locations.dart';
import '../controllers/permission_controller.dart';
import '../services/firestore/firestore_references.dart';

class MapScreen extends StatefulWidget {
  MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  List<String> messages = [
    "[14:12] Jane is picking up the defibrilator",
    "[14:13] Omar is on route to emergency"
  ];

  GoogleMapController? mapController;
  LatLng? location;
  Circle? selectedCpr;
  late BuildContext context2;
  Map<MarkerId, CPR> idToCpr = {};
  Set<Marker> _markers = HashSet<Marker>();
  Set<Polyline> _polylines = HashSet<Polyline>();
  List<LatLng> routeCoords = [];

  GoogleMapPolyline googleMapPolyline =
      GoogleMapPolyline(apiKey: FlutterConfig.get("MAPS_APIKEY"));

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
      Marker marker = Marker(
        markerId: MarkerId("marker_id_${_markers.length}"),
        position: LatLng(cpr.lat, cpr.long),
      );
      _markers.add(marker);
      idToCpr[MarkerId("marker_id_${_markers.length - 1}")] = cpr;
    }
    setState(() {});
  }

  void drawRoute() async {
    var doc = await DocRefs.emergency("JgNn5JoiLspSZAcwUQFx").get();
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    GeoPoint loc = data["location"];
    LatLng end = LatLng(loc.latitude, loc.longitude);
    _markers.add(Marker(
      markerId: MarkerId("marker_id_${_markers.length}"),
      position: LatLng(end.latitude, end.longitude),
    ));
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

  // void onClick(Marker marker {
  //   bool remove = false;
  //   showDialog(
  //     context: context2,
  //     builder: (BuildContext context) => AlertDialog(
  //       title: Text(
  //         idToCpr[marker]!.name,
  //       ),
  //       content: Text(idToCpr[marker]!.address),
  //       actions: [
  //         TextButton(
  //           onPressed: () {
  //             remove = true;
  //           },
  //           child: Text("Pick up"),
  //         )
  //       ],
  //     ),
  //   ).then((value) => setState(() {
  //         if (remove) {
  //           _markers.remove(marker);
  //         }
  //       },),);

  // void on

  @override
  Widget build(BuildContext context) {
    if (location == null) getLocation(context);
    if (location != null && _markers.isEmpty) updateLocation();
    if (location != null && routeCoords.isEmpty) drawRoute();

    return Navigator(
      onGenerateRoute: (_) => MaterialPageRoute(
        builder: (ctx) => Scaffold(
          backgroundColor: bgcolor,
          body: Stack(
            children: [
              SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      flex: 3,
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
                    Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                            "Directions: Mariott Hotel, 5th floor, by the bar")),
                    Expanded(
                      flex: 2,
                      child: Container(
                        color: Colors.red,
                        child: ListView.builder(
                          itemCount: messages.length,
                          itemBuilder: ((context, index) {
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                              child: Container(
                                width: 30,
                                padding: EdgeInsets.fromLTRB(12, 9, 12, 8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  messages[index % messages.length],
                                  style: TextStyle(color: black, fontSize: 15),
                                ),
                              ),
                            );
                          }),
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
