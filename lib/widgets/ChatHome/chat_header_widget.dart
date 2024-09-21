import 'package:flutter/material.dart';

class ChatHeaderWidget extends StatelessWidget implements PreferredSizeWidget {
  const ChatHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF10261E),
      child: const ListTile(
        leading: Text(
          'Ping me!',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
