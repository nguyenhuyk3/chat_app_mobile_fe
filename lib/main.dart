import 'package:chat_app_mobile_fe/screens/authentication/login/login_screen.dart';
import 'package:chat_app_mobile_fe/screens/chat/chat_home_screen.dart';
import 'package:chat_app_mobile_fe/screens/setting/setting_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();

    _checkLoginStatus();
  }

  // Kiểm tra trạng thái đăng nhập
  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Kiểm tra xem người dùng đã đăng nhập chưa
    bool? loggedIn = prefs.getBool('isLoggedIn');
    setState(() {
      // Nếu chưa có giá trị thì mặc định là false
      _isLoggedIn = loggedIn ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const LoginScreen(),
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) => const ChatHomeScreen(),
        '/login': (BuildContext context) => const LoginScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
