import 'package:chat_app_mobile_fe/bloc/chat/chat_home/chat_list/chat_list.bloc.dart';
import 'package:chat_app_mobile_fe/bloc/chat/chat_home/chat_list/chat_list.state.dart';
import 'package:chat_app_mobile_fe/screens/chat/chat_displayer_sceen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'chat_element_widget.dart';

class ChatListWidget extends StatelessWidget {
  const ChatListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF222831),
      body: BlocBuilder<ChatListBloc, ChatListState>(
        buildWhen: (previous, current) {
          print("Previous state: $previous");
          print("Current state: $current");
          return true;
        },
        builder: (context, state) {
          if (state is ChatLoaded) {
            return ListView.builder(
              itemCount: state.messageBoxes.length,
              itemBuilder: (context, index) {
                String notCurrentUserId =
                    state.messageBoxes[index].firstInforUser.id !=
                            context.read<ChatListBloc>().userId
                        ? state.messageBoxes[index].firstInforUser.id
                        : state.messageBoxes[index].secondInforUser.id;

                return ChatElementWidget(
                  key: ValueKey(state.messageBoxes[index].messageBoxId),
                  messageBoxId: state.messageBoxes[index].messageBoxId,
                  receiverId: notCurrentUserId,
                  isOnline: state.onlineFriendIds.contains(notCurrentUserId),
                  messageBoxReponse: state.messageBoxes[index],
                );
              },
            );
          } else if (state is CallInitiated) {
            WidgetsBinding.instance.addPostFrameCallback(
              (_) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatDisplayerScreen(
                      messageBoxId: state.messageBoxId,
                      receiverId: state.receiverId,
                      userName: state.receiverName,
                      token: state.token,
                      isCallAtForeground: true,
                      onPopCallback: () {
                        print("Refreshing chat list...");
                        Navigator.pop(context);
                        context.read<ChatListBloc>().refreshChatList();
                      },
                    ),
                  ),
                );
              },
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
