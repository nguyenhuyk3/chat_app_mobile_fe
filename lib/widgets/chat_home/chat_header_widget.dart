import 'package:chat_app_mobile_fe/widgets/chat_home/chat_header/search_bar_widget.dart';
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
      // hide back arrow
      // automaticallyImplyLeading: false,
      backgroundColor: const Color(0xFF0F181D),
      elevation: 1,
      title: _isSearching
          ? SearchBarWidget(searchController: _searchController)
          : Text("PingMe!!", style: TextStyle(color: Colors.white)),
      actions: [
        _isSearching
            ? IconButton(
                icon: const Icon(Icons.clear, color: Colors.white),
                onPressed: () {
                  _searchController
                      .clear(); // Xóa nội dung khi nhấn nút "clear"
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
        IconButton(
          icon: const Icon(Icons.more_vert, color: Colors.white),
          onPressed: () {},
        ),
      ],
    );
  }
}
