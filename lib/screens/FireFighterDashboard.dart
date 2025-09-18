import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smart_sphere/screens/LoginScreen.dart';
import '../l10n/app_localizations.dart';
import '../model/Alert.dart';
import '../providers/AlertServiceProvider.dart';
import '../services/backgroundService.dart';
import 'AlertDetailScreen.dart';

class FireFighterDashboard extends ConsumerStatefulWidget {
  const FireFighterDashboard({super.key});

  @override
  ConsumerState<FireFighterDashboard> createState() => _FireFighterDashboardState();
}

class _FireFighterDashboardState extends ConsumerState<FireFighterDashboard> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _cancelReasonController = TextEditingController();
  bool _isServiceRunning = false;
  bool _isPermissionGranted = false;
  StreamSubscription? _backgroundServiceSubscription;

  @override
  void initState()  {
    super.initState();
    // _initializeServices();



    _initializeApp();
    _setupBackgroundServiceListener();
    _tabController = TabController(length: 3, vsync: this);


  }
  void _setupBackgroundServiceListener() {
    final service = FlutterBackgroundService();

    _backgroundServiceSubscription = service.on('new_alert').listen((event) {
      if (event != null) {
        final alertData = event['alert'];
        // Convert to Alert model and add to provider
        final alert = Alert.fromJson(alertData);
        ref.read(alertsProvider.notifier).addAlert(alert);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _cancelReasonController.dispose();
    super.dispose();
  }

  Future<void> _initializeApp() async {
    await BackgroundServiceManager.initialize();
    await _checkPermissions();
    await _checkServiceStatus();

    await BackgroundServiceManager.initialize();
    await BackgroundServiceManager.startService();

    // Load initial alerts
    ref.read(alertServiceProvider);
    //_listenToBackgroundService();
  }



  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Permissions Required'),
        content: Text(
            'This app requires notification and battery optimization permissions to work properly in the background.'
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  Future<void> _checkPermissions() async {
    // Request necessary permissions
    final permissions = [
      Permission.notification,
      Permission.ignoreBatteryOptimizations,
      if (Platform.isAndroid) Permission.accessNotificationPolicy,
    ];

    Map<Permission, PermissionStatus> statuses = await permissions.request();

    bool allGranted = statuses.values.every(
            (status) => status == PermissionStatus.granted || status == PermissionStatus.limited
    );

    setState(() {
      _isPermissionGranted = allGranted;
    });

    if (!allGranted) {
      _showPermissionDialog();
    } else {
      // Start service if permissions are granted
      await BackgroundServiceManager.startService();
      await _checkServiceStatus();
    }
  }
    Future<void> _checkServiceStatus() async {
      bool isRunning = await BackgroundServiceManager.isServiceRunning();
      setState(() {
        _isServiceRunning = isRunning;
      });
    }





  void _handleAcceptAlert(Alert alert) {
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
    final _formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.cancelAlert),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(AppLocalizations.of(context)!.areYouSureYouCancelAlert),
                SizedBox(height: 16),
                TextFormField(
                  controller: _cancelReasonController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.cancellationReason,
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return AppLocalizations.of(context)!.cancellationReasonRequired;
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(AppLocalizations.of(context)!.no),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Update the alert status to "cancelled" with reason
                  ref.read(alertsProvider.notifier).updateAlertStatus(
                      alertId,
                      "cancelled",
                      cancelReason: _cancelReasonController.text.trim()
                  );
                  _cancelReasonController.clear();
                  Navigator.of(context).pop();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Alert cancelled')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text(AppLocalizations.of(context)!.yesCancel, style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final alerts = ref.watch(alertsProvider);
    // Filter alerts based on status
    final activeAlerts = alerts.where((alert) => alert.status == 'active').toList();
    final ignoredAlerts = alerts.where((alert) => alert.status == 'ignored').toList();
    final cancelledAlerts = alerts.where((alert) => alert.status == 'cancelled').toList();


    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.fireFighterDashboard,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    Color(0xFFFF0007),
                    Color(0xFFFF0068),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter
              )
          ),
        ),
        actions: [
         
        ],
        bottom: TabBar(
          controller: _tabController,
          labelStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          unselectedLabelStyle: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
          labelColor: Color(0xFF0B0A0A),
          unselectedLabelColor: Colors.grey[100],
          indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
                colors: [Color(0xFFEADADB), Color(0xFFFF0068)],
                begin: Alignment.topRight,
                end: Alignment.bottomCenter
            ),
          ),
          indicatorSize: TabBarIndicatorSize.label,
          indicatorPadding: EdgeInsets.symmetric(vertical: 1, horizontal: -7),
          tabs: [
            Tab(text: "${AppLocalizations.of(context)!.active} (${activeAlerts.length})"),
            Tab(text: "${AppLocalizations.of(context)!.ignored} (${ignoredAlerts.length})"),
            Tab(text: "${AppLocalizations.of(context)!.cancelled} (${cancelledAlerts.length})"),
          ],
        ),

      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Color(0xFFFF0007), Color(0xFFFF0068)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter
                ),
              ),
              child: Container(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.local_fire_department, size: 40, color: Colors.red),
                    ),
                    SizedBox(height: 10),
                    Text(AppLocalizations.of(context)!.fireTracker,
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home, color: Colors.red),
              title: Text("Home"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.settings, color: Colors.red),
              title: Text("Setting"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.red),
              title: Text(AppLocalizations.of(context)!.logOut),
              onTap: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen()));
              },
            )
          ],
        ),
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

          // Ignored Tab
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
        onPressed: () async {
          // Clear and let AlertService re-populate
          ref.read(alertsProvider.notifier).clearAlerts();
          // Resubscribe manually (simulate refresh)
          ref.read(alertServiceProvider);
        },

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
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.notifications_off, size: 64, color: Colors.redAccent),
            SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.noAlertFound,
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        ref.read(alertsProvider.notifier).clearAlerts();
        ref.read(alertServiceProvider);
      },

      child: ListView.builder(
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
      ),
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
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              width: 6,
              color: _getStatusColor(alert.status),
            ),
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with status and priority
              _buildHeader(context),

              SizedBox(height: 16),

              // Alert content
              _buildAlertContent(context),

              SizedBox(height: 16),

              // Action buttons
              if (onAccept != null || onIgnore != null || onCancel != null)
                _buildActionButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        // Status icon with color coding
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _getStatusColor(alert.status).withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(
            _getStatusIcon(alert.status),
            color: _getStatusColor(alert.status),
            size: 24,
          ),
        ),

        SizedBox(width: 12),

        // Alert title
        Expanded(
          child: Text(
            alert.title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.grey[800],
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),

        // Status badge
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: _getStatusColor(alert.status).withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            alert.status.toUpperCase(),
            style: TextStyle(
              color: _getStatusColor(alert.status),
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAlertContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Description
        Text(
          alert.description,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[700],
            height: 1.4,
          ),
        ),

        SizedBox(height: 12),

        // Alert details in a grid
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: [
            if (alert.type != null) _buildDetailChip('Type', alert.type!, Icons.category),
            if (alert.severity != null) _buildDetailChip('Severity', alert.severity!, Icons.warning),
            if (alert.buildingName != null) _buildDetailChip('Building', alert.buildingName!, Icons.business),
            if (alert.zone != null) _buildDetailChip('Zone', alert.zone!, Icons.map),
          ],
        ),

        SizedBox(height: 12),

        // Location with map icon
        Row(
          children: [
            Icon(Icons.location_on, size: 18, color: Colors.red),
            SizedBox(width: 6),
            Expanded(
              child: Text(
                '${alert.latitude.toStringAsFixed(4)}, ${alert.longitude.toStringAsFixed(4)}',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ),
          ],
        ),

        SizedBox(height: 8),

        // Time information
        Row(
          children: [
            Icon(Icons.access_time, size: 18, color: Colors.grey),
            SizedBox(width: 6),
            Text(
              '${AppLocalizations.of(context)!.created}: ${_formatTime(alert.createdAt)}',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),

        if (alert.expiresAt != null) ...[
          SizedBox(height: 6),
          Row(
            children: [
              Icon(Icons.timer, size: 18, color: Colors.orange),
              SizedBox(width: 6),
              Text(
                '${AppLocalizations.of(context)!.expired}: ${_formatTime(alert.expiresAt!)}',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
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
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.info, size: 16, color: Colors.grey[700]),
                    SizedBox(width: 6),
                    Text(
                      'Cancellation Reason:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6),
                Text(
                  alert.cancelReason!,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDetailChip(String label, String value, IconData icon) {
    return Chip(
      avatar: Icon(icon, size: 16, color: Colors.blue),
      label: Text('$label: $value', style: TextStyle(fontSize: 12)),
      backgroundColor: Colors.blue[50],
      visualDensity: VisualDensity.compact,
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final buttons = <Widget>[];

    if (onAccept != null) {
      buttons.add(
        Expanded(
          child: ElevatedButton.icon(
            icon: Icon(Icons.check_circle, size: 20),
            onPressed: onAccept,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            label: Text(AppLocalizations.of(context)!.accepted, style: TextStyle(fontSize: 14)),
          ),
        ),
      );
    }

    if (onIgnore != null) {
      if (buttons.isNotEmpty) buttons.add(SizedBox(width: 12));
      buttons.add(
        Expanded(
          child: OutlinedButton.icon(
            icon: Icon(Icons.remove_circle, size: 20, color: Colors.orange),
            onPressed: onIgnore,
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.orange,
              padding: EdgeInsets.symmetric(vertical: 14),
              side: BorderSide(color: Colors.orange, width: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            label: Text(AppLocalizations.of(context)!.ignored, style: TextStyle(fontSize: 14)),
          ),
        ),
      );
    }

    if (onCancel != null) {
      if (buttons.isNotEmpty) buttons.add(SizedBox(width: 12));
      buttons.add(
        Expanded(
          child: OutlinedButton.icon(
            icon: Icon(Icons.cancel, size: 20, color: Colors.red),
            onPressed: onCancel,
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red,
              padding: EdgeInsets.symmetric(vertical: 14),
              side: BorderSide(color: Colors.red, width: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            label: Text(AppLocalizations.of(context)!.cancelled, style: TextStyle(fontSize: 14)),
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
        return Colors.green;
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

