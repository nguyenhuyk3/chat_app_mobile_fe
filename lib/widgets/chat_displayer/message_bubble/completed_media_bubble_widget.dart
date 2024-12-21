import 'package:flutter/material.dart';

class CompletedMediaBubbleWidget extends StatelessWidget {
  final String content;
  final Widget createdAt;
  final Widget messageState;
  final IconData icon;

  const CompletedMediaBubbleWidget({
    super.key,
    required this.content,
    required this.createdAt,
    required this.messageState,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> parts = content.split(" ");
    final String time = parts.last;

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
                color: Colors.grey,
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
              const Text(
                "Cuộc gọi hội thoại",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontStyle: FontStyle.normal,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                time,
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
