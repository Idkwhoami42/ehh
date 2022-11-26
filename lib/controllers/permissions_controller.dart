import 'package:flutter/material.dart';
import 'package:location/location.dart' as location;
import 'package:permission_handler/permission_handler.dart';

class PermissionsController extends ChangeNotifier {
  /// Permission statuses.
  Map<Permission, PermissionStatus>? get permissions => _permissions;
  Map<Permission, PermissionStatus>? _permissions;

  /// Service permission statuses.
  Map<Permission, ServiceStatus>? get servicePermissions => _servicePermissions;
  Map<Permission, ServiceStatus>? _servicePermissions;

  PermissionsController() {
    _init();
  }

  /// Request permissions.
  /// Return true if all requested permissions were granted.
  Future<bool> requestPermission(List<Permission> requestedPermissions) async {
    if (_permissions == null) {
      return false;
    }
    var result = true;
    Map<Permission, PermissionStatus> requestResult =
        await requestedPermissions.request();
    for (var entry in requestResult.entries) {
      result &= entry.value == PermissionStatus.granted;
      _permissions?[entry.key] = entry.value;
    }
    notifyListeners();
    return result;
  }

  /// Request services.
  /// Return true of all requested service permissions were given.
  Future<bool> requestService(
      List<Permission> requestedServicePermissions) async {
    if (_servicePermissions == null) return false;
    var result = true;
    for (Permission permission in requestedServicePermissions) {
      if (permission == Permission.location) {
        var isGranted = await location.Location().requestService();
        result &= isGranted;
        if (isGranted) {
          _servicePermissions![Permission.location] = ServiceStatus.enabled;
        }
      }
    }
    notifyListeners();
    return result;
  }

  Future<void> _init() async {
    // fetch new statuses
    Map<Permission, PermissionStatus> perms = {};
    // Map<Permission, ServiceStatus> services = {};
    perms[Permission.location] = await Permission.location.status;
    // services[Permission.location] = await Permission.location.serviceStatus;
    perms[Permission.camera] = await Permission.camera.status;
    perms[Permission.microphone] = await Permission.microphone.status;
    perms[Permission.notification] = await Permission.notification.status;

    // update controller data
    _permissions = perms;
    notifyListeners();
  }
}
