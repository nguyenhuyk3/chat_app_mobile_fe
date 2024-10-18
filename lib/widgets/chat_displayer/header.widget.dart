import 'package:flutter/material.dart';

class ChatDisplayerAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String fullName;
  final String lastStatus;
  final VoidCallback onBackPressed;

  const ChatDisplayerAppBar({
    super.key,
    required this.fullName,
    required this.lastStatus,
    required this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF31363F),
      elevation: 1,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: onBackPressed,
      ),
      titleSpacing: 0,
      title: Row(
        children: [
          const Icon(
            Icons.account_circle_sharp,
            color: Colors.white,
            size: 44,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fullName,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5),
                Text(
                  lastStatus,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.more_vert, color: Colors.white),
          onPressed: () {},
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(62);
}
