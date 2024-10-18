import 'package:chat_app_mobile_fe/helpers/shared_preferences_helper.dart';
import 'package:chat_app_mobile_fe/models/response/all_message_boxes.response.dart';
import 'package:chat_app_mobile_fe/screens/chat/chat_displayer_sceen.dart';
import 'package:chat_app_mobile_fe/services/notification.services.dart';
import 'package:flutter/material.dart';

class ChatElementWidget extends StatefulWidget {
  final String messageBoxId;
  final String receiverId;
  final MessageBoxResponse messageBoxReponse;

  const ChatElementWidget({
    super.key,
    required this.messageBoxId,
    required this.receiverId,
    required this.messageBoxReponse,
  });

  @override
  State<ChatElementWidget> createState() => _ChatElementWidgetState();
}

class _ChatElementWidgetState extends State<ChatElementWidget> {
  late final String _userName;
  String? _userId;
  String? _token;
  // state variable to track when pressed
  bool _isTapped = false;

  Future<void> _initUserId() async {
    _userId = await SharedPreferencesHelper.getUserId();
  }

  Future<void> _initTokenOfReceiver() async {
    String? tokenOfReceiver = await NotificationServices()
        .getTokenByUserId(userId: widget.receiverId);
    _token = tokenOfReceiver;

    print(_userId);
    print("concak");
    print(widget.receiverId);
  }

  @override
  void initState() {
    super.initState();

    _initUserId();
    _initTokenOfReceiver();

    _userName = widget.receiverId == widget.messageBoxReponse.firstInforUser.id
        ? widget.messageBoxReponse.firstInforUser.fullName
        : widget.messageBoxReponse.secondInforUser.fullName;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isTapped = true;
        });
        Future.delayed(
          const Duration(milliseconds: 200),
          () {
            setState(() {
              _isTapped = false;
            });
            Navigator.push(
              // ignore: use_build_context_synchronously
              context,
              MaterialPageRoute(
                builder: (context) => ChatDisplayerScreen(
                  messageBoxId: widget.messageBoxReponse.messageBoxId,
                  token: _token!,
                  receiverId: widget.receiverId,
                  userName: _userName,
                ),
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
                  Color(0xFF222831),
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
                  color: Color(0xFFF4F6FF),
                  size: 50,
                ),
              ),
              title: Text(
                _userName,
                style: const TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                _userId ==
                        widget.messageBoxReponse.lastStateMessageForFirstUser
                            .userId
                    ? widget.messageBoxReponse.lastStateMessageForFirstUser
                        .lastMessage
                    : widget.messageBoxReponse.lastStateMessageForSecondUser
                        .lastMessage,
                style: const TextStyle(color: Colors.grey),
              ),
              trailing: Text(
                _userId ==
                        widget.messageBoxReponse.lastStateMessageForFirstUser
                            .userId
                    ? widget
                        .messageBoxReponse.lastStateMessageForFirstUser.lastTime
                        .split(" ")[1]
                        .substring(0, 5)
                    : widget.messageBoxReponse.lastStateMessageForSecondUser
                        .lastTime
                        .split(" ")[1]
                        .substring(0, 5),
                style: const TextStyle(color: Colors.grey),
              ),
            ),
          );
        },
      ),
    );
  }
}
