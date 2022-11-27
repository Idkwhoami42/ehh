import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:heartstart/controllers/auth_controller.dart';
import 'package:heartstart/models/status_message.dart';
import 'package:heartstart/services/firestore/firestore_references.dart';

class EmergencyService {
  Future<void> addStatusMessage(
      String emergencyId, StatusMessage statusMessage) async {
    HttpsCallable addStatusMessage =
        FirebaseFunctions.instance.httpsCallable("emergencies-addMessage");
    addStatusMessage.call({
      "userId": AuthController.instance.currentUser!.id,
      "action": statusMessage.type,
      "emergencyId": emergencyId,
    });
  }

  Query emergencyMessages(String emergencyId) {
    return DocRefs.emergency(emergencyId)
        .collection("messages")
        .orderBy("time", descending: true);
  }
}
