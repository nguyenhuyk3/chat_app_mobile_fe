import 'package:chat_app_mobile_fe/home.dart';
import 'package:chat_app_mobile_fe/screens/authentication/login/login_screen.dart';
import 'package:chat_app_mobile_fe/screens/setting/setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  // SharedPreferences prefs = await SharedPreferences.getInstance();
  // bool isLogin = prefs.getBool('isLogin') ?? false;
  runApp(MaterialApp(
    // home: isLogin ? Home() : LoginScreen(),
    home: const MySettingScreen(),
    debugShowCheckedModeBanner: false,
  ));
}

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       initialRoute: '/home',
//       routes: <String, WidgetBuilder>{
//         '/home': (BuildContext context) => ChatHomeScreen(),
//       },
//     );
//   }
// }
