import 'package:chat_app_mobile_fe/bloc/chat/chat_home/chat_list/chat_list.bloc.dart';
import 'package:chat_app_mobile_fe/bloc/chat/chat_home/chat_list/chat_list.state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DisplayerAppBarWidget extends StatelessWidget
    implements PreferredSizeWidget {
  final String receiverId;
  final String fullName;
  final String lastStatus;
  // final bool isOnline;
  final VoidCallback onBackPressed;

  const DisplayerAppBarWidget({
    super.key,
    required this.receiverId,
    required this.fullName,
    required this.lastStatus,
    required this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatListBloc, ChatListState>(
      builder: (context, state) {
        bool isOnline =
            state is ChatLoaded && state.onlineFriendIds.contains(receiverId);
        return AppBar(
          backgroundColor: const Color(0xFF303841),
          elevation: 1,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: onBackPressed,
          ),
          titleSpacing: 0,
          title: Row(
            children: [
              Stack(children: [
                const Icon(
                  Icons.account_circle_sharp,
                  color: Colors.white,
                  size: 44,
                ),
                if (isOnline)
                  Positioned(
                    right: 2,
                    bottom: 0,
                    child: Container(
                      width: 15,
                      height: 15,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF31363F),
                          width: 3,
                        ),
                      ),
                    ),
                  ),
              ]),
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
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(62);
}
