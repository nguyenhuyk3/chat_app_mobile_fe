// ignore_for_file: use_build_context_synchronously

import 'dart:math';

import 'package:chat_app_mobile_fe/screens/authentication/signup/signup_verify_code_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

class SendMailService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String generateVerificationCode() {
    const length = 6;
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random random = Random();
    return String.fromCharCodes(Iterable.generate(
        length, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
  }

  Future<void> sendCodeByMail(BuildContext context, String email) async {
    try {
      // Thử tạo tài khoản để kiểm tra email đã tồn tại chưa
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: 'temporary_password', // Đặt một mật khẩu tạm thời
      );

      // Nếu thành công tạo tài khoản, xóa ngay lập tức vì đây chỉ là kiểm tra
      await userCredential.user?.delete();

      // Cấu hình máy chủ SMTP
      String verifiCode = generateVerificationCode();
      String username = 'huynhminhcuong.270403@gmail.com';
      String apppassword = 'uekf ygou ncaj iuus';
      final smtpServer = gmail(username, apppassword);

      // Tính toán thời gian hết hạn (hiện tại + 3 phút)
      DateTime expirationTime = DateTime.now().add(const Duration(minutes: 3));
      final message = Message()
        ..from = Address(username, 'PingMe')
        ..recipients.add(email)
        ..subject = 'Mã xác thực của bạn'
        ..html = """
        <html>
          <body style="font-family: Arial, sans-serif; padding: 20px; background-color: #f4f4f4;">
            <div style="max-width: 600px; margin: auto; padding: 20px; border-radius: 8px; background-color: #007BFF; box-shadow: 0 4px 8px rgba(0,0,0,0.1);">
              <h2 style="color: #ffffff;">Xin chào!</h2>
              <p style="font-size: 16px; color: #ffffff;">Mã xác thực của bạn là:</p>
              <div style="
                font-size: 24px;
                font-weight: bold;
                color: #ffffff;
                background-color: #333;
                padding: 15px;
                border-radius: 5px;
                text-align: center;
                margin: 10px 0;
              ">
                $verifiCode
              </div>
              <p style="font-size: 16px; color: #ffffff; margin-top: 20px;">
                Vui lòng nhập mã này để tiếp tục xác thực tài khoản của bạn.
              </p>
              <p style="font-size: 14px; color: #e0e0e0;">Nếu bạn không yêu cầu mã này, vui lòng bỏ qua email này.</p>
            </div>
          </body>
        </html>
      """;

      try {
        await send(message, smtpServer);
        await FirebaseFirestore.instance
            .collection('verificationSignupCodes')
            .doc(email)
            .set({
          'verificationCode': verifiCode,
          'expirationTime': expirationTime,
          'createdAt': DateTime.now(),
        }, SetOptions(merge: true));

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã gửi mã xác thực về mail của bạn!')),
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SignupVerifyCodeScreen(email: email),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi gửi email: $e')),
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = '';
      if (e.code == 'email-already-in-use') {
        errorMessage = 'Email đã được sử dụng!';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'Email không hợp lệ!';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }
}
