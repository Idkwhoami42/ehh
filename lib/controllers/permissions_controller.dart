import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionsController extends ChangeNotifier {
  /// Permission statuses.
  Map<Permission, PermissionStatus>? get permissions => _permissions;
  Map<Permission, PermissionStatus>? _permissions;

  PermissionsController() {
    _init();
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
