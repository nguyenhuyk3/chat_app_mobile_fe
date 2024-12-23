import 'package:flutter/material.dart';

class SignupTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final bool obscureText;
  final String? Function(String?)? validator;
  final VoidCallback? toggleObscureText;
  final bool readOnly;

  const SignupTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.obscureText,
    required this.validator,
    this.toggleObscureText,
    this.readOnly = false,
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
        keyboardType: TextInputType.text,
        readOnly: readOnly,
        style: TextStyle(color: Colors.black.withOpacity(0.8)),
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
          hintStyle: TextStyle(color: Colors.black.withOpacity(0.8)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          suffixIcon: toggleObscureText != null
              ? IconButton(
                  icon: Icon(
                      obscureText ? Icons.visibility_off : Icons.visibility),
                  onPressed: toggleObscureText,
                )
              : null,
        ),
      ),
    );
  }
}