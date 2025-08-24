// alert_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/Alert.dart';

class AlertService {
  final String baseUrl = 'https://your-api-url.com/api'; // Replace with your API
  final String apiKey = 'your-api-key'; // Replace with your API key if needed

  Future<List<Alert>> fetchAlerts() async {
    try {
      // Simulate API call with dummy data for now
      await Future.delayed(Duration(seconds: 1));

      // Dummy data with Riyadh coordinates - replace with actual API call
      return [
        Alert(
          id: '1',
          title: 'Fire Emergency',
          description: 'Building fire reported at downtown location',
          latitude: 24.7136,
          longitude: 46.6753,
          createdAt: DateTime.now().subtract(Duration(minutes: 10)),
          expiresAt: DateTime.now().add(Duration(hours: 1)),
          status: 'active',
        ),
        Alert(
          id: '2',
          title: 'Medical Emergency',
          description: 'Person collapsed in office building',
          latitude: 24.7253,
          longitude: 46.6852,
          createdAt: DateTime.now().subtract(Duration(minutes: 5)),
          expiresAt: DateTime.now().add(Duration(minutes: 30)),
          status: 'active',
        ),
        Alert(
          id: '3',
          title: 'Gas Leak',
          description: 'Report of gas smell in apartment complex',
          latitude: 24.6981,
          longitude: 46.6919,
          createdAt: DateTime.now().subtract(Duration(minutes: 15)),
          expiresAt: DateTime.now().add(Duration(minutes: 45)),
          status: 'active',
        ),
      ];

      // Uncomment below for actual API implementation:
      /*
      final response = await http.get(
        Uri.parse('$baseUrl/alerts'),
        headers: {'Authorization': 'Bearer $apiKey'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Alert.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load alerts: ${response.statusCode}');
      }
      */
    } catch (e) {
      print('Error fetching alerts: $e');
      throw Exception('Failed to load alerts');
    }
  }

  Future<List<Alert>> checkForNewAlerts(String lastChecked) async {
    try {
      // Implement actual API call to check for new alerts since lastChecked
      final response = await http.get(
        Uri.parse('$baseUrl/alerts?since=$lastChecked'),
        headers: {'Authorization': 'Bearer $apiKey'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Alert.fromJson(json)).toList();
      } else {
        throw Exception('Failed to check for new alerts: ${response.statusCode}');
      }
    } catch (e) {
      print('Error checking for new alerts: $e');
      return [];
    }
  }

  Future<bool> updateAlertStatus(String alertId, String status, {String? cancelReason}) async {
    try {
      // Implement API call to update alert status
      final response = await http.put(
        Uri.parse('$baseUrl/alerts/$alertId/status'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: json.encode({
          'status': status,
          'cancel_reason': cancelReason,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to update alert status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating alert status: $e');
      return false;
    }
  }

  Future<bool> createAlert(Alert alert) async {
    try {
      // Implement API call to create a new alert
      final response = await http.post(
        Uri.parse('$baseUrl/alerts'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: json.encode(alert.toJson()),
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        throw Exception('Failed to create alert: ${response.statusCode}');
      }
    } catch (e) {
      print('Error creating alert: $e');
      return false;
    }
  }

  Future<bool> deleteAlert(String alertId) async {
    try {
      // Implement API call to delete an alert
      final response = await http.delete(
        Uri.parse('$baseUrl/alerts/$alertId'),
        headers: {'Authorization': 'Bearer $apiKey'},
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to delete alert: ${response.statusCode}');
      }
    } catch (e) {
      print('Error deleting alert: $e');
      return false;
    }
  }
}