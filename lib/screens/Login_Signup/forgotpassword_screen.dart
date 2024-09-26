import 'package:flutter/material.dart';

import 'newpassword_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return MyForgotPasswordScreen();
  }
}

class MyForgotPasswordScreen extends State<ForgotPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
          Color(0xE80A2405),
          Color(0xE8181819),
          Color(0xE80E1332),
        ])),
        child: Padding(
          padding: const EdgeInsets.only(top: 100),
          child: Stack(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 80, left: 20),
                child: Text(
                  'Quên mật khẩu',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 120, left: 20),
                child: Text(
                  'Nhập địa chỉ email của bạn.',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(top: 165, left: 20, right: 20),
                  child: TextFormField(
                    decoration: InputDecoration(
                        hintText: 'Email',
                        hintStyle:
                            TextStyle(color: Colors.white.withOpacity(0.8)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        )),
                    style: const TextStyle(color: Colors.white),
                  )),
              Padding(
                  padding: const EdgeInsets.only(top: 240, left: 20, right: 20),
                  child: Container(
                    height: 40,
                    width: 380,
                    decoration: BoxDecoration(
                        color: Colors.deepPurpleAccent.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(30)),
                    child: TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      CreateNewPasswordScreen()));
                        },
                        child: const Text(
                          'TIẾP TỤC',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white),
                        )),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
