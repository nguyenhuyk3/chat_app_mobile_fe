import 'package:chat_app_mobile_fe/screens/chat_displayer_sceen.dart';
import 'package:flutter/material.dart';

class ChatElementWidget extends StatefulWidget {
  final String roomId;

  const ChatElementWidget({
    super.key,
    required this.roomId,
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
        setState(
          () {
            _isTapped = true;
          },
        );

        Future.delayed(
          const Duration(milliseconds: 200),
          () {
            setState(
              () {
                _isTapped = false;
              },
            );

            Navigator.push(
              // ignore: use_build_context_synchronously
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ChatDisplayerScreen(roomId: widget.roomId),
              ),
            );
          },
        );
      },
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: _isTapped ? 1.0 : 0.0),
        duration: const Duration(milliseconds: 200),
        builder: (context, position, child) {
          return Container(
            decoration: BoxDecoration(
              // Gradient will change first color to second color
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
              leading: const SizedBox(
                height: double.infinity,
                child: Icon(
                  Icons.account_circle_sharp,
                  color: Color(0xFF637079),
                  size: 50, // Kích thước của biểu tượng có thể điều chỉnh
                ),
              ),
              title: Text(
                'Phòng số' + widget.roomId,
                style: const TextStyle(color: Colors.white),
              ),
              subtitle: const Text(
                'This will be a last message in the room',
                style: TextStyle(color: Color(0xFF767980)),
              ),
              trailing: const Text(
                '9/26/2024',
                style: TextStyle(color: Color(0xFF767980)),
              ),
            ),
          );
        },
      ),
    );
  }
}
