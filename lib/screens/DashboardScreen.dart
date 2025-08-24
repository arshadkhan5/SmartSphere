import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_sphere/screens/LoginScreen.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text('Dashboard', style: TextStyle(color: Colors.white)),
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
        elevation: 0, // Remove shadow if needed
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
                    // Navigator.push(context, MaterialPageRoute(builder: (_)=> LoginScreen(fromScreen: "Operation Team")));

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
                     child: const Center(
                       child: Center(
                         child: Column(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                             Text(
                               "Operation Team",
                               style: TextStyle(color: Colors.white , fontWeight: FontWeight.bold , fontSize: 16),
                             ),
                             SizedBox(height: 10),
                             Icon(Icons.people_alt_sharp , size: 40, color: Colors.white,)

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
                 //  Navigator.push(context, MaterialPageRoute(builder: (_)=>  LoginScreen(fromScreen: "Customer")));
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
                     child: const Center(
                       child: Center(
                         child: Column(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                             Text(
                               "Customer",
                               style: TextStyle(color: Colors.white , fontWeight: FontWeight.bold , fontSize: 16),
                             ),
                             SizedBox(height: 10),
                             Icon(Icons.group , size: 40, color: Colors.white,)

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
                   //  Navigator.push(context, MaterialPageRoute(builder: (_)=>  LoginScreen(fromScreen: "Fire Tracker")));

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

                     child: const Center(
                       child: Center(
                         child: Column(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                             Text(
                               "Fire Tracker",
                               style: TextStyle(color: Colors.white , fontWeight: FontWeight.bold , fontSize: 16),
                             ),
                             SizedBox(height: 10),
                             Icon(Icons.fireplace , size: 40, color: Colors.white,)

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
                     //Navigator.push(context, MaterialPageRoute(builder: (_)=> LoginScreen(fromScreen: "Ambulance")));
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
                     child: const Center(
                       child: Center(
                         child: Column(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                             Text(
                               "Ambulance",
                               style: TextStyle(color: Colors.white , fontWeight: FontWeight.bold , fontSize: 16),
                             ),
                             SizedBox(height: 10),
                             Icon(Icons.medical_services , size: 40, color: Colors.white,)

                           ],
                         ),
                       ),
                     ),
                   ),
                 ),
               )



             ],
           ),

          SizedBox(height: 50,),

          InkWell(
               borderRadius: BorderRadius.circular(25), // Ensures ripple effect respects rounded corners
               onTap: () {
                 //Navigator.push(context, MaterialPageRoute(builder: (_)=> LoginScreen(fromScreen: "Admin")));

               },
               child: Container(
                 width: 300,
                 height: 80,
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
                 child: const Center(
                   child: Center(
                     child: Row(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         Text(
                           "Admin",
                           style: TextStyle(color: Colors.white , fontWeight: FontWeight.bold , fontSize: 18),
                         ),
                         SizedBox(width: 30),
                         Icon(Icons.person , size:20, color: Colors.white,)

                       ],
                     ),
                   ),
                 ),
               ),
             ),

         ],


        ),

      ),
    );
  }

}

