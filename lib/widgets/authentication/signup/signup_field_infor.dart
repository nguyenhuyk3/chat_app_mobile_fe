import 'package:chat_app_mobile_fe/screens/authentication/login/login_screen.dart';
import 'package:chat_app_mobile_fe/services/auth_services.dart';
import 'package:chat_app_mobile_fe/widgets/authentication/signup/signup_button.dart';
import 'package:chat_app_mobile_fe/widgets/authentication/signup/signup_date_field.dart';
import 'package:chat_app_mobile_fe/widgets/authentication/signup/signup_genre_down.dart';
import 'package:chat_app_mobile_fe/widgets/authentication/signup/signup_textfield.dart';
import 'package:flutter/material.dart';

class SignupFieldInfor extends StatefulWidget {
  final String eamil;
  const SignupFieldInfor({super.key, required this.eamil});

  @override
  State<SignupFieldInfor> createState() => _SignupFieldInforState();
}

class _SignupFieldInforState extends State<SignupFieldInfor> {
  final _controllerFullname = TextEditingController();
  final _controllerBirthdate = TextEditingController();
  String? selectedGender;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 50, left: 18, right: 18),
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 20,
                ),
                SignupTextField(
                  controller: _controllerFullname,
                  label: 'Họ và tên',
                  hint: 'Nhập họ và tên',
                  obscureText: false,
                  validator: null,
                ),
                const SizedBox(
                  height: 20,
                ),
                SignupDateField(
                  controller: _controllerBirthdate,
                ),
                const SizedBox(
                  height: 20,
                ),
                GenderDropdown(
                  onChanged: (gender) {
                    setState(() {
                      selectedGender = gender; // Nhận giá trị giới tính
                    });
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                SignupButton(
                  onPressed: () async {
                    // Gọi hàm updateUserInfo
                    await AuthServices().updateUserInfo(
                      widget.eamil,
                      _controllerFullname.text,
                      _controllerBirthdate.text,
                      selectedGender ??
                          "Nam", // Mặc định là "Nam" nếu không có giá trị
                    );
                    // Thông báo cho người dùng
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Cập nhật thông tin thành công!')),
                    );

                    // Điều hướng về màn hình khác nếu cần
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
