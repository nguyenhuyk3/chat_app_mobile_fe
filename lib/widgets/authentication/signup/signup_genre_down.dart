import 'package:flutter/material.dart';

class GenderDropdown extends StatefulWidget {
  final ValueChanged<String?> onChanged; // Thêm callback để truyền giá trị
  const GenderDropdown({super.key, required this.onChanged});

  @override
  State<GenderDropdown> createState() => _GenderDropdownState();
}

class _GenderDropdownState extends State<GenderDropdown> {
  String? selectedGender;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'Giới tính',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: const Color(0xFFE6EBF1),
      ),
      value: selectedGender,
      onChanged: (String? newValue) {
        setState(() {
          selectedGender = newValue;
        });

        widget.onChanged(newValue);
      },
      items:
          <String>['Nam', 'Nữ'].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
