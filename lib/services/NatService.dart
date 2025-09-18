// nats_service.dart
import 'dart:async';
import 'dart:convert';
import 'package:dart_nats/dart_nats.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

class NatsService {
  static final Client _client = Client();
  static bool _connected = false;
  static final Map<String, List<Function(String)>> _subscribers = {};

  static bool get isConnected => _connected;

  static Future<void> connect() async {
    try {
      final uri = Uri.parse("nats://161.97.129.123:4222");

      await _client.connect(
        uri,
        connectOption: ConnectOption(
          user: 'arif',
          pass: 'arshad',
        ),
      );

      _connected = true;
      print("Connected to NATS server.");

      // Resubscribe to all existing subscriptions
      for (final subject in _subscribers.keys) {
        _client.sub(subject)?.stream.listen((Message msg) {
          final String message = msg.string ?? '[Non-UTF8 Message]';
          print("NATS Received: $message");

          // Notify all subscribers for this subject
          if (_subscribers.containsKey(subject)) {
            for (final callback in _subscribers[subject]!) {
              callback(message);
            }
          }
        });
      }

    } catch (e) {
      print("NATS connection error: $e");
      _connected = false;
      rethrow;
    }
  }

  static Future<void> subscribe(String subject, Function(String) onMessage) async {
    // Add to subscribers list
    if (!_subscribers.containsKey(subject)) {
      _subscribers[subject] = [];
    }
    _subscribers[subject]!.add(onMessage);

    if (!_connected) {
      await connect();
    }

    _client.sub(subject)?.stream.listen((Message msg) async {
      final String message = msg.string ?? '[Non-UTF8 Message]';
      print("NATS Received: $message");

      // Check if background service is running
      final bool isBgRunning = await FlutterBackgroundService().isRunning();

      if (!isBgRunning) {
        // If background service isn't running, handle notification here
        print("Would show notification: $message");
      }

      onMessage(message);
    });
  }

  static Future<void> publish(String subject, String message) async {
    if (!_connected) {
      await connect();
    }

    _client.pubString(subject, message);
    print('Message published to "$subject": $message');
  }

  static Future<void> publishAlert(String subject, Map<String, dynamic> alertData) async {
    if (!_connected) {
      await connect();
    }

    // Ensure the alert data has required fields
    final Map<String, dynamic> completeAlertData = {
      ...alertData,
      'id': alertData['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      'createdAt': alertData['createdAt'] ?? DateTime.now().toIso8601String(),
      'status': alertData['status'] ?? 'active',
    };

    final String message = jsonEncode(completeAlertData);
    _client.pubString(subject, message);

    print('📤 Alert published to "$subject": $message');
  }

  static Future<void> disconnect() async {
    _client.close();
    _connected = false;
    _subscribers.clear();
    print("Disconnected from NATS server.");
  }

  static void unsubscribe(String subject, Function(String) callback) {
    if (_subscribers.containsKey(subject)) {
      _subscribers[subject]!.remove(callback);
      if (_subscribers[subject]!.isEmpty) {
        _subscribers.remove(subject);
      }
    }
  }
}

/*
import 'dart:async';
import 'dart:convert';
import 'package:dart_nats/dart_nats.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

class NatsService {
  static final Client _client = Client();
  static bool _connected = false;

  static bool get isConnected => _connected;

  static Future<void> connect() async {
    try {
      final uri = Uri.parse("nats://161.97.129.123:4222");

      await _client.connect(
        uri,
        connectOption: ConnectOption(
          user: 'arif',
          pass: 'arshad',
        ),
      );

      _connected = true;
      print("Connected to NATS server.");

    } catch (e) {
      print("NATS connection error: $e");
      _connected = false;
      rethrow;
    }
  }

  static Future<void> subscribe(String subject, Function(String) onMessage) async {
    if (!_connected) {
      await connect();
    }

    _client.sub(subject)?.stream.listen((Message msg) async {
      final String message = msg.string ?? '[Non-UTF8 Message]';
      print("NATS Received: $message");

      // Check if background service is running
      final bool isBgRunning = await FlutterBackgroundService().isRunning();

      if (!isBgRunning) {
        // If background service isn't running, handle notification here
        print("Would show notification: $message");
      }

      onMessage(message);
    });
  }

  static Future<void> publish(String subject, String message) async {
    if (!_connected) {
      await connect();
    }

    _client.pubString(subject, message);
    print('Message published to "$subject": $message');
  }

  static Future<void> publishAlert(String subject, Map<String, dynamic> alertData) async {
    if (!_connected) {
      await connect();
    }

    // Ensure the alert data has required fields
    final Map<String, dynamic> completeAlertData = {
      ...alertData,
      'id': alertData['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      'createdAt': alertData['createdAt'] ?? DateTime.now().toIso8601String(),
      'status': alertData['status'] ?? 'active',
    };

    final String message = jsonEncode(completeAlertData);
    _client.pubString(subject, message);

    print('📤 Alert published to "$subject": $message');
  }

  static Future<void> disconnect() async {
    _client.close();
    _connected = false;
    print("Disconnected from NATS server.");
  }
}*/
