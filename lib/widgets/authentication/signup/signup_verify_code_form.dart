import 'dart:async';

import 'package:chat_app_mobile_fe/services/auth_services.dart';
import 'package:chat_app_mobile_fe/services/sendmaill_service.dart';
import 'package:flutter/material.dart';

class SignupVerifyCodeForm extends StatefulWidget {
  final String email; // Thêm biến email

  const SignupVerifyCodeForm({super.key, required this.email});

  @override
  State<SignupVerifyCodeForm> createState() => _SignupVerifyCodeFormState();
}

class _SignupVerifyCodeFormState extends State<SignupVerifyCodeForm> {
  final _verificationCodeController = TextEditingController();
  int _seconds = 60;
  Timer? _timer;
  final SendMailService _mailService = SendMailService();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
  }

  void startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (time) {
      if (_seconds > 0) {
        setState(() {
          _seconds--;
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Form(
        // key: widget.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 100),
              child: Text(
                'Nhập mã để kiểm tra email',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 25),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(),
              child: Text(
                'Nhập mã xác thực.',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: TextFormField(
                controller: _verificationCodeController,
                decoration: InputDecoration(
                  hintText: 'Mã xác thực',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 5, bottom: 15),
              child: Row(
                children: [
                  const Text(
                    'Gửi lại mã sau: ',
                    style: TextStyle(
                      color: Color.fromARGB(255, 240, 248, 90),
                    ),
                  ),
                  _seconds > 0
                      ? Text(
                          '$_seconds giây',
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        )
                      : TextButton(
                          style: ButtonStyle(
                            // Bỏ padding
                            padding: WidgetStateProperty.all<EdgeInsets>(
                                EdgeInsets.zero),
                            // Bỏ kích thước mặc định
                            minimumSize:
                                WidgetStateProperty.all(const Size(0, 0)),
                            // Thu gọn vùng nhấn
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          onPressed: () {
                            setState(() {
                              _seconds = 60; // Reset lại thời gian đếm ngược
                              startTimer(); // Bắt đầu lại Timer
                              _mailService.sendCodeByMail(
                                  context, widget.email);
                            });
                          },
                          child: const Text(
                            "Gửi lại mã",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                ],
              ),
            ),
            Container(
              height: 40,
              width: 380,
              decoration: BoxDecoration(
                  color: Colors.deepPurpleAccent.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(30)),
              child: TextButton(
                onPressed: () {
                  String enteredCode = _verificationCodeController.text.trim();
                  if (enteredCode.isNotEmpty) {
                    AuthServices()
                        .verifyCode(widget.email, enteredCode, context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Vui lòng nhập mã xác thực')),
                    );
                  }
                },
                child: const Text(
                  'TIẾP TỤC',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
