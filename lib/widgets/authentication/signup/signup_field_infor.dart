import 'package:chat_app_mobile_fe/screens/authentication/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:chat_app_mobile_fe/widgets/authentication/signup/signup_button.dart';
import 'package:chat_app_mobile_fe/widgets/authentication/signup/signup_date_field.dart';
import 'package:chat_app_mobile_fe/widgets/authentication/signup/signup_genre_down.dart';
import 'package:chat_app_mobile_fe/widgets/authentication/signup/signup_textfield.dart';
import 'package:chat_app_mobile_fe/services/auth_services.dart';

class SignupFieldInfor extends StatefulWidget {
  final String email;
  const SignupFieldInfor({super.key, required this.email});

  @override
  State<SignupFieldInfor> createState() => _SignupFieldInforState();
}

class _SignupFieldInforState extends State<SignupFieldInfor> {
  final _controllerFullname = TextEditingController();
  final _controllerBrithday = TextEditingController();
  String? selectedGender;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xE80A2405),
            Color(0xE8181819),
            Color(0xE80E1332),
          ],
        ),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 18, right: 18),
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                SignupTextField(
                  controller: _controllerFullname,
                  label: 'Họ và tên',
                  hint: 'Nhập họ và tên',
                  obscureText: false,
                  validator: null,
                ),
                const SizedBox(height: 20),
                SignupDateField(controllerDate: _controllerBrithday),
                const SizedBox(height: 20),
                GenderDropdown(
                  onChanged: (gender) {
                    setState(() {
                      selectedGender = gender;
                    });
                  },
                ),
                const SizedBox(height: 20),
                SignupButton(
                  onPressed: () async {
                    await AuthServices().updateUserInfo(
                      widget.email,
                      _controllerFullname.text,
                      _controllerBrithday.text,
                      selectedGender ??
                          "Nam", // Mặc định là "Nam" nếu không chọn
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Cập nhật thông tin thành công!')),
                    );
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
