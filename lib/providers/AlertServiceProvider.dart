import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/Alert.dart';
import '../services/AlertService.dart';
/// State management for alerts
final alertsProvider = StateNotifierProvider<AlertsNotifier, List<Alert>>((ref) {
  return AlertsNotifier();
});

class AlertsNotifier extends StateNotifier<List<Alert>> {
  AlertsNotifier() : super([]);

  void addAlert(Alert alert) {
    if (!alert.isExpired) {
      state = [alert, ...state];
    }
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

  void clearAlerts() {
    state = [];
  }
}

/// Service provider (creates one AlertService instance per app lifecycle)
final alertServiceProvider = Provider<AlertService>((ref) {
  return AlertService(ref);
});
