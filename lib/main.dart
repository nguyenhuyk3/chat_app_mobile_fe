import 'package:chat_app_mobile_fe/screens/authentication/login/login_screen.dart';
import 'package:chat_app_mobile_fe/screens/chat/chat_home_screen.dart';
import 'package:chat_app_mobile_fe/services/fcm_service.services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  late FCMService _fcmService;

  @override
  void initState() {
    super.initState();

    _fcmService = FCMService();
    _fcmService.setupFCM(_navigatorKey);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      home: const LoginScreen(),
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) => const ChatHomeScreen(),
        '/login': (BuildContext context) => const LoginScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
