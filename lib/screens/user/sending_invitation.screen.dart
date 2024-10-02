import 'package:chat_app_mobile_fe/models/friend_request.dart';
import 'package:chat_app_mobile_fe/models/from_user_infor.dart';
import 'package:flutter/material.dart';

class SendingInvitationScreen extends StatefulWidget {
  const SendingInvitationScreen({super.key});

  @override
  State<SendingInvitationScreen> createState() =>
      _SendingInvitationScreenState();
}

class _SendingInvitationScreenState extends State<SendingInvitationScreen> {
  @override
  Widget build(BuildContext context) {
    final List<FriendRequest> friendRequests = [
      FriendRequest(
        fromUserInfor: FromUserInfor(
          fromUserEmail: 'huy123@gmail.com',
          fromUserName: 'Huy Nguyen',
        ),
        toUserEmail: 'recipient1@example.com',
        status: "pending",
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      FriendRequest(
        fromUserInfor: FromUserInfor(
          fromUserEmail: 'huy123@gmail.com',
          fromUserName: 'Huy Nguyen',
        ),
        toUserEmail: 'recipient2@example.com',
        status: "pending",
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      FriendRequest(
        fromUserInfor: FromUserInfor(
          fromUserEmail: 'huy123@gmail.com',
          fromUserName: 'Huy Nguyen',
        ),
        toUserEmail: 'recipient3@example.com',
        status: "pending",
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
    ];

    return Align(
      child: ListView.builder(
        itemCount: friendRequests.length,
        itemBuilder: (context, index) {
          FriendRequest request = friendRequests[index];
          return ListTile(
            leading: const Icon(Icons.person_add_alt_1),
            title: Text(request.toUserEmail), // Hiển thị toUserEmail
            subtitle: Text(request.fromUserInfor.fromUserEmail), // Hiển thị fromUserEmail
            trailing: ElevatedButton(
              onPressed: () {
                // Hành động khi hủy lời mời
                _cancelFriendRequest(index);
              },
              child: const Text('Hủy'),
            ),
            onTap: () {
              print('Đã chọn ${request.toUserEmail}');
            },
          );
        },
      ),
    );
  }

  void _cancelFriendRequest(int index) {
    // Xử lý hủy lời mời
    // Có thể cập nhật giao diện ở đây nếu cần
    print('Đã hủy lời mời tới ${index}'); // Hoặc hiển thị thông tin cụ thể
  }
}
