import 'package:chat_app_mobile_fe/screens/user/receiving_invitation.screen.dart';
import 'package:chat_app_mobile_fe/screens/user/sending_invitation.screen.dart';
import 'package:flutter/material.dart';

class ListFriendsScreen extends StatefulWidget {
  const ListFriendsScreen({super.key});

  @override
  State<ListFriendsScreen> createState() => _ListFriendsScreenState();
}

class _ListFriendsScreenState extends State<ListFriendsScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          // hide back arrow
          automaticallyImplyLeading: false,
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.chat), text: 'Lời mời đã gửi'),
              Tab(icon: Icon(Icons.call), text: 'Lời mời kết bạn'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            SendingInvitationScreen(),
            ReceivingInvitationScreen()
          ],
        ),
      ),
    );
  }
}
