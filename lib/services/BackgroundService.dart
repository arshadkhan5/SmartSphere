// background_service.dart
import 'package:workmanager/workmanager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';

import 'AlertService.dart';
import 'NotificationService.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case 'alertCheckTask':
        await _checkForNewAlerts();
        return true;
      default:
        return false;
    }
  });
}

Future<void> _checkForNewAlerts() async {
  final prefs = await SharedPreferences.getInstance();
  final lastChecked = prefs.getString('lastAlertCheck') ?? DateTime.now().toIso8601String();

  final alertService = AlertService();
  final newAlerts = await alertService.checkForNewAlerts(lastChecked);

  for (final alert in newAlerts) {
    if (!alert.isExpired) {
      await NotificationService.showAlertNotification(alert);
    }
  }

  await prefs.setString('lastAlertCheck', DateTime.now().toIso8601String());
}

class BackgroundService {
  static Future<void> initialize() async {
    // Only initialize Workmanager on Android
    if (Platform.isAndroid) {
      await Workmanager().initialize(
        callbackDispatcher,
        isInDebugMode: false,
      );
    }
  }

  static Future<void> startBackgroundService() async {
    if (Platform.isAndroid) {
      // Use Workmanager for Android background tasks
      await Workmanager().registerPeriodicTask(
        'alertCheckTask',
        'alertCheckTask',
        frequency: Duration(minutes: 5),
        constraints: Constraints(
          networkType: NetworkType.connected,
        ),
      );
    } else if (Platform.isIOS) {
      // For iOS, we'll use a different approach since Workmanager has limitations
      // We'll implement a foreground service with periodic checks
      await _startIOSBackgroundService();
    }
  }

  static Future<void> _startIOSBackgroundService() async {
    // iOS-specific background service implementation
    // This could use a timer-based approach while the app is in foreground
    // and request background processing time when needed

    // Store the service status
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('iosBackgroundServiceRunning', true);

    // Start a timer for periodic checks (this only works while app is in foreground)
    // For true background operation on iOS, you'd need to use other methods like:
    // - Background Fetch (limited to 30 seconds every 15 min)
    // - Push notifications triggered from server
    // - Significant location changes
  }

  static Future<void> stopBackgroundService() async {
    if (Platform.isAndroid) {
      await Workmanager().cancelByTag('alertCheckTask');
    } else if (Platform.isIOS) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('iosBackgroundServiceRunning', false);
      // Stop any iOS-specific background processing
    }
  }

  // iOS-specific method to handle background fetch
  static Future<void> handleIOSBackgroundFetch() async {
    if (Platform.isIOS) {
      await _checkForNewAlerts();
    }
  }
}