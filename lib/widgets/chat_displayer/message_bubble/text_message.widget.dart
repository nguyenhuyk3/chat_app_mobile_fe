// lib/widgets/text_message_widget.dart
import 'package:flutter/material.dart';

class TextMessageWidget extends StatelessWidget {
  final String content;
  final Widget createdAt;
  final Widget messageState;

  const TextMessageWidget({
    super.key,
    required this.content,
    required this.createdAt,
    required this.messageState,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Flexible(
            child: Text(
              content,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontStyle: FontStyle.normal,
              ),
            ),
          ),
          const SizedBox(width: 4),
          Baseline(
            baseline: 10,
            baselineType: TextBaseline.alphabetic,
            child: Row(
              children: <Widget>[
                createdAt,
                const SizedBox(width: 4),
                messageState
              ],
            ),
          ),
        ],
      ),
    );
  }
}
