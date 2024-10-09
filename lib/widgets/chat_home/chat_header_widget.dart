import 'package:chat_app_mobile_fe/screens/setting/setting_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chat_app_mobile_fe/widgets/chat_home/chat_header/search_bar_widget.dart';

class ChatHeaderWidget extends StatefulWidget {
  const ChatHeaderWidget({super.key});

  @override
  State<ChatHeaderWidget> createState() => _ChatHeaderWidgetState();
}

class _ChatHeaderWidgetState extends State<ChatHeaderWidget> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF0F181D),
      elevation: 1,
      title: _isSearching
          ? SearchBarWidget(searchController: _searchController)
          : const Text("PingMe!!", style: TextStyle(color: Colors.white)),
      actions: [
        _isSearching
            ? IconButton(
                icon: const Icon(Icons.clear, color: Colors.white),
                onPressed: () {
                  _searchController
                      .clear(); // Xóa nội dung khi nhấn nút "clear"
                  setState(() {
                    _isSearching = false; // Tắt chế độ tìm kiếm
                  });
                },
              )
            : IconButton(
                icon: const Icon(Icons.search, color: Colors.white),
                onPressed: () {
                  setState(() {
                    _isSearching = true; // Bật chế độ tìm kiếm
                  });
                },
              ),
        // Sử dụng PopupMenuTheme
        PopupMenuTheme(
          data: const PopupMenuThemeData(
            color: Color.fromARGB(255, 24, 41, 50),
          ),
          child: PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            offset: const Offset(0, 40), // Đẩy menu xuống dưới icon
            onSelected: (value) {
              if (value == 'settings') {
                // Xử lý khi chọn "Cài đặt"
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MySettingScreen()));
                // Điều hướng tới màn hình cài đặt (nếu cần)
              } else if (value == 'logout') {
                // Xử lý khi chọn "Đăng xuất"
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, '/login');
                // Thực hiện đăng xuất tại đây
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'settings',
                child: Text(
                  'Cài đặt',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'logout',
                child: Text(
                  'Đăng xuất',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
