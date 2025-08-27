
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

}