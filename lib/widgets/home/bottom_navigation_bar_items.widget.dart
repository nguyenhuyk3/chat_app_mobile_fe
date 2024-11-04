import 'package:flutter/material.dart';

class BottomNavigationBarItems extends StatelessWidget {
  final int _selectedIndex;
  final Function(int) _onItemTapped;
  const BottomNavigationBarItems(
      {super.key,
      required int selectedIndex,
      required Function(int) onItemTapped})
      : _selectedIndex = selectedIndex,
        _onItemTapped = onItemTapped;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      elevation: 1,
      backgroundColor: const Color(0xFF303841),
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Container(
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(19),
              color: _selectedIndex == 0
                  ? const Color(0xFF40A578)
                  : Colors.transparent,
            ),
            margin: const EdgeInsets.only(top: 2.5),
            padding: const EdgeInsets.fromLTRB(18, 4, 18, 4),
            child: Icon(
              Icons.chat,
              color:
                  _selectedIndex == 0 ? const Color(0xFF10375C) : const Color(0xFFF4F6FF),
            ),
          ),
          label: 'Trò chuyện',
        ),
        BottomNavigationBarItem(
          icon: Container(
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(19),
              color: _selectedIndex == 1
                  ? const Color(0xFF40A578)
                  : Colors.transparent,
            ),
            margin: const EdgeInsets.only(top: 2.5),
            padding: const EdgeInsets.fromLTRB(18, 4, 18, 4),
            child: Icon(
              Icons.people_outline_sharp,
              color:
                  _selectedIndex == 1 ? const Color(0xFF10375C) : const Color(0xFFF4F6FF),
            ),
          ),
          label: 'Lời mời kết bạn',
        ),
        BottomNavigationBarItem(
          icon: Container(
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(19),
              color: _selectedIndex == 2
                  ? const Color(0xFF0D7C66)
                  : Colors.transparent,
            ),
            margin: const EdgeInsets.only(top: 2.5),
            padding: const EdgeInsets.fromLTRB(18, 4, 18, 4),
            child: Icon(
              Icons.call,
              color:
                  _selectedIndex == 2 ? const Color(0xFF10375C) : const Color(0xFFF4F6FF),
            ),
          ),
          label: 'Cuộc gọi',
        ),
      ],
      iconSize: 27,
      currentIndex: _selectedIndex,
      selectedItemColor: const Color(0xFFF4F6FF),
      unselectedItemColor: const Color(0xFFF4F6FF),
      selectedLabelStyle: const TextStyle(
        height: 2.5,
        color:  Color(0xFFF4F6FF),
        fontWeight: FontWeight.bold,
        fontSize: 13,
      ),
      unselectedLabelStyle: const TextStyle(
        height: 2.5,
        color: Color(0xFFF4F6FF),
        fontWeight: FontWeight.bold,
        fontSize: 13,
      ),
      onTap: _onItemTapped,
    );
  }
}
