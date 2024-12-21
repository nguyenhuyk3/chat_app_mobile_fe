import 'package:chat_app_mobile_fe/bloc/chat/chat_home/chat_list/chat_list.bloc.dart';
import 'package:chat_app_mobile_fe/bloc/chat/chat_home/chat_list/chat_list.state.dart';
import 'package:chat_app_mobile_fe/screens/chat/media_call.screen.dart';
import 'package:chat_app_mobile_fe/services/webrtc.services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class DisplayerAppBarWidget extends StatelessWidget
    implements PreferredSizeWidget {
  final WebSocketChannel? channel;
  final String messageBoxId;
  final String? userId;
  final String receiverId;
  final String fullName;
  final String? token;
  final VoidCallback onBackPressed;

  const DisplayerAppBarWidget({
    super.key,
    required this.channel,
    required this.messageBoxId,
    required this.userId,
    required this.receiverId,
    required this.fullName,
    required this.token,
    required this.onBackPressed,
  });

  void _onVideoCallPressed(BuildContext context) async {
    // try {
    final webRtcService = WebrtcServices();
    await webRtcService.createOffer(
      callType: "both",
      messageBoxId: messageBoxId,
      senderId: userId!,
      receiverId: receiverId,
      token: token,
      channel: channel!,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MediaCallScreen(
          peerConnection: webRtcService.peerConnection,
          channel: channel!,
          callType: "both",
          messageBoxId: messageBoxId,
          realSenderId: userId,
          senderId: userId!,
          receiverId: receiverId,
          receiverName: fullName,
          token: token,
          isAtForeground: false,
        ),
      ),
    );
    // } catch (e) {
    //   print("Error starting video call: $e");
    // }
  }

  void _onAudioCallPressed(BuildContext context) async {
    // try {
    final webRtcService = WebrtcServices();
    await webRtcService.createOffer(
      callType: "audio",
      messageBoxId: messageBoxId,
      senderId: userId!,
      receiverId: receiverId,
      token: token,
      channel: channel!,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MediaCallScreen(
          peerConnection: webRtcService.peerConnection,
          channel: channel!,
          callType: "audio",
          messageBoxId: messageBoxId,
          realSenderId: userId,
          senderId: userId!,
          receiverId: receiverId,
          receiverName: fullName,
          token: token,
          isAtForeground: false,
        ),
      ),
    );
    // } catch (e) {
    //   print("Error starting video call: $e");
    // }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatListBloc, ChatListState>(
      builder: (context, state) {
        bool isOnline =
            state is ChatLoaded && state.onlineFriendIds.contains(receiverId);
        return AppBar(
          backgroundColor: const Color(0xFF303841),
          elevation: 1,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: onBackPressed,
          ),
          titleSpacing: 0,
          title: Row(
            children: [
              Stack(children: [
                const Icon(
                  Icons.account_circle_sharp,
                  color: Colors.white,
                  size: 44,
                ),
                if (isOnline)
                  Positioned(
                    right: 2,
                    bottom: 0,
                    child: Container(
                      width: 15,
                      height: 15,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF31363F),
                          width: 3,
                        ),
                      ),
                    ),
                  ),
              ]),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fullName,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      "",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            Container(
              padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
              width: 40,
              child: IconButton(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                icon: const Icon(
                  Icons.call,
                  color: Colors.white,
                  size: 25,
                ),
                onPressed: () => {
                  _onAudioCallPressed(context),
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
              width: 40,
              child: IconButton(
                padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                icon: const Icon(
                  Icons.videocam,
                  color: Colors.white,
                  size: 25,
                ),
                onPressed: () => {
                  _onVideoCallPressed(context),
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
              width: 40,
              child: IconButton(
                padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                icon: const Icon(
                  Icons.more_vert,
                  color: Colors.white,
                  size: 25,
                ),
                onPressed: () {},
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(62);
}
