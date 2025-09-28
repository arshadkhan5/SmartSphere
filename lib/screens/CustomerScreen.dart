import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../services/FirestoreService.dart';
import 'CreateAlertScreen.dart';
import 'ManageSensorScreen.dart';
import 'ReportIncidentScreen.dart';

import '../l10n/app_localizations.dart';
import 'LoginScreen.dart';

class CustomerScreen extends ConsumerStatefulWidget {
  final String customerId;
  final List<String> stopics;
  final List<String> ptopics;

  const CustomerScreen({super.key, required this.customerId , required this.ptopics,required this.stopics});

  @override
  ConsumerState<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends ConsumerState<CustomerScreen> {
  bool _sharing = false;

  @override
  void initState() {
    super.initState();
    // Subscribe to customer-specific topic
    _subscribeFromTopics();

   // FirebaseMessaging.instance.subscribeToTopic("user_${widget.customerId}");
  }

  void _subscribeFromTopics() {
    widget.stopics.forEach((topic) {
      FirebaseMessaging.instance.subscribeToTopic(topic);
      print('subscribed from topic: $topic');
    });

  }

  // Firestore Alerts
  void _createFireAlert() {
    FirestoreService.createAlert(
      type: "Fire",
      targetRole: "firefighter",
      customerId: widget.customerId,
    );
  }

  void _createAccidentAlert() {
    FirestoreService.createAlert(
      type: "Accident",
      targetRole: "ambulance",
      customerId: widget.customerId,
    );
  }

  // Start Sharing Location
 /* void _startSharing() async {
    await LocationService.startSharingLocation(
      widget.customerId,
      "customer",
      name: "customer",
    );
    setState(() => _sharing = true);
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.customers,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFF0007), Color(0xFFFF0068)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage("assets/splash_icon.png"),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    AppLocalizations.of(context)!.customers,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Home"),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Setting"),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: Text(AppLocalizations.of(context)!.logOut),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              },
            )
          ],
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Create Alert + Report Incident
            Row(
              children: [
                Expanded(
                  child: _buildCard(
                    context,
                    title: AppLocalizations.of(context)!.createAlert,
                    icon: Icons.add_alert,
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (_)=> CreateAlertScreen(customerId: widget.customerId,)));
                    }, // Fire alert
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: _buildCard(
                    context,
                    title: AppLocalizations.of(context)!.reportIncident,
                    icon: Icons.report_outlined,
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (_)=> ReportIncidentScreen()));
                    }, // Accident alert
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Manage Sensor
            Row(
              children: [
                Expanded(
                  child: _buildCard(
                    context,
                    title: AppLocalizations.of(context)!.manageSensor,
                    icon: Icons.sensors_outlined,
                    height: 100,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ManageSensorScreen()),
                      );
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Location Sharing
            Row(
              children: [
                Expanded(
                  child: _buildCard(
                    context,
                    title: "Track Location",
                    icon: Icons.map,
                    height: 100,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ManageSensorScreen()),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Reusable card widget
  Widget _buildCard(BuildContext context,
      {required String title,
        required IconData icon,
        required VoidCallback? onTap,
        double height = 200}) {
    return InkWell(
      borderRadius: BorderRadius.circular(25),
      onTap: onTap,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFF0007), Color(0xFFFF0068)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16)),
              const SizedBox(height: 12),
              Icon(icon, size: 40, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}




/*
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_sphere/screens/CreateAlertScreen.dart';
import 'package:smart_sphere/screens/ManageSensorScreen.dart';
import 'package:smart_sphere/screens/ReportIncidentScreen.dart';

import '../l10n/app_localizations.dart';
import 'LoginScreen.dart';

class CustomerScreen extends ConsumerStatefulWidget {
  const CustomerScreen({super.key});

  @override
  ConsumerState<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends ConsumerState<CustomerScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.customers, style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
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
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Container(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage("assets/splash_icon.png"),
                    ),
                    SizedBox(height: 20,),
                    Text(AppLocalizations.of(context)!.customers , style: TextStyle(fontWeight: FontWeight.bold),),

                  ],
                ),
              ),
            ),
            ListTile(
              leading: Icon ( Icons.home),
              title: Text("Home"),
              onTap: (){
                Navigator.pop(context);
              },

            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("Setting"),
              onTap: (){
                Navigator.pop(context);

              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text(AppLocalizations.of(context)!.logOut),
              onTap: (){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> LoginScreen()));
              },
            )
          ],
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(25), // Ensures ripple effect respects rounded corners
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_)=> CreateAlertScreen()));
                    },
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFFFF0007), // Red
                            Color(0xFFFF0068), // Pinkish red
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(25), // Rounded corners
                      ),
                      child:  Center(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.createAlert,
                                style: TextStyle(color: Colors.white , fontWeight: FontWeight.bold , fontSize: 16),
                              ),
                              SizedBox(height: 20),
                              Icon(Icons.add_alert , size: 40, color: Colors.white,)

                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 20,),

                Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(25), // Ensures ripple effect respects rounded corners
                    onTap: () {
                     Navigator.push(context, MaterialPageRoute(builder: (_)=> ReportIncidentScreen()));
                    },
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFFFF0007), // Red
                            Color(0xFFFF0068), // Pinkish red
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(25), // Rounded corners
                      ),
                      child:  Center(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.reportIncident,
                                style: TextStyle(color: Colors.white , fontWeight: FontWeight.bold , fontSize: 16),
                              ),
                              SizedBox(height: 20),
                              Icon(Icons.report_outlined , size: 40, color: Colors.white,)

                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),

            SizedBox(height: 20,),

            Row(
              children: [
                Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(25), // Ensures ripple effect respects rounded corners
                    onTap: () {
                   Navigator.push(context, MaterialPageRoute(builder: (_)=> ManageSensorScreen()));

                    },
                    child: Container(
                      width: 200,
                      height: 100,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFFFF0007), // Red
                            Color(0xFFFF0068), // Pinkish red
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(25), // Rounded corners
                      ),
                      child:  Center(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: 10),
                              Text(
                                AppLocalizations.of(context)!.manageSensor,
                                style: TextStyle(color: Colors.white , fontWeight: FontWeight.bold , fontSize: 16),
                              ),
                              SizedBox(height: 8),
                              Icon(Icons.sensors_outlined , size: 40, color: Colors.white,)

                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),



              ],
            ),


          ],


        ),

      ),
    );
  }

}*/
