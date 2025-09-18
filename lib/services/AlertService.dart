import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/Alert.dart';
import '../providers/AlertServiceProvider.dart';
import 'NatService.dart';
import 'notificationService.dart';
class AlertService {
  final Ref ref;
  final NotificationService _notificationService = NotificationService();

  AlertService(this.ref) {
    _initialize();
  }

  Future<void> _initialize() async {
    await _notificationService.initialize(onNotificationTap: _handleNotificationTap);
    _subscribeToNatsAlerts();
  }

  void _handleNotificationTap(String payload) {
    try {
      final alertData = jsonDecode(payload);
      print('Tapped notification with: $alertData');
    } catch (e) {
      print('Error parsing notification payload: $e');
    }
  }

  void _subscribeToNatsAlerts() {
    NatsService.subscribe("alerts.create", (String message) async {
      try {
        final dynamic parsedMessage = jsonDecode(message);
        Alert alert;

        if (parsedMessage is Map) {
          alert = Alert(
            id: parsedMessage['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
            title: parsedMessage['title'] ?? '🚨 New Alert',
            description: parsedMessage['description'] ?? 'New alert received',
            latitude: (parsedMessage['latitude'] ?? 24.7136).toDouble(),
            longitude: (parsedMessage['longitude'] ?? 46.6753).toDouble(),
            createdAt: parsedMessage['createdAt'] != null
                ? DateTime.parse(parsedMessage['createdAt'])
                : DateTime.now(),
            expiresAt: DateTime.now().add(const Duration(hours: 1)),
            status: parsedMessage['status'] ?? 'active',
            severity: parsedMessage['severity'],
            type: parsedMessage['type'],
            zone: parsedMessage['zone'],
            buildingName: parsedMessage['buildingName'],
          );
        } else {
          alert = Alert(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            title: "🚨 New Alert",
            description: message,
            latitude: 24.7136,
            longitude: 46.6753,
            createdAt: DateTime.now(),
            expiresAt: DateTime.now().add(const Duration(hours: 1)),
            status: 'active',
          );
        }

        print('✅ Received alert from NATS: ${alert.title}');
        ref.read(alertsProvider.notifier).addAlert(alert);

        await _notificationService.showNotification(
          id: int.parse(alert.id) % 2147483647,
          title: alert.title,
          body: alert.description,
          payload: jsonEncode(alert.toJson()),
        );
      } catch (e) {
        print('❌ Error processing NATS alert: $e');
      }
    });
  }
}
