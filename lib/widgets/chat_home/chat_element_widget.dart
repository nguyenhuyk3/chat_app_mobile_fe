// ignore_for_file: use_build_context_synchronously

import 'package:chat_app_mobile_fe/bloc/chat/chat_home/chat_list/chat_list.bloc.dart';
import 'package:chat_app_mobile_fe/bloc/chat/chat_home/chat_list/chat_list.event.dart';
import 'package:chat_app_mobile_fe/bloc/chat/chat_home/chat_list/chat_list.state.dart';
import 'package:chat_app_mobile_fe/helpers/shared_preferences_helper.dart';
import 'package:chat_app_mobile_fe/models/response/all_message_boxes.response.dart';
import 'package:chat_app_mobile_fe/screens/chat/chat_displayer_sceen.dart';
import 'package:chat_app_mobile_fe/services/notification.services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatElementWidget extends StatefulWidget {
  final String messageBoxId;
  final String receiverId;
  final bool isOnline;
  final MessageBoxResponse messageBoxReponse;

  const ChatElementWidget({
    super.key,
    required this.messageBoxId,
    required this.receiverId,
    required this.isOnline,
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
  late final LastStateMessage _lastStateMessage;

  Future<void> _initUserId() async {
    _userId = await SharedPreferencesHelper.getUserId();
  }

  Future<void> _initTokenOfReceiver() async {
    String? tokenOfReceiver = await NotificationServices()
        .getTokenByUserId(userId: widget.receiverId);
    _token = tokenOfReceiver;
  }

  @override
  void initState() {
    super.initState();

    _initUserId();
    _initTokenOfReceiver();

    _userName = widget.receiverId == widget.messageBoxReponse.firstInforUser.id
        ? widget.messageBoxReponse.firstInforUser.fullName
        : widget.messageBoxReponse.secondInforUser.fullName;
    _lastStateMessage = widget.receiverId ==
            widget.messageBoxReponse.lastStateMessageForFirstUser.userId
        ? widget.messageBoxReponse.lastStateMessageForSecondUser
        : widget.messageBoxReponse.lastStateMessageForFirstUser;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      BlocProvider.of<ChatListBloc>(context).stream.listen((state) {
        if (state is ChatLoaded) {
          if (widget.receiverId == state.onlineUserId) {
            print("lkajslkfjlskfksdf");
            print(widget.receiverId);
            print(state.onlineUserId);
            _initTokenOfReceiver().then((_) => {
                  print("lkajslkfjlskfksdf"),
                  print(_token),
                });
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatListBloc = context.read<ChatListBloc>();

    return BlocProvider.value(
      value: chatListBloc,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _isTapped = true;
          });

          context.read<ChatListBloc>().add(MarkMessageAsRead(
              messageBoxId: widget.messageBoxId, userId: _userId!));

          Future.delayed(
            const Duration(milliseconds: 200),
            () {
              setState(() {
                _isTapped = false;
              });

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider.value(
                    value: chatListBloc,
                    child: ChatDisplayerScreen(
                      messageBoxId: widget.messageBoxReponse.messageBoxId,
                      token: _token,
                      receiverId: widget.receiverId,
                      userName: _userName,
                    ),
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
                leading: Stack(
                  children: [
                    const SizedBox(
                      height: 50,
                      width: 50,
                      child: Icon(
                        Icons.account_circle_sharp,
                        color: Color(0xFFF4F6FF),
                        size: 50,
                      ),
                    ),
                    if (widget.isOnline)
                      Positioned(
                        right: 3,
                        bottom: 0,
                        child: Container(
                          width: 17,
                          height: 17,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFF222831),
                              width: 3,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                title: Text(
                  _userName,
                  style: const TextStyle(color: Colors.white),
                ),
                subtitle: Row(
                  children: [
                    Icon(
                      Icons.check,
                      size: 17,
                      color: _lastStateMessage.lastStatus == "chưa đọc"
                          ? Colors.grey
                          : Colors.blue,
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Expanded(
                      // Để văn bản không bị tràn ra ngoài
                      child: Text(
                        _lastStateMessage.lastMessage,
                        style: TextStyle(
                          color: _lastStateMessage.lastStatus == "chưa đọc"
                              ? Colors.white
                              : Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
                trailing: Text(
                  _lastStateMessage.lastTime.split(" ")[1].substring(0, 5),
                  style: TextStyle(
                    color: _lastStateMessage.lastStatus == "chưa đọc"
                        ? Colors.white
                        : Colors.grey,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
