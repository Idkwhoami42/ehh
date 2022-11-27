import 'package:cloud_functions/cloud_functions.dart';
import 'package:ehh/models/status_message.dart';

class EmergencyService {
  Future<void> addStatusMessage(StatusMessage statusMessage) async {
    HttpsCallable addStatusMessage =
        FirebaseFunctions.instance.httpsCallable("emergencies-addMessage");
  }
}
