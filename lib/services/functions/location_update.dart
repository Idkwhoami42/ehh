// import 'dart:async';

// import 'package:location/location.dart';

// class LocationUpdate {
//   late LocationData _currentLocation;
//     var location = Location();
//   Future<LocationData> getLocation() async {

//     try {
//       _currentLocation = await location.getLocation();
//     } on Exception catch (e) {
//       print('Could not get location: ${e.toString()}');
//     }
//     return _currentLocation;
//   }

//   //Stream that emits all user location updates to you
//   StreamController<LocationData> _locationController = StreamController<LocationData>();
//   Stream<LocationData> get locationStream => _locationController.stream;
//   LocationService() {
//     // Request permission to use location
//     location.requestPermission().then((granted) {
//       if (granted == PermissionStatus.granted) {
//         // If granted listen to the onLocationChanged stream and emit over our controller
//         location.onLocationChanged().listen((locationData) {
//           if (locationData != null) {
//             _locationController.add(LocationData(
//               latitude: locationData.latitude,
//               longitude: locationData.longitude,
//             ));
//           }
//         });
//       }
//     });
//   }
// }
