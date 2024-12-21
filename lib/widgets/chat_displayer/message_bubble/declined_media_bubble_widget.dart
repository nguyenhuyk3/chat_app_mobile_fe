import 'package:flutter/material.dart';

class DeclinedMediaBubble extends StatelessWidget {
  final bool isCurrentUser;
  final String content;
  final Widget createdAt;
  final Widget messageState;
  final IconData icon;

  const DeclinedMediaBubble({
    super.key,
    required this.isCurrentUser,
    required this.content,
    required this.createdAt,
    required this.messageState,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Transform.translate(
            offset: const Offset(0, -3),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red,
                border: Border.all(
                  color: Colors.transparent,
                ),
              ),
              child: Icon(
                icon,
                size: 24,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isCurrentUser
                    ? "Cuộc gọi của bạn đã bị từ chối"
                    : "Bạn đã từ chối cuộc gọi",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontStyle: FontStyle.normal,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                isCurrentUser
                    ? "Bạn có thể để lại tin nhắn thoại"
                    : "Hãy phản hồi lại cho đối phương",
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
          Baseline(
            baseline: 20,
            baselineType: TextBaseline.alphabetic,
            child: Row(
              children: <Widget>[
                createdAt,
                const SizedBox(width: 4),
                messageState,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
