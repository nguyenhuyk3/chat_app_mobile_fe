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
        border: Border.all(width: 0.08, color: Colors.white),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        controller: controller,
        validator: validator,
        obscureText: obscureText,
        keyboardType: TextInputType.text,
        readOnly: readOnly,
        style: TextStyle(color: Colors.white.withOpacity(0.8)),
        decoration: InputDecoration(
          label: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          hintText: hint,
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
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
