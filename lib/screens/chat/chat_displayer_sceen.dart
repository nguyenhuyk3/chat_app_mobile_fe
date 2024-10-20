import 'dart:convert';
import 'package:chat_app_mobile_fe/global/global_var.dart';
import 'package:chat_app_mobile_fe/helpers/shared_preferences_helper.dart';
import 'package:chat_app_mobile_fe/models/response/message.reponse.dart';
import 'package:chat_app_mobile_fe/services/chat.services.dart';
import 'package:chat_app_mobile_fe/utils/check_date.util.dart';
import 'package:chat_app_mobile_fe/widgets/chat_displayer/date_seperator.widget.dart';
import 'package:chat_app_mobile_fe/widgets/chat_displayer/header.widget.dart';
import 'package:chat_app_mobile_fe/widgets/chat_displayer/unread_message_seperator.widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter/material.dart';
import 'package:chat_app_mobile_fe/widgets/chat_displayer/message_bubble_widget.dart';

class ChatDisplayerScreen extends StatefulWidget {
  final String messageBoxId;
  final String receiverId;
  final String token;
  final String userName;
  const ChatDisplayerScreen(
      {super.key,
      required this.receiverId,
      required this.token,
      required this.messageBoxId,
      required this.userName});

  @override
  State<ChatDisplayerScreen> createState() => _ChatDisplayerScreenState();
}

class _ChatDisplayerScreenState extends State<ChatDisplayerScreen> {
  late final WebSocketChannel channel;
  String? userId;
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  List<MessageResponse> messages = [];
  int? firstUnreadMessageIndex;

  Future<void> _initUserId() async {
    userId = await SharedPreferencesHelper.getUserId();
  }

  Future<void> _fetchMessageBox() async {
    try {
      final List<MessageResponse> messageBox =
          await ChatServices.getMessageBoxById(widget.messageBoxId);

      setState(() {
        firstUnreadMessageIndex = messageBox.indexWhere(
            (msg) => msg.state == "chưa đọc" && msg.senderId != userId);

        if (firstUnreadMessageIndex == -1) {
          messages = messageBox.reversed.toList();
          firstUnreadMessageIndex = null;
        } else {
          firstUnreadMessageIndex =
              messageBox.length - firstUnreadMessageIndex! - 1;
          messages = messageBox.reversed.toList();
        }
      });
    } catch (e) {
      print('Failed to fetch message box: $e');
    }
  }

  void _scrollToBottom() {
    if (scrollController.hasClients) {
      scrollController.jumpTo(0);
    }
  }

  void _markMessagesAsRead() {
    setState(() {
      messages = messages.map((msg) {
        if (msg.state == "chưa đọc") {
          return msg.copyWith(state: "đã đọc");
        }
        return msg;
      }).toList();
    });
  }

  void _readUnreadedMessages() async {
    await ChatServices.readUnreadMessages(
        userId: userId!, messageBoxId: widget.messageBoxId);
  }

  Future<void> _joinMessageBox() async {
    final url =
        "${GlobalVar.websocketBaseUrl}/join_message_box/${widget.messageBoxId}?user_id=${userId!}";

    channel = WebSocketChannel.connect(Uri.parse(url));
    channel.stream.listen((data) {
      final jsonData = jsonDecode(data);

      if (jsonData["content"] != GlobalVar.keyJoinRoom) {
        final MessageResponse newMessage = MessageResponse.fromJson(jsonData);

        firstUnreadMessageIndex = firstUnreadMessageIndex! + 1;

        setState(() {
          messages.insert(0, newMessage);
        });
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToBottom();
        });
      } else {
        _markMessagesAsRead();
      }
    });
  }

  void _sendMessage({required String content}) {
    ChatServices.sendMessage(
        senderId: userId!,
        receiverId: widget.receiverId,
        token: widget.token,
        messageBoxId: widget.messageBoxId,
        content: content,
        channel: channel);

    messageController.clear();
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.isNotEmpty) {
      final file = result.files.first;
      // Xử lý file (ví dụ: upload hoặc gửi qua chat).
      print('Đã chọn file: ${file.name}');
    }
  }

  @override
  void initState() {
    super.initState();

    _initUserId().then((_) {
      _fetchMessageBox().then((_) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (messages.isNotEmpty &&
              messages[0].state == "chưa đọc" &&
              userId != messages[0].senderId) {
            _readUnreadedMessages();
            _markMessagesAsRead();
          }
        });

        _joinMessageBox();
      });
    });
  }

  @override
  void dispose() {
    channel.sink.close();
    scrollController.dispose();
    messageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChatDisplayerAppBar(
        fullName: widget.userName,
        lastStatus: 'last seen at 12:30 PM',
        onBackPressed: () => Navigator.pop(context),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                './assets/img/app/background_for_chat_displayer.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                reverse: true,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final bool hasBubbleNip = index < messages.length - 1 &&
                          messages[index].senderId ==
                              messages[index + 1].senderId
                      ? false
                      : true;
                  final bool showDateHeader = index == messages.length - 1 ||
                      !CheckDate.isSameDay(messages[index].createdAt,
                          messages[index + 1].createdAt);
                  final bool showUnreadLabel =
                      firstUnreadMessageIndex != null &&
                          index == firstUnreadMessageIndex;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (showDateHeader)
                        DateSeperatorWidget(
                          createdAt: messages[index].createdAt,
                        ),
                      if (showUnreadLabel) const UnreadMessageSeparatorWidget(),
                      MessageBubbleWidget(
                        senderId: userId!,
                        hasBubbleNip: hasBubbleNip,
                        message: messages[index],
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            // Input
            Container(
              color: Colors.transparent,
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.attach_file,
                      color: Color(0xFFB7B7B7),
                    ),
                    onPressed: _pickFile,
                  ),
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Nhắn tin',
                        hintStyle: const TextStyle(color: Color(0xFFB7B7B7)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: const Color(0xFF31363F),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        prefixIcon: IconButton(
                          icon: const Icon(
                            Icons.emoji_emotions,
                            color: Color(0xFFB7B7B7),
                          ),
                          onPressed: () {},
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  FloatingActionButton(
                    onPressed: () => {
                      _sendMessage(
                        content: messageController.text,
                      ),
                    },
                    backgroundColor: const Color(0xFF00FF9C),
                    mini: true,
                    child: const Icon(
                      Icons.send,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
