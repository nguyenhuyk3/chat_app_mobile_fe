import 'package:flutter/material.dart';

class EnterEmailForm extends StatefulWidget {
  final TextEditingController emailController;
  final GlobalKey<FormState> formKey;
  final Function(String email) onSubmit; // Thêm onSubmit vào constructor

  const EnterEmailForm({
    super.key,
    required this.onSubmit,
    required this.emailController,
    required this.formKey,
  });
  @override
  // ignore: library_private_types_in_public_api
  _EnterEmailFormState createState() => _EnterEmailFormState();
}

class _EnterEmailFormState extends State<EnterEmailForm> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Form(
        key: widget.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 100, left: 20),
              child: Text(
                'Nhập email để bắt đầu đăng ký',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 25),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 5, left: 20),
              child: Text(
                'Nhập địa chỉ email của bạn.',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email không được để trống';
                  }
                  // Kiểm tra định dạng email nếu cần
                  return null; // Nếu không có lỗi
                },
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
              padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
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
