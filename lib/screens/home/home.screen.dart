import 'package:chat_app_mobile_fe/screens/chat/chat_home_screen.dart';

import 'package:chat_app_mobile_fe/screens/user/list_invitations.screen.dart';
import 'package:chat_app_mobile_fe/widgets/chat_home/chat_header_widget.dart';
import 'package:chat_app_mobile_fe/widgets/home/bottom_navigation_bar_items.widget.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  final List<Widget> _screens = [
    const ChatHomeScreen(),
    const ListInvitationsScreen()
  ];

  void _onItemTapped(int index) {
    setState(
      () {
        _selectedIndex = index;
      },
    );
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _selectedIndex == 0
          ? const PreferredSize(
              preferredSize: Size.fromHeight(62),
              child: ChatHeaderWidget(),
            )
          : null,
      body: PageView(
        controller: _pageController,
        // Prevent users from swiping to switch
        physics: const NeverScrollableScrollPhysics(),
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBarItems(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
