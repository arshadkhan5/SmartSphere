// lib/services/firestore_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';

import 'FCMService.dart';

class FirestoreService {
  static final _alertsRef = FirebaseFirestore.instance.collection("alerts");
  static final _locationRef = FirebaseFirestore.instance.collection("location");
  static final fcmService = FcmV1Service();

  /// Create alert and notify responders by role topic (firefighter/ambulance).
  static Future<void> createAlert({
    required String type,
    required String targetRole,
    required String customerId,
  }) async {
    final docRef = await _alertsRef.add({
      "type": type,
      "targetRole": targetRole,
      "status": "pending",
      "reason": null,
      "customerId": customerId,
      "firefighterId": null,
      "timestamp": FieldValue.serverTimestamp(),
    });

    // notify role topic
    await fcmService.sendToTopic(
      topic: targetRole,
      title: "🚨 New Alert",
      body: "Alert Type: $type",
      data: {
        "alertId": docRef.id,
        "type": type,
        "customerId": customerId,
      },
    );
  }

  static Stream<QuerySnapshot> getAlertsForRole(String role) {
    return _alertsRef.where("targetRole", isEqualTo: role)/*.orderBy("timestamp", descending: true)*/.snapshots();
  }

  /// Accept an alert: set status + firefighterId and notify the customer
  static Future<void> acceptAlert({
    required String alertId,
    required String responderId,
    required String responderRole, // "firefighter" or "ambulance"
  }) async {
    final docRef = _alertsRef.doc(alertId);
    final snap = await docRef.get();
    if (!snap.exists) return;
    final data = snap.data()!;
    final customerId = data['customerId'] as String?;

    await docRef.update({
      "status": "accepted",
      "firefighterId": responderId,
      "acceptedAt": FieldValue.serverTimestamp(),
    });

    // notify the specific customer via per-user topic:
    if (customerId != null) {
      final topic = "user_$customerId";
      await fcmService.sendToTopic(
        topic: topic,
        title: "✅ Response Accepted",
        body: "${responderRole.capitalize() } accepted your alert.",
        data: {
          "alertId": alertId,
          "responderId": responderId,
          "responderRole": responderRole,
          "action": "accepted",
        },
      );
    }
  }

  static Future<void> updateAlertStatus(String docId, String status, {String? reason}) async {
    await _alertsRef.doc(docId).update({
      "status": status,
      "reason": reason,
      "updatedAt": FieldValue.serverTimestamp()
    });
  }

  // LOCATION helpers
  static Future<void> updateUserLocation(String userId, double lat, double lng, {String? name}) async {
    await _locationRef.doc(userId).set({
      "latitude": lat,
      "longitude": lng,
      if (name != null) "name": name,
      "updatedAt": FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  static Stream<DocumentSnapshot> getUserLocation(String userId) {
    return _locationRef.doc(userId).snapshots();
  }
}

/// small extension to capitalize role text for notification body
extension StringCasingExtension on String {
  String capitalize() {
    if (length == 0) return this;
    return this[0].toUpperCase() + substring(1);
  }
}

