import 'package:chat_app_mobile_fe/screens/Login_Signup/login_screen.dart';
import 'package:chat_app_mobile_fe/screens/chat_home_screen.dart';
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
    bool? loggedIn =
        prefs.getBool('isLogin'); // Kiểm tra xem người dùng đã đăng nhập chưa
    setState(() {
      _isLoggedIn =
          loggedIn ?? false; // Nếu chưa có giá trị thì mặc định là false
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: _isLoggedIn ? ChatHomeScreen() : LoginScreen(),
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) => ChatHomeScreen(),
        '/login': (BuildContext context) => LoginScreen(),
      },
    );
  }
}
