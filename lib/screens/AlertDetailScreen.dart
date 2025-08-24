// AlertDetailScreen.dart
import 'package:flutter/material.dart';
import 'package:smart_sphere/model/Alert.dart';
import 'package:smart_sphere/screens/FireFighterScreen.dart'; // Your existing map screen

class AlertDetailScreen extends StatelessWidget {
  final Alert alert;

  const AlertDetailScreen({super.key, required this.alert});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alert Details'),
        flexibleSpace: Container(
          foregroundDecoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Color(0xFFFF0007), // Red
              Color(0xFFFF0068),
            ],

                begin: Alignment.topCenter,
                end: Alignment.bottomCenter)
          ),
        ),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Alert Information
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      alert.title,
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    Text(
                      alert.description,
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 16),
                    _buildDetailRow(Icons.location_on, 'Location:', alert.location),
                    SizedBox(height: 8),
                    _buildDetailRow(Icons.access_time, 'Created:', _formatDateTime(alert.createdAt)),
                    if (alert.expiresAt != null)
                      Column(
                        children: [
                          SizedBox(height: 8),
                          _buildDetailRow(Icons.timer_off, 'Expires:', _formatDateTime(alert.expiresAt!)),
                        ],
                      ),
                    SizedBox(height: 8),
                    _buildDetailRow(Icons.info, 'Status:', alert.status.toUpperCase(),
                        color: _getStatusColor(alert.status)),
                  ],
                ),
              ),
            ),

            SizedBox(height: 24),

           /* // Emergency Contacts Section
            Text(
              'Emergency Contacts',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                ActionChip(
                  avatar: Icon(Icons.call, color: Colors.white, size: 18),
                  label: Text('Call Fire Dept'),
                  onPressed: () => _makePhoneCall('+1234567890'),
                  backgroundColor: Colors.red,
                  labelStyle: TextStyle(color: Colors.white),
                ),
                ActionChip(
                  avatar: Icon(Icons.call, color: Colors.white, size: 18),
                  label: Text('Call Ambulance'),
                  onPressed: () => _makePhoneCall('+1234567891'),
                  backgroundColor: Colors.red,
                  labelStyle: TextStyle(color: Colors.white),
                ),
                ActionChip(
                  avatar: Icon(Icons.message, color: Colors.white, size: 18),
                  label: Text('Send SMS'),
                  onPressed: () => _sendSMS('+1234567890'),
                  backgroundColor: Colors.blue,
                  labelStyle: TextStyle(color: Colors.white),
                ),
              ],
            ),

            SizedBox(height: 24),
*/
            // Map and Navigation Section
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FireFighterScreen(alert: alert),
                    ),
                  );
                },
                icon: Icon(Icons.map, color: Colors.white),
                label: Text('Track Location on Map', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
            ),

            SizedBox(height: 16),

           /* // Additional Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _markAsResolved(context),
                  child: Text('Mark as Resolved'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                ),
                ElevatedButton(
                  onPressed: () => _requestBackup(context),
                  child: Text('Request Backup'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                ),
              ],
            ),*/
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value, {Color? color}) {
    return Row(
      children: [
        Icon(icon, color: color ?? Colors.grey, size: 20),
        SizedBox(width: 8),
        Text(
          '$label ',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(color: color ?? Colors.black),
          ),
        ),
      ],
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')} ${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Colors.orange;
      case 'accepted':
        return Colors.green;
      case 'ignored':
        return Colors.grey;
      case 'expired':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  void _makePhoneCall(String phoneNumber) {
    // Implement phone call functionality
    // You can use url_launcher package: launch('tel:$phoneNumber');
    print('Calling $phoneNumber');
  }

  void _sendSMS(String phoneNumber) {
    // Implement SMS functionality
    // You can use url_launcher package: launch('sms:$phoneNumber');
    print('Sending SMS to $phoneNumber');
  }

  void _markAsResolved(BuildContext context) {
    // Implement mark as resolved logic
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Mark as Resolved'),
        content: Text('Are you sure you want to mark this alert as resolved?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Update alert status
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Alert marked as resolved')),
              );
            },
            child: Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void _requestBackup(BuildContext context) {
    // Implement backup request logic
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Request Backup'),
        content: Text('Request additional resources for this emergency?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Send backup request
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Backup requested')),
              );
            },
            child: Text('Request'),
          ),
        ],
      ),
    );
  }
}