import 'package:flutter/material.dart';

class ForgotPasswordForm extends StatefulWidget {
  final TextEditingController emailController;
  final GlobalKey<FormState> formKey;
  final Function(String email) onSubmit;

  const ForgotPasswordForm({
    Key? key,
    required this.emailController,
    required this.formKey,
    required this.onSubmit,
  }) : super(key: key);

  @override
  _ForgotPasswordFormState createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Form(
        key: widget.formKey,
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
                controller: widget.emailController,
                decoration: InputDecoration(
                  hintText: 'Email',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 240, left: 20, right: 20),
              child: Container(
                height: 40,
                width: 380,
                decoration: BoxDecoration(
                    color: Colors.deepPurpleAccent.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(30)),
                child: TextButton(
                  onPressed: () =>
                      widget.onSubmit(widget.emailController.text.trim()),
                  child: const Text(
                    'TIẾP TỤC',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
