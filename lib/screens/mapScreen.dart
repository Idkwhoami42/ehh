import 'dart:collection';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:google_map_polyline_new/google_map_polyline_new.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
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
    "[1:45] Alice is on route to Emergency",
    "[1:48] Bob is on route to Emergency",
    "[1:50] Charles picked up the defibrillator",
  ];

  GoogleMapController? mapController;
  LatLng? location;
  Circle? selectedCpr;
  late BuildContext context2;
  Map<MarkerId, CPR> idToCpr = {};
  Set<Marker> _markers = HashSet<Marker>();
  Set<Polyline> _polylines = HashSet<Polyline>();
  List<LatLng> routeCoords = [];
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor markerIcon2 = BitmapDescriptor.defaultMarker;
  int markercount = 0;

  GoogleMapPolyline googleMapPolyline =
      GoogleMapPolyline(apiKey: FlutterConfig.get("MAPS_APIKEY"));

  void addCustomIcon() {
    BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(),
      "assets/AED.png",
    ).then((icon) {
      setState(() {
        markerIcon = icon;
      });
    });
    BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(),
      "assets/patient.png",
    ).then((icon) {
      setState(() {
        markerIcon2 = icon;
      });
    });
  }

  void getLocation(BuildContext context) async {
    Provider.of<PermissionsController>(context, listen: false)
        .requestPermission([Permission.location]);
    var loc = await Location().getLocation();
    location = LatLng(loc.latitude!, loc.longitude!);
    setState(() => print(location));
  }

  void updateLocation() async {
    for (CPR cpr in CPR_locations()) {
      double distance =
          (location!.latitude - cpr.lat) * (location!.latitude - cpr.lat);
      distance +=
          (location!.longitude - cpr.long) * (location!.longitude - cpr.long);
      distance = sqrt(distance);
      MarkerId id = MarkerId("marker_id_$markercount");
      if (distance > 0.03) continue;
      Marker marker = Marker(
        markerId: id,
        position: LatLng(cpr.lat, cpr.long),
        icon: markerIcon,
        onTap: () => onClick(id),
      );
      _markers.add(marker);
      idToCpr.putIfAbsent(id, () => cpr);
      markercount++;
    }
    setState(() {});
  }

  void drawRoute() async {
    var doc = await DocRefs.emergency("8x4vkdz0g9I4rqzmzoMV").get();
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    GeoPoint loc = data["location"];
    LatLng end = LatLng(loc.latitude, loc.longitude);
    // LatLng end = LatLng(50.02340599108475, 14.441085910291784);
    print(end);

    _markers.add(Marker(
      markerId: MarkerId("marker_id_$markercount"),
      position: LatLng(end.latitude, end.longitude),
      icon: markerIcon2,
    ));

    routeCoords = (await googleMapPolyline.getCoordinatesWithLocation(
      origin: location!,
      destination: end,
      mode: RouteMode.walking,
    ))!;

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

  void reroute(CPR cpr) async {
    var doc = await DocRefs.emergency("8x4vkdz0g9I4rqzmzoMV").get();
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    GeoPoint loc = data["location"];
    LatLng end = LatLng(loc.latitude, loc.longitude);
    print(end);

    var routeCoords1 = (await googleMapPolyline.getCoordinatesWithLocation(
      origin: location!,
      destination: LatLng(cpr.lat, cpr.long),
      mode: RouteMode.walking,
    ))!;
    var routeCoords2 = (await googleMapPolyline.getCoordinatesWithLocation(
      origin: LatLng(cpr.lat, cpr.long),
      destination: end,
      mode: RouteMode.walking,
    ))!;
    routeCoords = routeCoords1 + routeCoords2;
    _polylines.clear();
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

  void onClick(MarkerId id) {
    bool remove = false;

    showDialog(
      context: context2,
      builder: (BuildContext context) => AlertDialog(
        title: Text(
          idToCpr[id]!.name,
        ),
        content: Text(idToCpr[id]!.address),
        actions: [
          TextButton(
            onPressed: () {
              remove = true;
              Navigator.of(context).pop();
            },
            child: Text("Pick up"),
          )
        ],
      ),
    ).then(
      (value) => setState(
        () {
          if (remove) {
            reroute(idToCpr[id]!);
            // _markers.remove(_markers.firstWhere((element) => element.markerId == id));
          }
        },
      ),
    );
  }

  // void on

  @override
  void initState() {
    addCustomIcon();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (location == null) getLocation(context);
    if (location != null && _markers.isEmpty) updateLocation();
    if (location != null && routeCoords.isEmpty) drawRoute();
    context2 = context;

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
                    const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text(
                        "Úřad práce ČR, Kontaktní pracoviště Praha 4",
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16))),
                          // color: Colors.grey[350],
                          child: ListView.builder(
                            itemCount: messages.length,
                            reverse: true,
                            itemBuilder: ((context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8),
                                child: Container(
                                  width: 30,
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    messages[(messages.length - index - 1)],
                                    style:
                                        TextStyle(color: black, fontSize: 18),
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
              Positioned(
                right: 15,
                bottom: 270,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: ShapeDecoration(
                    color: Colors.red[400],
                    shape: CircleBorder(),
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.message_outlined,
                      color: Colors.white,
                      size: 26,
                    ),
                    onPressed: () {},
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
