import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_sphere/screens/CreateAlertScreen.dart';
import 'package:smart_sphere/screens/ManageSensorScreen.dart';
import 'package:smart_sphere/screens/ReportIncidentScreen.dart';

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
        title: Text("Customers", style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
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
                      child: const Center(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Create Alert",
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
                      child: const Center(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Report Incident",
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
                      child: const Center(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: 10),
                              Text(
                                "Manage Sensor",
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

}