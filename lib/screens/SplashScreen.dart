
import 'package:flutter/material.dart';
import 'package:smart_sphere/screens/LoginScreen.dart';

import '../l10n/app_localizations.dart';
import '../main.dart';
import '../services/LocalizationService.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToLogin();
  }



  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      body:Center(
        child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              flex: 3,
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.4,
                  maxWidth: MediaQuery.of(context).size.width * 0.8,
                ),
                child: const Image(
                  image: AssetImage('assets/splash_icon.png'),
                  fit: BoxFit.contain,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // App Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                localizations.appTitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                  letterSpacing: 1,
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Welcome message
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                localizations.welcomeMessage,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Colors.black54,
                  height: 1.5,
                ),
              ),
            ),
            SizedBox(height: 50,),
            CircularProgressIndicator(backgroundColor: Colors.redAccent,
              strokeWidth: 10,color: Colors.blueAccent,)
          ],
        ),
      ),
    );
  }

  void _navigateToLogin () async {
    await Future.delayed( const Duration(seconds: 5));
    if(mounted){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> LoginScreen()));
    }

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
              title: Text(localizations?.english ?? 'English'),
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
