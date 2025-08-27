
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/app_localizations.dart';

class ManageSensorScreen extends ConsumerStatefulWidget {
  const ManageSensorScreen({super.key});

  @override
  ConsumerState<ManageSensorScreen> createState() => _ManageSensorScreenState();
}

class _ManageSensorScreenState extends ConsumerState<ManageSensorScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.manageSensor, style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              child: Text(AppLocalizations.of(context)!.manageSensor),
            )
          ],


        ),

      ),
    );
  }

}