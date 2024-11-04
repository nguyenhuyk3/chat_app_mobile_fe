import 'package:flutter/material.dart';

class GenderRadioButton extends StatefulWidget {
  final ValueChanged<String?> onChanged; // Callback để truyền giá trị
  const GenderRadioButton({super.key, required this.onChanged});

  @override
  State<GenderRadioButton> createState() => _GenderRadioButtonState();
}

class _GenderRadioButtonState extends State<GenderRadioButton> {
  String? selectedGender = 'Nam';

  @override
  void initState() {
    super.initState();
    // Sử dụng `addPostFrameCallback` để gọi callback sau khi xây dựng widget
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onChanged(selectedGender);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Text(
            "Giới tính",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
          ),
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: RadioListTile<String>(
                title: const Text(
                  'Nam',
                  style: TextStyle(color: Colors.white),
                ),
                value: 'Nam',
                groupValue: selectedGender,
                onChanged: (String? value) {
                  setState(() {
                    selectedGender = value;
                  });
                  widget.onChanged(value);
                },
                activeColor: Colors.white,
              ),
            ),
            Expanded(
              child: RadioListTile<String>(
                title: const Text(
                  'Nữ',
                  style: TextStyle(color: Colors.white),
                ),
                value: 'Nữ',
                groupValue: selectedGender,
                onChanged: (String? value) {
                  setState(() {
                    selectedGender = value;
                  });
                  widget.onChanged(value);
                },
                activeColor: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }
}