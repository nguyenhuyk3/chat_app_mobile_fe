import 'package:flutter/material.dart';

class LoginTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final bool obscureText;
  final String? Function(String?)? validator;
  final VoidCallback?
      toggleObscureText; // Callback để toggle trạng thái hiển thị mật khẩu

  const LoginTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    this.obscureText = false,
    this.validator,
    this.toggleObscureText, // Thêm toggleObscureText vào constructor
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE6EBF1),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(4, 4),
            blurRadius: 15,
          ),
          BoxShadow(
            color: Colors.white,
            offset: Offset(-4, -4),
            blurRadius: 15,
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        validator: validator,
        obscureText: obscureText,
        decoration: InputDecoration(
          label: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 18,
            ),
          ),
          hintText: hint,
          hintStyle: const TextStyle(fontWeight: FontWeight.w400),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          suffixIcon: toggleObscureText !=
                  null // Nếu toggleObscureText không null, hiển thị IconButton
              ? IconButton(
                  icon: Icon(
                      obscureText ? Icons.visibility_off : Icons.visibility),
                  onPressed:
                      toggleObscureText, // Khi nhấn vào, gọi toggleObscureText
                )
              : null,
        ),
      ),
    );
  }
}
