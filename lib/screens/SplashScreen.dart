import 'package:flutter/material.dart';
import 'package:smart_sphere/screens/DashboardScreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(

        child: Center(
          child: Column(
            mainAxisAlignment:MainAxisAlignment.center,
            children: [

              const Padding(
                padding: EdgeInsets.all(5), // Adjust right padding as needed
                child: Image(
                  image: AssetImage('assets/splash_icon.png'),
                  width: 600,
                  height: 500,
                ),
              ),
              const SizedBox(height:  20,),
              const Text("Smart Sphere" , style:TextStyle( fontSize: 20 ,color:  Colors.blue , fontWeight: FontWeight.bold) ,),
              const SizedBox(height: 90,),
              // lets go Button
              InkWell(
                borderRadius: BorderRadius.circular(25), // Ensures ripple effect respects rounded corners
                onTap: () {
                 Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => DashboardScreen()));
                },
                child: Container(
                  width: 200,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFFFF0007), // Red
                        Color(0xFFFF0068), // Pinkish red
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(25), // Rounded corners
                  ),
                  child: const Center(
                    child: Text(
                      "Lets go",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              )



            ],
          ),
        ), // Your app logo
      ),
    );
  }

}