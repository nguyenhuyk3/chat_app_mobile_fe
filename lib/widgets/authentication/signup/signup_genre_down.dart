import 'package:flutter/material.dart';

class GenderDropdown extends StatefulWidget {
  final ValueChanged<String?> onChanged; // Callback để truyền giá trị
  const GenderDropdown({super.key, required this.onChanged});

  @override
  State<GenderDropdown> createState() => _GenderDropdownState();
}

class _GenderDropdownState extends State<GenderDropdown> {
  String? selectedGender;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 0.08, color: Colors.white),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonFormField<String>(
        style: const TextStyle(color: Colors.white),
        decoration: const InputDecoration(
          labelText: 'Giới tính',
          labelStyle: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 18,
          ),
          border: OutlineInputBorder(borderSide: BorderSide.none),
        ),
        value: selectedGender,
        onChanged: (String? newValue) {
          setState(() {
            selectedGender = newValue;
          });
          widget.onChanged(newValue);
        },
        alignment: Alignment.bottomCenter,
        items:
            <String>['Nam', 'Nữ'].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value,
                style: const TextStyle(color: Colors.black)), // Màu chữ cho item
          );
        }).toList(),
        selectedItemBuilder: (BuildContext context) {
          return <String>['Nam', 'Nữ'].map<Widget>((String value) {
            return Container(
              child: Text(
                value,
                style: const TextStyle(
                  color: Colors.white, // Màu chữ cho item đã chọn
                ),
              ),
            );
          }).toList();
        },
      ),
    );
  }
}
