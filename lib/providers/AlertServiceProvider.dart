// alert_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/Alert.dart';
import '../services/AlertService.dart';

// Provider for alert service
final alertServiceProvider = Provider<AlertService>((ref) {
  return AlertService();
});

// Provider for alerts list
final alertsProvider = StateNotifierProvider<AlertsNotifier, List<Alert>>((ref) {
  return AlertsNotifier(ref.read(alertServiceProvider));
});

// Notifier for alerts
class AlertsNotifier extends StateNotifier<List<Alert>> {
  final AlertService alertService;

  AlertsNotifier(this.alertService) : super([]);

  Future<void> loadAlerts() async {
    try {
      // Dummy data with Riyadh coordinates
      final dummyAlerts = [
        Alert(
          id: '1',
          title: 'Fire Emergency',
          description: 'Building fire reported at downtown location',
          latitude: 24.7136, // Riyadh coordinates
          longitude: 46.6753,
          createdAt: DateTime.now().subtract(Duration(minutes: 10)),
          expiresAt: DateTime.now().add(Duration(hours: 1)),
          status: 'active',
        ),
        Alert(
          id: '2',
          title: 'Medical Emergency',
          description: 'Person collapsed in office building',
          latitude: 24.7253, // King Fahd Road area
          longitude: 46.6852,
          createdAt: DateTime.now().subtract(Duration(minutes: 5)),
          expiresAt: DateTime.now().add(Duration(minutes: 30)),
          status: 'active',
        ),
        Alert(
          id: '3',
          title: 'Gas Leak',
          description: 'Report of gas smell in apartment complex',
          latitude: 24.6981, // Al Olaya district
          longitude: 46.6919,
          createdAt: DateTime.now().subtract(Duration(minutes: 15)),
          expiresAt: DateTime.now().add(Duration(minutes: 45)),
          status: 'active',
        ),
        Alert(
          id: '4',
          title: 'Car Accident',
          description: 'Multi-vehicle collision on highway',
          latitude: 24.7420, // Northern Riyadh
          longitude: 46.6528,
          createdAt: DateTime.now().subtract(Duration(minutes: 8)),
          expiresAt: DateTime.now().add(Duration(minutes: 40)),
          status: 'active',
        ),
        Alert(
          id: '5',
          title: 'Industrial Accident',
          description: 'Accident reported at construction site',
          latitude: 24.7682, // Eastern Industrial Area
          longitude: 46.7384,
          createdAt: DateTime.now().subtract(Duration(minutes: 20)),
          expiresAt: DateTime.now().add(Duration(minutes: 50)),
          status: 'active',
        ),
      ];

      state = dummyAlerts.where((alert) => !alert.isExpired).toList();

      // Later, replace with API call:
      // final alerts = await alertService.fetchAlerts();
      // state = alerts.where((alert) => !alert.isExpired).toList();
    } catch (e) {
      print('Error loading alerts: $e');
    }
  }

  void addAlert(Alert alert) {
    if (!alert.isExpired) {
      state = [...state, alert];
    }
  }

  void removeExpiredAlerts() {
    state = state.where((alert) => !alert.isExpired).toList();
  }

  void updateAlertStatus(String alertId, String newStatus, {String? cancelReason}) {
    state = state.map((alert) {
      if (alert.id == alertId) {
        return alert.copyWith(
          status: newStatus,
          cancelReason: cancelReason,
        );
      }
      return alert;
    }).toList();
  }

  void removeAlert(String alertId) {
    state = state.where((alert) => alert.id != alertId).toList();
  }
}

// Provider for background service status
final backgroundServiceProvider = StateProvider<bool>((ref) => false);