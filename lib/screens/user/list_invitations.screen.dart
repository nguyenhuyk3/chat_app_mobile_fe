import 'package:chat_app_mobile_fe/screens/user/receiving_invitation.screen.dart';
import 'package:flutter/material.dart';

class ListInvitationsScreen extends StatefulWidget {
  const ListInvitationsScreen({super.key});

  @override
  State<ListInvitationsScreen> createState() => _ListInvitationssScreenState();
}

class _ListInvitationssScreenState extends State<ListInvitationsScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 1,
          backgroundColor: const Color(0xFF31363F),
          toolbarHeight: 0,
          // hide back arrow
          automaticallyImplyLeading: false,
          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelColor: Color(0xFF73EC8B),
            unselectedLabelColor: Colors.white,
            tabs: [
              Tab(
                  icon: Icon(Icons.person_add_alt_1_rounded),
                  text: 'Lời mời kết bạn'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [ReceivingInvitationScreen()],
        ),
      ),
    );
  }
}
