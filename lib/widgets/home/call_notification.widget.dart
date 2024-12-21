import 'dart:async';

import 'package:flutter/material.dart';

class CallNotificationWidget extends StatefulWidget {
  final String callerName;

  const CallNotificationWidget({super.key, required this.callerName});

  @override
  _CallNotificationState createState() => _CallNotificationState();
}

class _CallNotificationState extends State<CallNotificationWidget> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 10), () {
      Navigator.pop(context);
    });
  }

  @override
  void dispose() {
    _timer.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 10,
      left: 0,
      right: 0,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${widget.callerName} đang gọi...",
                style: const TextStyle(color: Colors.white),
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      // Xử lý khi nhấn trả lời
                    },
                    child: const Text(
                      "Trả lời",
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Xử lý khi nhấn từ chối
                    },
                    child: const Text(
                      "Từ chối",
                      style: TextStyle(color: Colors.red),
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
