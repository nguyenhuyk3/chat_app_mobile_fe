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
    on<MarkMessageAsRead>(_onMarkMessageAsRead);
  }

  void _initializeWebSocket() {
    String url =
        "${GlobalVar.websocketBaseUrl}/join_master_room?user_id=$_userId";

    _channel = IOWebSocketChannel.connect(Uri.parse(url));
    _channel.stream.listen((dynamic data) {
      final jsonData = jsonDecode(data);

      print("concakkkkkkkkkkkk");
      print(jsonData);

      if (jsonData["type"] == "onlineFriends") {
        add(UpdateOnlineFriends(List<String>.from(jsonData["friends"])));
      } else if (jsonData["isOnline"] != null) {
        add(UpdateFriendStatus(
            userId: jsonData["userId"],
            isOnline: jsonData["isOnline"],
            tokenDevice: jsonData["tokenDevice"]));
      } else if (jsonData["isLastStateStruct"] != null) {
        add(UpdateLastStateForMessageBox(
            lastStateForMessageBoxOnMasterRoom:
                LastStateForMessageBoxOnMasterRoom.fromJson(jsonData)));
      } else if (jsonData["fromUserEmail"] != null &&
          jsonData["fromUserName"] != null) {
        add(LoadMessageBoxes());
      }
    });
  }

  void _sortMessageBox({
    required List<MessageBoxResponse> messageBoxes,
    required String userId,
  }) {
    // print(
    //     "Before sorting: ${messageBoxes.map((box) => userId == box.lastStateMessageForFirstUser.userId ? box.lastStateMessageForFirstUser.toJson() : box.lastStateMessageForSecondUser.toJson())}");
    messageBoxes.sort((a, b) {
      DateTime getLastTime(MessageBoxResponse box) {
        final lastState = box.lastStateMessageForFirstUser.userId == userId
            ? box.lastStateMessageForFirstUser
            : box.lastStateMessageForSecondUser;
        return DateTime.parse(lastState.lastTime);
      }

      return getLastTime(b).compareTo(getLastTime(a));
    });
    // print(
    //     "After sorting: ${messageBoxes.map((box) => userId == box.lastStateMessageForFirstUser.userId ? box.lastStateMessageForFirstUser.toJson() : box.lastStateMessageForSecondUser.toJson())}");
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

        _sortMessageBox(messageBoxes: messageBoxes, userId: _userId!);
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
          onlineFriendIds: updatedFriends,
          onlineUserId: event.userId));
    }
  }

  void _onUpdateLastStateForMessageBox(
      UpdateLastStateForMessageBox event, Emitter<ChatListState> emit) {
    final currentState = state;

    if (currentState is ChatLoaded) {
      final String messageBoxId =
          event.lastStateForMessageBoxOnMasterRoom.messageBoxId;
      final lastState = event.lastStateForMessageBoxOnMasterRoom;

      for (var messageBox in currentState.messageBoxes) {
        if (messageBoxId == messageBox.messageBoxId) {
          final String firstUserId =
              messageBox.lastStateMessageForFirstUser.userId;
          final targetUser = _userId == firstUserId
              ? messageBox.lastStateMessageForFirstUser
              : messageBox.lastStateMessageForSecondUser;
          targetUser
            ..lastMessage = lastState.lastMessage
            ..lastTime = lastState.lastTime
            ..lastStatus = lastState.lastStatus;
          break;
        }
      }
      final sortedMessageBoxes =
          List<MessageBoxResponse>.from(currentState.messageBoxes);
      _sortMessageBox(messageBoxes: sortedMessageBoxes, userId: userId!);
      emit(ChatLoaded(
          messageBoxes: sortedMessageBoxes,
          onlineFriendIds: currentState.onlineFriendIds));
    }
  }

  void _onMarkMessageAsRead(
      MarkMessageAsRead event, Emitter<ChatListState> emit) {
    final currentState = state;
    if (currentState is ChatLoaded) {
      String messageBoxId = event.messageBoxId;
      for (var messageBox in currentState.messageBoxes) {
        if (messageBox.messageBoxId == messageBoxId) {
          final String firstUserId =
              messageBox.lastStateMessageForFirstUser.userId;
          final targetUser = firstUserId == event.userId
              ? messageBox.lastStateMessageForFirstUser
              : messageBox.lastStateMessageForSecondUser;
          targetUser.lastStatus = "đã đọc";

          break;
        }
      }
    }
  }

  @override
  Future<void> close() {
    // _channel.sink.close();

    return super.close();
  }
}
