import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FireFighterScreen  extends ConsumerStatefulWidget {
  const FireFighterScreen({super.key});

  @override
  ConsumerState<FireFighterScreen> createState() => _FireFighterScreenState();
}

class _FireFighterScreenState extends ConsumerState<FireFighterScreen> {

  static const CameraPosition _kInitialPosition = CameraPosition(
    target: LatLng(24.7136, 46.6753), // Riyadh coordinates
    zoom: 12,
  );

  final Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text("Fire Fighter and Tracker", style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
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

      body: SafeArea(
        child: GoogleMap(initialCameraPosition:_kInitialPosition ,
          mapType:MapType.normal,
        
          onMapCreated: (GoogleMapController controller){
            _controller.complete(controller);
          },
        compassEnabled: false,),
      )





    );
  }

}