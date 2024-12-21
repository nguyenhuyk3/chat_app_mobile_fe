import 'dart:async';
import 'package:chat_app_mobile_fe/services/stream.services.dart';
import 'package:chat_app_mobile_fe/utils/log.utils.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class IncomingMediaScreen extends StatefulWidget {
  final String callerName;
  final String? callerAvatarUrl;
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  const IncomingMediaScreen({
    super.key,
    required this.callerName,
    this.callerAvatarUrl,
    required this.onAccept,
    required this.onDecline,
  });

  @override
  _IncomingMediaScreenState createState() => _IncomingMediaScreenState();
}

class _IncomingMediaScreenState extends State<IncomingMediaScreen> {
  final _streamService = StreamServics();
  StreamSubscription? _streamSubscription;
  final Logger logger = Logger(
    printer: CustomPrinter(),
  );

  @override
  void initState() {
    super.initState();

    _streamSubscription = _streamService.callDataController.listen((data) {
      setState(() {
        if (data["type"] == "missed-media-call-signal") {
          Navigator.pop(context);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF303841),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.transparent,
              backgroundImage: widget.callerAvatarUrl != null
                  ? NetworkImage(
                      widget.callerAvatarUrl!,
                    )
                  : null,
              child: widget.callerAvatarUrl == null
                  ? const Icon(
                      Icons.account_circle,
                      size: 100,
                      color: Colors.white,
                    )
                  : null,
            ),
            const SizedBox(height: 20),
            Text(
              widget.callerName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Cuộc gọi thoại trên PingMe',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton(
                  heroTag: 'decline',
                  backgroundColor: Colors.red,
                  onPressed: widget.onDecline,
                  child: const Icon(Icons.call_end),
                ),
                FloatingActionButton(
                  heroTag: 'accept',
                  backgroundColor: Colors.green,
                  onPressed: widget.onAccept,
                  child: const Icon(Icons.call),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
