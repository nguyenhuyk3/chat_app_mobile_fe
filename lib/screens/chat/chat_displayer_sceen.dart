import 'dart:convert';
import 'dart:io';
import 'package:chat_app_mobile_fe/global/global_var.dart';
import 'package:chat_app_mobile_fe/helpers/shared_preferences_helper.dart';
import 'package:chat_app_mobile_fe/models/response/message.reponse.dart';
import 'package:chat_app_mobile_fe/services/chat.services.dart';
import 'package:chat_app_mobile_fe/services/user.service.dart';
import 'package:chat_app_mobile_fe/utils/check_date.util.dart';
import 'package:chat_app_mobile_fe/utils/generator.utl.dart';
import 'package:chat_app_mobile_fe/widgets/chat_displayer/date_seperator.widget.dart';
import 'package:chat_app_mobile_fe/widgets/chat_displayer/displayer_app_bar.widget.dart';
import 'package:chat_app_mobile_fe/widgets/chat_displayer/input.widget.dart';
import 'package:chat_app_mobile_fe/widgets/chat_displayer/unread_message_seperator.widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter/material.dart';
import 'package:chat_app_mobile_fe/widgets/chat_displayer/message_bubble/message_bubble_widget.dart';

class ChatDisplayerScreen extends StatefulWidget {
  final String messageBoxId;
  final String receiverId;
  final String? token;
  final String userName;
  // final bool isOnline;
  const ChatDisplayerScreen({
    super.key,
    required this.receiverId,
    required this.token,
    required this.messageBoxId,
    required this.userName,
  });

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
  String? sendedId;
  Map<String, String?> tempMessageJson = {};

  Future<void> _initUserId() async {
    userId = await SharedPreferencesHelper.getUserId();
  }

  Future<void> _fetchMessageBox() async {
    try {
      final List<MessageResponse> messageBox =
          await ChatServices.getMessageBoxById(widget.messageBoxId);
      List<MessageResponse> uniqueMessages = [];
      String? tempSendedId;
      bool isFirst = false;

      for (int i = 0; i < messageBox.length; i++) {
        if (messageBox[i].type == "video" &&
            messageBox[i].senderId == userId!) {
          if (tempSendedId == null) {
            uniqueMessages.add(messageBox[i]);
            tempSendedId = messageBox[i].sendedId;
          } else {
            tempSendedId = null;
          }
        } else if (messageBox[i].type == "video" &&
            messageBox[i].senderId != userId!) {
          if (isFirst == false) {
            isFirst = true;
            tempSendedId = messageBox[i].sendedId;
          } else if (isFirst == true) {
            isFirst = false;
            tempSendedId = null;
            uniqueMessages.add(messageBox[i]);
          }
        } else if (messageBox[i].type == "text") {
          uniqueMessages.add(messageBox[i]);
        }
      }
      setState(() {
        firstUnreadMessageIndex = uniqueMessages.indexWhere(
            (msg) => msg.state == "chưa đọc" && msg.senderId != userId);

        if (firstUnreadMessageIndex == -1) {
          messages = uniqueMessages.reversed.toList();
          firstUnreadMessageIndex = null;
        } else {
          firstUnreadMessageIndex =
              uniqueMessages.length - firstUnreadMessageIndex! - 1;
          messages = uniqueMessages.reversed.toList();
        }
      });
    } catch (e) {
      print('Failed to fetch messageBox: $e');
    }
  }

  void _scrollToBottom() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.minScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
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

        if (firstUnreadMessageIndex != null) {
          firstUnreadMessageIndex = firstUnreadMessageIndex! + 1;
        }

        final bool isDuplicateAtSender = newMessage.senderId == userId &&
            newMessage.type == "video" &&
            newMessage.sendedId == sendedId;
        final bool isTemporaryMessageFromSender =
            newMessage.senderId != userId &&
                newMessage.type == "video" &&
                newMessage.content == "Đang tải video...";

        if (!isDuplicateAtSender && !isTemporaryMessageFromSender) {
          setState(() {
            messages.insert(0, newMessage);
          });
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollToBottom();
          });
        } else if (tempMessageJson["senderId"] == userId) {
          setState(() {
            messages.insert(0, MessageResponse.fromJson(tempMessageJson));
            tempMessageJson = {};
          });
        }
      } else {
        _markMessagesAsRead();
      }
    });
  }

  void _sendMessage({required String content, String? type}) {
    ChatServices.sendMessage(
        senderId: userId!,
        receiverId: widget.receiverId,
        token: widget.token,
        messageBoxId: widget.messageBoxId,
        content: content,
        type: type,
        channel: channel);

    messageController.clear();
  }

  Future<void> _sendFile(File file) async {
    sendedId = GeneratorUtil.generateRandomString(24);
    final sendedPosition = messages.length;
    final createdAt = CheckDate.formatTime(DateTime.now());
    tempMessageJson = {
      "senderId": userId!,
      "receiverId": widget.receiverId,
      "token": widget.token,
      "messageBoxId": widget.messageBoxId,
      "type": "video",
      "content": 'Đang tải video...',
      "sendedId": sendedId,
      "createdAt": createdAt
    };
    final tempMessage = jsonEncode(tempMessageJson);

    channel.sink.add(tempMessage);

    try {
      String fileUrl = await ChatServices.sendFile(
        senderId: userId!,
        receiverId: widget.receiverId,
        token: widget.token,
        messageBoxId: widget.messageBoxId,
        sendedId: sendedId!,
        file: file,
        channel: channel,
      );

      final updatedMessage = MessageResponse.fromJson(tempMessageJson).copyWith(
          senderId: userId,
          type: "video",
          content: fileUrl,
          createdAt: createdAt);

      await UserService.updateMessageBySendedId(
          messageBoxId: widget.messageBoxId,
          sendedId: sendedId!,
          content: fileUrl);

      setState(() {
        messages[messages.length - sendedPosition - 1] = updatedMessage;
      });

      await Future.delayed(const Duration(milliseconds: 100));
      setState(() {});
    } catch (e) {
      print('Error sending file: $e');
    }
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.isNotEmpty) {
      final file = File(result.files.first.path!);

      _sendFile(file);
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
      appBar: DisplayerAppBarWidget(
        receiverId: widget.receiverId,
        fullName: widget.userName,
        lastStatus: 'last seen at 12:30 PM',
        onBackPressed: () => Navigator.pop(context),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              './assets/img/app/background_for_chat_displayer.jpg',
            ),
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
            // Sử dụng ChatInputWidget
            InputWidget(
              messageController: messageController,
              onSendMessage: (content, type) {
                _sendMessage(content: content, type: type);
              },
              onPickFile: _pickFile,
            ),
          ],
        ),
      ),
    );
  }
}
