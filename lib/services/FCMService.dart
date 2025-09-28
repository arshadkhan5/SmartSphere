// lib/services/fcm_v1_service.dart
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;

/// WARNING: Only for testing — embedding service account in app is insecure.
class FcmV1Service {
  static const List<String> _scopes = <String>[
    'https://www.googleapis.com/auth/firebase.messaging'
  ];

  final String projectId = "smartsphere-b151a"; // <-- replace if needed
  AutoRefreshingAuthClient? _authedClient;

  Future<AutoRefreshingAuthClient> _getAuthedClient() async {
    if (_authedClient != null) return _authedClient!;
    final jsonStr = await rootBundle.loadString('assets/service_account.json');
    final Map<String, dynamic> sa = jsonDecode(jsonStr);
    final accountCredentials = ServiceAccountCredentials.fromJson(sa);
    final client = await clientViaServiceAccount(accountCredentials, _scopes);
    _authedClient = client;
    return _authedClient!;
  }

  Future<http.Response> sendToTopic({
    required String topic,
    required String title,
    required String body,
    Map<String, String>? data,
  }) async {
    final client = await _getAuthedClient();
    final url = Uri.parse('https://fcm.googleapis.com/v1/projects/$projectId/messages:send');

    final message = {
      "message": {
        "topic": topic,
        "notification": {"title": title, "body": body},
        if (data != null) "data": data,
      }
    };

    final resp = await client.post(
      url,
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(message),
    );

    print('FCM sendToTopic: ${resp.statusCode} ${resp.body}');
    return resp;
  }

  void close() {
    _authedClient?.close();
    _authedClient = null;
  }
}


