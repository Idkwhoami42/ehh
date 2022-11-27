import 'dart:collection';
import 'dart:math';

import 'package:ehh/constants/theme.dart';
import 'package:ehh/controllers/cpr_locations.dart';
import 'package:ehh/controllers/permissions_controller.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:google_map_polyline_new/google_map_polyline_new.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class MapScreen2 extends StatefulWidget {
  MapScreen2({Key? key}) : super(key: key);

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
  LatLng patient = LatLng(1, 1);

  GoogleMapPolyline googleMapPolyline = GoogleMapPolyline(apiKey: FlutterConfig.get("MAPS_APIKEY"));

  void getLocation(BuildContext context) async {
    Provider.of<PermissionsController>(context, listen: false).requestPermission([Permission.location]);
    var loc = await Location().getLocation();
    location = LatLng(loc.latitude!, loc.longitude!);
    setState(() {
      print(location);
    });
  }

  void updateLocation() {
    for (CPR cpr in CPR_locations()) {
      double distance = (location!.latitude - cpr.lat) * (location!.latitude - cpr.lat);
      distance += (location!.longitude - cpr.long) * (location!.longitude - cpr.long);
      distance = sqrt(distance);

      if (distance > 0.03) continue;

      _markers.add(Marker(markerId: MarkerId("marker_id_${_markers.length}"), position: LatLng(cpr.lat, cpr.long)));
      coordsToCpr[LatLng(cpr.lat, cpr.long)] = cpr;
    }
    setState(() {});
  }

  void drawRoute() async {
    LatLng end = patient; // placeholder
    // print(location);
    routeCoords = (await googleMapPolyline.getCoordinatesWithLocation(origin: location!, destination: end, mode: RouteMode.walking))!;
    // print(routeCoords);
    _polylines.add(
      Polyline(
        polylineId: const PolylineId('iter'),
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
    context2 = context;
    updateLocation();
    drawRoute();

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
                                  initialCameraPosition: CameraPosition(target: location!, zoom: 13.5),
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
                            itemCount: messages.length,
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
                                    messages[index % messages.length],
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
