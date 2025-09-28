import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_sphere/screens/SplashScreen.dart';
import 'package:smart_sphere/services/LocalizationService.dart';
import 'package:smart_sphere/services/NatService.dart';
import 'package:smart_sphere/services/notificationService.dart';
import 'l10n/app_localizations.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final locale = await LocalizationService.getLocale();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

 // _initNats();

  // Initialize notification service
  final notificationService = NotificationService();
  await notificationService.initialize(onNotificationTap: (payload) {
    // Handle notification tap in foreground
    print('Notification tapped with payload: $payload');
  });
  runApp(ProviderScope(child: MyApp(locale: locale)));
}

void _initNats() async {
  try {
    await NatsService.connect();
    print(" NATS Connected:");

  } catch (e) {
    print("Failed to initialize NATS: $e");

  }
}

class MyApp extends StatefulWidget {
  final Locale locale;

  const MyApp({super.key, required this.locale});

  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  @override
  void initState() {
    super.initState();
    _locale = widget.locale;
  }

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      locale: _locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
      ],
      onGenerateTitle: (context) =>
      AppLocalizations.of(context)?.appTitle ?? 'Smart Sphere',
      home: const SplashScreen(),
    );
  }
}
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Background message: ${message.messageId}');
}
