import 'package:chat_app_mobile_fe/bloc/chat/chat_home/chat_list/chat_list.bloc.dart';
import 'package:chat_app_mobile_fe/bloc/chat/chat_home/chat_list/chat_list.state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'chat_element_widget.dart';

class ChatListWidget extends StatelessWidget {
  const ChatListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatListBloc(),
      child: Scaffold(
        backgroundColor: const Color(0xFF222831),
        body: BlocBuilder<ChatListBloc, ChatListState>(
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
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
