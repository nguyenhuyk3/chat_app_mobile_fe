import 'package:chat_app_mobile_fe/bloc/chat/chat_home/chat_list/chat_list.event.dart';
import 'package:chat_app_mobile_fe/bloc/chat/chat_home/chat_list/chat_list.state.dart';
import 'package:chat_app_mobile_fe/global/global_var.dart';
import 'package:chat_app_mobile_fe/helpers/shared_preferences_helper.dart';
import 'package:chat_app_mobile_fe/models/response/all_message_boxes.response.dart';
import 'package:chat_app_mobile_fe/models/response/last_state_for_message_box_on_master_room.response.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';

class ChatListBloc extends Bloc<ChatListEvent, ChatListState> {
  late IOWebSocketChannel _channel;
  late String? _userId;

  String? get userId => _userId;

  Future<void> _initUserId() async {
    _userId = await SharedPreferencesHelper.getUserId();
  }

  ChatListBloc() : super(ChatInitial()) {
    _initUserId().then((_) => add(LoadMessageBoxes()));

    on<LoadMessageBoxes>(_onLoadMessageBoxes);
    on<UpdateOnlineFriends>(_onUpdateOnlineFriends);
    on<UpdateFriendStatus>(_onUpdateFriendStatus);
    on<UpdateLastStateForMessageBox>(_onUpdateLastStateForMessageBox);
  }

  void _initializeWebSocket() {
    String url =
        "${GlobalVar.websocketBaseUrl}/join_master_room?user_id=$_userId";

    _channel = IOWebSocketChannel.connect(Uri.parse(url));
    _channel.stream.listen((dynamic data) {
      final jsonData = jsonDecode(data);

      print(jsonData);

      if (jsonData["type"] == "onlineFriends") {
        add(UpdateOnlineFriends(List<String>.from(jsonData["friends"])));
      } else if (jsonData["isOnline"] != null) {
        add(UpdateFriendStatus(jsonData["userId"], jsonData["isOnline"]));
      } else if (jsonData["isLastStateStruct"] != null) {
        add(UpdateLastStateForMessageBox(
            lastStateForMessageBoxOnMasterRoom:
                LastStateForMessageBoxOnMasterRoom.fromJson(jsonData)));
      }
    });
  }

  Future<void> _onLoadMessageBoxes(
      LoadMessageBoxes event, Emitter<ChatListState> emit) async {
    String url =
        "${GlobalVar.httpBaseUrl}/users/get_all_message_boxes?user_id=$_userId";
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body) as Map<String, dynamic>;

        List<MessageBoxResponse> messageBoxes =
            MessageBoxResponse.parseJsonDataToList(jsonData);

        emit(ChatLoaded(messageBoxes: messageBoxes, onlineFriendIds: {}));

        _initializeWebSocket();
      }
    } catch (error) {
      print('Error fetching message boxes: $error');
    }
  }

  void _onUpdateOnlineFriends(
      UpdateOnlineFriends event, Emitter<ChatListState> emit) {
    final currentState = state;

    if (currentState is ChatLoaded) {
      emit(ChatLoaded(
          messageBoxes: currentState.messageBoxes,
          onlineFriendIds: event.friends.toSet()));
    }
  }

  void _onUpdateFriendStatus(
      UpdateFriendStatus event, Emitter<ChatListState> emit) {
    final currentState = state;

    if (currentState is ChatLoaded) {
      final updatedFriends = Set<String>.from(currentState.onlineFriendIds);

      if (event.isOnline) {
        updatedFriends.add(event.userId);
      } else {
        updatedFriends.remove(event.userId);
      }

      emit(ChatLoaded(
          messageBoxes: currentState.messageBoxes,
          onlineFriendIds: updatedFriends));
    }
  }

  void _onUpdateLastStateForMessageBox(
      UpdateLastStateForMessageBox event, Emitter<ChatListState> emit) {
    final currentState = state;

    if (currentState is ChatLoaded) {
      final String messageBoxId =
          event.lastStateForMessageBoxOnMasterRoom.messageBoxId;
      final lastState = event.lastStateForMessageBoxOnMasterRoom;

      print("cncak");
      print(_userId);
      print(lastState.lastMessage);
      print(lastState.lastStatus);
      print(event.lastStateForMessageBoxOnMasterRoom.senderId);
      for (var messageBox in currentState.messageBoxes) {
        if (messageBoxId == messageBox.messageBoxId) {
          final String senderId =
              event.lastStateForMessageBoxOnMasterRoom.senderId;
          final String firstUserId =
              messageBox.lastStateMessageForFirstUser.userId;
          final targetUser = senderId != firstUserId
              ? messageBox.lastStateMessageForSecondUser
              : messageBox.lastStateMessageForFirstUser;
          targetUser
            ..lastMessage = lastState.lastMessage
            ..lastTime = lastState.lastTime
            ..lastStatus = lastState.lastStatus;
          late final LastStateMessage currentUser;

          if (_userId == messageBox.lastStateMessageForFirstUser.userId) {
            currentUser = messageBox.lastStateMessageForFirstUser;
          } else {
            currentUser = messageBox.lastStateMessageForSecondUser;
          }

          currentUser
            ..lastMessage = lastState.lastMessage
            ..lastTime = lastState.lastTime
            ..lastStatus = "đã đọc";
          break;
        }

        emit(ChatLoaded(
            messageBoxes: currentState.messageBoxes,
            onlineFriendIds: currentState.onlineFriendIds));
      }
    }

    @override
    Future<void> close() {
      // _channel.sink.close();

      return super.close();
    }
  }
}
