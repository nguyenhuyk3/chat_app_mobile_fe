import 'package:flutter/material.dart';

class NotificationWidget extends StatelessWidget {
  final String title;
  final String body;
  final String senderAvatar;

  const NotificationWidget({
    super.key,
    required this.title,
    required this.body,
    required this.senderAvatar,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key('notification_${DateTime.now().millisecondsSinceEpoch}'),
      direction: DismissDirection.horizontal,
      onDismissed: (_) {},
      child: AnimatedOpacity(
        opacity: 1.0,
        duration: const Duration(milliseconds: 300),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.black87.withOpacity(0.9),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.account_box_sharp,
                    color: Colors.grey,
                    size: 42,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              title,
                              style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '  •  ngay lúc này',
                              style: TextStyle(
                                  color: Colors.grey[350], fontSize: 12),
                            ),
                          ],
                        ),
                        const SizedBox(height: 7),
                        Text(
                          body,
                          style:
                              TextStyle(color: Colors.grey[350], fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
