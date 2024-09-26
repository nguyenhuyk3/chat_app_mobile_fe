import 'package:flutter/material.dart';

class CreateNewPasswordScreen extends StatefulWidget {
  const CreateNewPasswordScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return MyCreateNewPasswordScreen();
  }
}

class MyCreateNewPasswordScreen extends State<CreateNewPasswordScreen> {
  bool _obscureText = true;
  bool _obscureTextCF = true;
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
                  'Đặt lại mật khẩu',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 120, left: 20),
                child: Text(
                  'Bạn hãy đặt lại mật khẩu của ban.',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(top: 165, left: 20, right: 20),
                  child: TextFormField(
                    decoration: InputDecoration(
                        hintText: 'Mật khẩu',
                        hintStyle:
                            TextStyle(color: Colors.white.withOpacity(0.8)),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: Colors.grey,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        )),
                    style: const TextStyle(color: Colors.white),
                    obscureText: _obscureText,
                  )),
              Padding(
                  padding: const EdgeInsets.only(top: 240, left: 20, right: 20),
                  child: TextFormField(
                    decoration: InputDecoration(
                        hintText: 'Nhập lại mật khẩu',
                        hintStyle:
                            TextStyle(color: Colors.white.withOpacity(0.8)),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _obscureTextCF = !_obscureTextCF;
                            });
                          },
                          icon: Icon(
                            _obscureTextCF
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: Colors.grey,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        )),
                    style: const TextStyle(color: Colors.white),
                    obscureText: _obscureTextCF,
                  )),
              Padding(
                  padding: const EdgeInsets.only(top: 340, left: 20, right: 20),
                  child: Container(
                    height: 40,
                    width: 380,
                    decoration: BoxDecoration(
                        color: Colors.deepPurpleAccent.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(30)),
                    child: TextButton(
                        onPressed: () {},
                        child: const Text(
                          'ĐỒNG Ý',
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
