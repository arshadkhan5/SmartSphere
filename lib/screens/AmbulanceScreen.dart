import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../services/FirestoreService.dart';
import 'LoginScreen.dart';

class AmbulanceScreen extends StatefulWidget {
  final String ambulanceId;
  const AmbulanceScreen({required this.ambulanceId, super.key});

  @override
  State<AmbulanceScreen> createState() => _AmbulanceScreenState();
}

class _AmbulanceScreenState extends State<AmbulanceScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _cancelReasonController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Subscribe to firefighter topic
    FirebaseMessaging.instance.subscribeToTopic("ambulance");
  }

  @override
  void dispose() {
    _tabController.dispose();
    _cancelReasonController.dispose();
    super.dispose();
  }

  Future<void> _updateStatus(String docId, String status, {String? reason}) async {
    await FirestoreService.updateAlertStatus(docId, status, reason: reason);
  }

  Future<void> _accept(String alertId, String customerId) async {
    await FirestoreService.acceptAlert(
      alertId: alertId,
      responderId: widget.ambulanceId,
      responderRole: "ambulance",
    );
    // Navigate to detail or map screen here if you want
  }

  void _cancel(String alertId) {
    final reasonController = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.cancelAlert),
        content: TextField(
          controller: reasonController,
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context)!.cancellationReason,
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.no),
          ),
          ElevatedButton(
            onPressed: () async {
              final reason = reasonController.text.trim();
              if (reason.isNotEmpty) {
                await _updateStatus(alertId, "canceled", reason: reason);
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(AppLocalizations.of(context)!.yesCancel),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertList(List<QueryDocumentSnapshot> docs,
      {required bool showAccept, required bool showIgnore, required bool showCancel}) {
    if (docs.isEmpty) {
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

    return ListView.builder(
      itemCount: docs.length,
      itemBuilder: (context, index) {
        final alert = docs[index];
        return AlertCard(
          title: "🚨 Alert: ${alert['type']}",
          description: "Customer: ${alert['customerId']}",
          status: alert['status'],
          onAccept: showAccept ? () => _accept(alert.id, alert['customerId']) : null,
          onIgnore: showIgnore ? () => _updateStatus(alert.id, "ignored") : null,
          onCancel: showCancel ? () => _cancel(alert.id) : null,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirestoreService.getAlertsForRole("ambulance"),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(title: Text("Firefighter")),
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final alerts = snapshot.data!.docs;
        final activeAlerts = alerts.where((a) => a['status'] == "pending").toList();
        final ignoredAlerts = alerts.where((a) => a['status'] == "ignored").toList();
        final canceledAlerts = alerts.where((a) => a['status'] == "canceled").toList();

        return Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.ambulance,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFF0007), Color(0xFFFF0068)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            bottom:
            TabBar(
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
                Tab(text: "${AppLocalizations.of(context)!.cancelled} (${canceledAlerts.length})"),
              ],
            ),

            /* TabBar(
              controller: _tabController,
              tabs: [
                Tab(text: "${AppLocalizations.of(context)!.active} (${activeAlerts.length})"),
                Tab(text: "${AppLocalizations.of(context)!.ignored} (${ignoredAlerts.length})"),
                Tab(text: "${AppLocalizations.of(context)!.cancelled} (${canceledAlerts.length})"),
              ],
            ),*/
          ),
          drawer: Drawer(
            child: ListView(
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Color(0xFFFF0007), Color(0xFFFF0068)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter),
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.local_fire_department, size: 40, color: Colors.red),
                      ),
                      SizedBox(height: 10),
                      Text(
                        AppLocalizations.of(context)!.fireTracker,
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.home, color: Colors.red),
                  title: Text("Home"),
                  onTap: () => Navigator.pop(context),
                ),
                ListTile(
                  leading: Icon(Icons.settings, color: Colors.red),
                  title: Text("Setting"),
                  onTap: () => Navigator.pop(context),
                ),
                ListTile(
                  leading: Icon(Icons.logout, color: Colors.red),
                  title: Text(AppLocalizations.of(context)!.logOut),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => LoginScreen()),
                    );
                  },
                )
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildAlertList(activeAlerts, showAccept: true, showIgnore: true, showCancel: true),
              _buildAlertList(ignoredAlerts, showAccept: false, showIgnore: false, showCancel: false),
              _buildAlertList(canceledAlerts, showAccept: false, showIgnore: false, showCancel: false),
            ],
          ),
        );
      },
    );
  }
}

class AlertCard extends StatelessWidget {
  final String title;
  final String description;
  final String status;
  final VoidCallback? onAccept;
  final VoidCallback? onIgnore;
  final VoidCallback? onCancel;

  const AlertCard({
    super.key,
    required this.title,
    required this.description,
    required this.status,
    this.onAccept,
    this.onIgnore,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(12),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            SizedBox(height: 8),
            Text(description),
            SizedBox(height: 12),
            Row(
              children: [
                if (onAccept != null)
                  ElevatedButton(onPressed: onAccept, child: Text("Accept")),
                if (onIgnore != null)
                  TextButton(onPressed: onIgnore, child: Text("Ignore")),
                if (onCancel != null)
                  OutlinedButton(onPressed: onCancel, child: Text("Cancel")),
              ],
            )
          ],
        ),
      ),
    );
  }
}



/*

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_sphere/l10n/app_localizations.dart';

class AmbulanceScreen  extends ConsumerStatefulWidget {
  const AmbulanceScreen({super.key});

  @override
  ConsumerState<AmbulanceScreen> createState() => _AmbulanceScreenState();
}

class _AmbulanceScreenState extends ConsumerState<AmbulanceScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text(AppLocalizations.of(context)?.ambulance as String, style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFFF0007), // Red
                Color(0xFFFF0068), // Pinkish red
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),

      body: Padding(
        padding:  EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              child: Text(AppLocalizations.of(context)!.ambulance ),
            )
          ],


        ),

      ),
    );
  }

}*/
