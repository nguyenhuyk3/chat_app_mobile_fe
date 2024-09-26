import 'package:chat_app_mobile_fe/home.dart';
import 'package:chat_app_mobile_fe/screens/Login_Signup/login_screen.dart';
import 'package:chat_app_mobile_fe/screens/chat_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/home',
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) => ChatHomeScreen(),
      },
    );
  }
}
