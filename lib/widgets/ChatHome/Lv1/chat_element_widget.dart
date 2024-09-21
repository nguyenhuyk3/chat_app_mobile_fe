import 'package:chat_app_mobile_fe/screens/chat_displayer_sceen.dart';
import 'package:flutter/material.dart';

class ChatElementWidget extends StatefulWidget {
  final String username;
  final String lastMessage;
  final bool seen;
  final String sentAt;

  const ChatElementWidget({
    super.key,
    required this.username,
    required this.lastMessage,
    required this.seen,
    required this.sentAt,
  });

  @override
  State<ChatElementWidget> createState() => _ChatElementWidgetState();
}

class _ChatElementWidgetState extends State<ChatElementWidget> {
  bool _isTapped = false; // Biến trạng thái để theo dõi khi nhấn

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isTapped = true;
        });

        Future.delayed(const Duration(milliseconds: 200), () {
          setState(() {
            _isTapped = false;
          });

          Navigator.push(
            // ignore: use_build_context_synchronously
            context,
            MaterialPageRoute(
                builder: (context) => const ChatDisplayerScreen()),
          );
        });
      },
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: _isTapped ? 1.0 : 0.0),
        duration: const Duration(milliseconds: 200),
        builder: (context, position, child) {
          return Container(
            decoration: BoxDecoration(
              // gradient will change first color to second color
              gradient: LinearGradient(
                colors: const [
                  Colors.white30,
                  Color(0xFF111E26),
                ],
                stops: [position, position],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            child: ListTile(
              leading: const CircleAvatar(
                child: Icon(
                  Icons.account_circle_outlined,
                  color: Color(0xFF566573),
                ),
              ),
              title: Text(
                widget.username,
                style: const TextStyle(color: Color(0xFFD2D6D9)),
              ),
              subtitle: Text(
                widget.lastMessage,
                style: const TextStyle(color: Color(0xFF566573)),
              ),
              trailing: Text(
                widget.sentAt,
                style: const TextStyle(color: Color(0xFF566573)),
              ),
            ),
          );
        },
      ),
    );
  }
}
