import 'package:chat_app_mobile_fe/widgets/modals/form_day_month_year.dart';
import 'package:flutter/material.dart';

class SignupDateField extends StatefulWidget {
  final TextEditingController controllerDate;

  const SignupDateField({super.key, required this.controllerDate});

  @override
  _SignupDateFieldState createState() => _SignupDateFieldState();
}

class _SignupDateFieldState extends State<SignupDateField> {
  String selectedDate = '';

  @override
  void initState() {
    super.initState();
    // Lấy ngày hiện tại
    DateTime now = DateTime.now();
    // Gán giá trị mặc định với định dạng dd-mm-yyyy
    selectedDate =
        '${now.day.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.year}';
    widget.controllerDate.text = selectedDate;
  }

  void _showDatePicker() {
    showDialog(
      context: context,
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          child: FormSelectDayMonthYear(
            onDateSelected: (date) {
              setState(() {
                selectedDate = date; // Cập nhật giá trị đã chọn
                widget.controllerDate.text =
                    selectedDate; // Cập nhật giá trị cho TextFormField
              });
              Navigator.pop(context);
            },
            initialDate: selectedDate, // Truyền giá trị đã chọn vào đây
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 0.08, color: Colors.white),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        controller: widget.controllerDate,
        readOnly: true,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          label: const Text(
            'Ngày sinh',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          suffixIcon: IconButton(
            icon: const Icon(
              Icons.calendar_month_sharp,
              color: Colors.white,
            ),
            onPressed: _showDatePicker,
          ),
        ),
      ),
    );
  }
}
