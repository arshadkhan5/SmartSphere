import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/Alert.dart';
import '../providers/AlertServiceProvider.dart';
import '../services/BackgroundService.dart';
import '../services/NotificationService.dart';
import 'AlertDetailScreen.dart';

class FireFighterDashboard extends ConsumerStatefulWidget {
  const FireFighterDashboard({super.key});

  @override
  ConsumerState<FireFighterDashboard> createState() => _FireFighterDashboardState();
}

class _FireFighterDashboardState extends ConsumerState<FireFighterDashboard> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _cancelReasonController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _initializeServices();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _cancelReasonController.dispose();
    super.dispose();
  }

  Future<void> _initializeServices() async {
    // Initialize notifications
   // await NotificationService.initialize();

    // Initialize background service
   // await BackgroundService.initialize();

    // Start background service for firefighters
   // await BackgroundService.startBackgroundService();

    // Load initial alerts
    ref.read(alertsProvider.notifier).loadAlerts();

    ref.read(backgroundServiceProvider.notifier).state = true;
  }

  void _handleAcceptAlert(Alert alert) {
    // Update the alert status to "accepted"
    ref.read(alertsProvider.notifier).updateAlertStatus(alert.id, "accepted");

    // Navigate to the detail screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AlertDetailScreen(alert: alert),
      ),
    );
  }

  void _handleIgnoreAlert(String alertId) {
    // Update the alert status to "ignored"
    ref.read(alertsProvider.notifier).updateAlertStatus(alertId, "ignored");
  }

  void _handleCancelAlert(String alertId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Cancel Alert"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Are you sure you want to cancel this alert?"),
              SizedBox(height: 16),
              TextField(
                controller: _cancelReasonController,
                decoration: InputDecoration(
                  labelText: "Reason for cancellation",
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("No"),
            ),
            ElevatedButton(
              onPressed: () {
                if (_cancelReasonController.text.isNotEmpty) {
                  // Update the alert status to "cancelled" with reason
                  ref.read(alertsProvider.notifier).updateAlertStatus(
                      alertId,
                      "cancelled",
                      cancelReason: _cancelReasonController.text
                  );
                  _cancelReasonController.clear();
                  Navigator.of(context).pop();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Alert cancelled')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please provide a reason for cancellation')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text("Yes, Cancel", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final alerts = ref.watch(alertsProvider);
    final backgroundServiceRunning = ref.watch(backgroundServiceProvider);

    // Filter alerts based on status
    final activeAlerts = alerts.where((alert) => alert.status == 'active').toList();
    final ignoredAlerts = alerts.where((alert) => alert.status == 'ignored').toList();
    final cancelledAlerts = alerts.where((alert) => alert.status == 'cancelled').toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("Fire Fighter Dashboard",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    Color(0xFFFF0007), // Red
                    Color(0xFFFF0068),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter
              )
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: "Active (${activeAlerts.length})"),
            Tab(text: "Rejected (${ignoredAlerts.length})"),
            Tab(text: "Cancelled (${cancelledAlerts.length})"),
          ],
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white.withOpacity(0.7),
        ),
        actions: [
          IconButton(
            icon: Icon(backgroundServiceRunning ? Icons.notifications_active : Icons.notifications_off),
            onPressed: () async {
              if (backgroundServiceRunning) {
              //  await BackgroundService.stopBackgroundService();
                ref.read(backgroundServiceProvider.notifier).state = false;
              } else {
               // await BackgroundService.startBackgroundService();
                ref.read(backgroundServiceProvider.notifier).state = true;
              }
            },
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Active Tab
          _buildAlertList(
            alerts: activeAlerts,
            showAccept: true,
            showIgnore: true,
            showCancel: true,
          ),

          // Rejected Tab
          _buildAlertList(
            alerts: ignoredAlerts,
            showAccept: false,
            showIgnore: false,
            showCancel: false,
          ),

          // Cancelled Tab
          _buildAlertList(
            alerts: cancelledAlerts,
            showAccept: false,
            showIgnore: false,
            showCancel: false,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: () => ref.read(alertsProvider.notifier).loadAlerts(),
        child: Icon(Icons.refresh, color: Colors.white),
      ),
    );
  }

  Widget _buildAlertList({
    required List<Alert> alerts,
    required bool showAccept,
    required bool showIgnore,
    required bool showCancel,
  }) {
    if (alerts.isEmpty) {
      return Center(child: Text('No alerts found'));
    }

    return ListView.builder(
      itemCount: alerts.length,
      itemBuilder: (context, index) {
        final alert = alerts[index];
        return AlertCard(
          alert: alert,
          onAccept: showAccept ? () => _handleAcceptAlert(alert) : null,
          onIgnore: showIgnore ? () => _handleIgnoreAlert(alert.id) : null,
          onCancel: showCancel ? () => _handleCancelAlert(alert.id) : null,
          showCancelReason: alert.status == 'cancelled',
        );
      },
    );
  }
}

class AlertCard extends StatelessWidget {
  final Alert alert;
  final VoidCallback? onAccept;
  final VoidCallback? onIgnore;
  final VoidCallback? onCancel;
  final bool showCancelReason;

  const AlertCard({
    super.key,
    required this.alert,
    this.onAccept,
    this.onIgnore,
    this.onCancel,
    this.showCancelReason = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(12),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with status and priority
            _buildHeader(context),

            SizedBox(height: 16),

            // Alert content
            _buildAlertContent(),

            SizedBox(height: 16),

            // Action buttons
            if (onAccept != null || onIgnore != null || onCancel != null)
              _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        // Status icon with color coding
        Container(
          padding: EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: _getStatusColor(alert.status).withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(
            _getStatusIcon(alert.status),
            color: _getStatusColor(alert.status),
            size: 20,
          ),
        ),

        SizedBox(width: 12),

        // Alert title
        Expanded(
          child: Text(
            alert.title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.grey[800],
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),

        // Status badge
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _getStatusColor(alert.status).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            alert.status.toUpperCase(),
            style: TextStyle(
              color: _getStatusColor(alert.status),
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAlertContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Description
        Text(
          alert.description,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[700],
            height: 1.4,
          ),
        ),

        SizedBox(height: 12),

        // Location with map icon
        Row(
          children: [
            Icon(Icons.location_on, size: 16, color: Colors.red),
            SizedBox(width: 4),
            Expanded(
              child: Text(
                '${alert.latitude.toStringAsFixed(4)}, ${alert.longitude.toStringAsFixed(4)}',
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              ),
            ),
          ],
        ),

        SizedBox(height: 8),

        // Time information
        Row(
          children: [
            Icon(Icons.access_time, size: 16, color: Colors.grey),
            SizedBox(width: 4),
            Text(
              'Created: ${_formatTime(alert.createdAt)}',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),

        if (alert.expiresAt != null) ...[
          SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.timer, size: 16, color: Colors.orange),
              SizedBox(width: 4),
              Text(
                'Expires: ${_formatTime(alert.expiresAt!)}',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
        ],

        // Cancel reason if available
        if (showCancelReason && alert.cancelReason != null) ...[
          SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cancellation Reason:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  alert.cancelReason!,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final buttons = <Widget>[];

    if (onAccept != null) {
      buttons.add(
        Expanded(
          child: ElevatedButton.icon(
            icon: Icon(Icons.check_circle, size: 18),
            onPressed: onAccept,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            label: Text("Accept", style: TextStyle(fontSize: 13)),
          ),
        ),
      );
    }

    if (onIgnore != null) {
      if (buttons.isNotEmpty) buttons.add(SizedBox(width: 8));
      buttons.add(
        Expanded(
          child: OutlinedButton.icon(
            icon: Icon(Icons.remove_circle, size: 18, color: Colors.orange),
            onPressed: onIgnore,
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.orange,
              padding: EdgeInsets.symmetric(vertical: 12),
              side: BorderSide(color: Colors.orange),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            label: Text("Ignore", style: TextStyle(fontSize: 13)),
          ),
        ),
      );
    }

    if (onCancel != null) {
      if (buttons.isNotEmpty) buttons.add(SizedBox(width: 8));
      buttons.add(
        Expanded(
          child: OutlinedButton.icon(
            icon: Icon(Icons.cancel, size: 18, color: Colors.red),
            onPressed: onCancel,
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red,
              padding: EdgeInsets.symmetric(vertical: 12),
              side: BorderSide(color: Colors.red),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            label: Text("Cancel", style: TextStyle(fontSize: 13)),
          ),
        ),
      );
    }

    return Row(
      children: buttons,
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
    if (difference.inHours < 24) return '${difference.inHours}h ago';

    return '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')} '
        '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Icons.warning;
      case 'accepted':
        return Icons.check_circle;
      case 'ignored':
        return Icons.do_not_disturb;
      case 'cancelled':
        return Icons.cancel;
      default:
        return Icons.info;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Colors.orange;
      case 'accepted':
        return Colors.green;
      case 'ignored':
        return Colors.grey;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }
}