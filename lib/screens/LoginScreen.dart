
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_sphere/screens/AdminScreen.dart';
import 'package:smart_sphere/screens/AmbulanceScreen.dart';
import 'package:smart_sphere/screens/CustomerScreen.dart';
import 'package:smart_sphere/screens/DashboardScreen.dart';
import 'package:smart_sphere/screens/FireFighterScreen.dart';
import 'package:smart_sphere/screens/OperationTeamScreen.dart';
import 'package:smart_sphere/screens/RegisterScreen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  final String fromScreen ;

   const LoginScreen(   {super.key ,required this.fromScreen});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final usernameController = TextEditingController();
    final passwordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: Text("Login  ${widget.fromScreen}" ,style: TextStyle(color: Colors.white , fontWeight: FontWeight.bold),),
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
        child: Form(
          key: formKey,
          child: Column(
            children: [
              const SizedBox(height: 10),

              const SizedBox(height: 20),

                // Regular login fields
                TextFormField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    labelText:"User Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: const BorderSide(color: Color(0xFFFF0007), width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: const BorderSide(color: Color(0xFFFF0007), width: 2.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: const BorderSide(color: Color(0xFFFF0007), width: 2.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "User name Required";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: const BorderSide(color:Color(0xFFFF0007), width: 2.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: const BorderSide(color: Color(0xFFFF0007), width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: const BorderSide(color: Color(0xFFFF0007), width: 2.0),
                    ),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Password Required";
                    }
                    return null;
                  },
                ),


              const SizedBox(height: 30),

              InkWell(
                borderRadius: BorderRadius.circular(25), // Ensures ripple effect respects rounded corners
                onTap: () {
                  switch (widget.fromScreen){
                    case 'Operation Team' : Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => OperationTeamScreen()));
                    case 'Customer' : Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => CustomerScreen()));
                    case 'Fire Tracker' : Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => FireFighterScreen()));
                    case 'Ambulance' : Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => AmbulanceScreen()));
                    case 'Admin' : Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => AdminScreen()));

                  }


                 // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => DashboardScreen()));
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
                      "Login",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20,),

              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => RegisterScreen()));
                },
                child: Text('Create Account',
                  style: const TextStyle(color: Colors.blue),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }





}

