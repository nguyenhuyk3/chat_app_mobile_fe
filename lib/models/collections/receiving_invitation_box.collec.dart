import 'package:chat_app_mobile_fe/models/friend_request.dart';

class ReceivingInvitationBox {
  final List<FriendRequest> _friendRequests;

  ReceivingInvitationBox({List<FriendRequest>? friendRequests})
      : _friendRequests = friendRequests ?? [];

  List<FriendRequest> get friendRequests => _friendRequests;

  Map<String, dynamic> toJson() {
    return {
      'friendRequests':
          _friendRequests.map((request) => request.toJson()).toList(),
    };
  }

  factory ReceivingInvitationBox.fromJson(Map<String, dynamic> json) {
    return ReceivingInvitationBox(
      friendRequests: (json['friendRequests'] as List)
          .map((item) => FriendRequest.fromJson(item))
          .toList(),
    );
  }
}
