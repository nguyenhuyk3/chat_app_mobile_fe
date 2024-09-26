import 'package:flutter/material.dart';

class DiagonalPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFB2FFF0) // Màu xanh lục lam nhạt
      ..style = PaintingStyle.fill;

    // Tạo một path cho hình tam giác cắt chéo màn hình
    final path = Path()
      ..moveTo(
          size.width, size.height * 0.2) // Điểm bắt đầu tại 30% từ dưới lên
      ..lineTo(size.width, size.height) // Kéo đến giữa bên phải
      ..lineTo(size.width, size.height) // Góc dưới bên phải
      ..lineTo(0, size.height) // Góc dưới bên trái
      ..close(); // Đóng path

    // Vẽ path trên canvas
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class FirstScreen extends StatelessWidget {
  const FirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Vẽ widget cắt chéo màn hình
          CustomPaint(
            size: const Size(double.infinity, double.infinity),
            painter: DiagonalPainter(),
          ),
          Container(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 50),
                child: Image.asset(
                  'assets/images/logo_pingme.png',
                  height: 300,
                ),
              ),
            ),
          ),
          const Positioned(
            bottom: 20, // Đặt khoảng cách từ dưới màn hình
            right: 20, // Đặt khoảng cách từ bên phải
            child: Text(
              'chatAPP',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey, // Màu sắc của chữ
              ),
            ),
          ),
        ],
      ),
    );
  }
}
