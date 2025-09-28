
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_sphere/screens/AdminScreen.dart';
import 'package:smart_sphere/screens/AmbulanceScreen.dart';
import 'package:smart_sphere/screens/CustomerScreen.dart';
import 'package:smart_sphere/screens/DashboardScreen.dart';
import 'package:smart_sphere/screens/FireFighterDashboard.dart';
import 'package:smart_sphere/screens/FireFighterScreen.dart';
import 'package:smart_sphere/screens/OperationTeamScreen.dart';
import 'package:smart_sphere/screens/RegisterScreen.dart';

import '../l10n/app_localizations.dart';
import '../main.dart';
import '../services/LocalizationService.dart';

class LoginScreen extends ConsumerStatefulWidget {
 /* final String fromScreen ;*/

   const LoginScreen(   {super.key ,/*required this.fromScreen*/});

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
    bool _obscurePassword = true; // Add this line

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(AppLocalizations.of(context)!.logIn ,
                style: TextStyle(color: Colors.white , fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
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
        actions: [

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(onPressed: (){
              _showLanguageDialog(context);
            }, icon:Icon(Icons.language , color: Colors.white,) ),
          )
        ],

      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: formKey,
                child: Column(
                  children: [
                    // Logo at the top
                    const SizedBox(height: 20),
                    Container(
                      alignment: Alignment.center,
                      child: Image.asset(
                        'assets/splash_icon.png', // Replace with your actual logo path
                        height: 150, // Adjust height as needed
                        width: 150, // Adjust width as needed
                      ),
                    ),
                    const SizedBox(height: 40),
                
                    // Regular login fields
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: usernameController,
                            decoration: InputDecoration(
                              labelText: AppLocalizations.of(context)!.userName,
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
                                return AppLocalizations.of(context)!.userNameRequired;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          StatefulBuilder(
                            builder: (context, setState) {
                              return TextFormField(
                                controller: passwordController,
                                decoration: InputDecoration(
                                  labelText: AppLocalizations.of(context)!.password,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                    borderSide: const BorderSide(color: Color(0xFFFF0007), width: 2.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                    borderSide: const BorderSide(color: Color(0xFFFF0007), width: 2.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                    borderSide: const BorderSide(color: Color(0xFFFF0007), width: 2.0),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                      color: Color(0xFFFF0007),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                                  ),
                                ),
                                obscureText: _obscurePassword,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return AppLocalizations.of(context)!.passwordRequired;
                                  }
                                  return null;
                                },
                              );
                            },
                          ),
                          const SizedBox(height: 30),
                
                          InkWell(
                            borderRadius: BorderRadius.circular(10), // Ensures ripple effect respects rounded corners
                            onTap: () {
                              if (formKey.currentState!.validate()) {
                                String username = usernameController.text.trim().toLowerCase();
                                String password = passwordController.text.trim();


                                if (username == 'customer' && password == '1234') {
                                  List<String> _subTopics = ["firefighter1", "ambulance1"];
                                  List<String> _publishTopics = ["firefighter1", "ambulance1"];
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => CustomerScreen(customerId: username, stopics: _subTopics, ptopics: _publishTopics,)));
                                }
                                else if (username == 'firefighter' && password == '1234') {

                                  List<String> _publishTopics = [ "firefighter1"];
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => FireFighterDashboard(firefighterId:username ,)));
                                }
                                else if (username == 'ambulance' && password == '1234') {

                                  List<String> _publishTopics = [ "ambulance1"];
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => AmbulanceScreen(ambulanceId: username,)));
                                }
                                else if (username == 'admin' && password == '1234') {

                                  List<String> _subTopics = ["firefighter1", "ambulance1"];
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => AdminScreen()));
                                }
                                else if (username == 'operation' && password == '1234') {

                                  List<String> _subTopics = ["firefighter1", "ambulance1"];
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => OperationTeamScreen()));
                                }
                                else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Invalid username or password')),
                                  );
                                }
                              }
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
                              child:  Center(
                                child: Text(
                                  AppLocalizations.of(context)!.logIn,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20,),
                        ],
                      ),
                    ),
                
                
                   /* TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => RegisterScreen()));
                      },
                      child: Text('Create Account',
                        style: const TextStyle(color: Colors.blue),
                      ),
                    ),*/
                  ],
                ),
            ),
          ),
        ),
      ),
    );
  }


  void _showLanguageDialog(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localizations?.changeLanguage ?? "Change Language"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('English'),
              onTap: () {
                _changeLanguage(context, 'en');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('العربية'),
              onTap: () {
                _changeLanguage(context, 'ar');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _changeLanguage(BuildContext context, String languageCode) async {
    final newLocale = await LocalizationService.setLocale(languageCode);
    MyApp.of(context)?.setLocale(newLocale);
  }



}

