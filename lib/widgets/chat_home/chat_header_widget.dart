import 'package:chat_app_mobile_fe/screens/setting/setting_screen.dart';
import 'package:chat_app_mobile_fe/screens/home/search_history_screen.dart'; // Nhập màn hình mới
import 'package:chat_app_mobile_fe/widgets/chat_home/search_bar_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
                  _searchController.clear();
                  setState(() {
                    _isSearching = false;
                  });
                },
              )
            : IconButton(
                icon: const Icon(Icons.search, color: Colors.white),
                onPressed: () {
                  // Ngay khi bấm vào biểu tượng tìm kiếm, điều hướng đến màn hình tìm kiếm
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SearchHistoryScreen(),
                    ),
                  );
                },
              ),
        PopupMenuTheme(
          data: const PopupMenuThemeData(
            color: Color.fromARGB(255, 24, 41, 50),
          ),
          child: PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            offset: const Offset(0, 40),
            onSelected: (value) {
              if (value == 'settings') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MySettingScreen(),
                  ),
                );
              } else if (value == 'logout') {
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, '/login');
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
