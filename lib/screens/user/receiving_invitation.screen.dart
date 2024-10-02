import 'package:chat_app_mobile_fe/models/friend_request.dart';
import 'package:chat_app_mobile_fe/models/from_user_infor.dart';
import 'package:flutter/material.dart';

class ReceivingInvitationScreen extends StatefulWidget {
  const ReceivingInvitationScreen({super.key});

  @override
  State<ReceivingInvitationScreen> createState() =>
      _ReceivingInvitationScreenState();
}

class _ReceivingInvitationScreenState extends State<ReceivingInvitationScreen> {
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
        fromUserEmail: 'example@gmail.com',
        fromUserName: 'Example User',
      ),
      toUserEmail: 'recipient2@example.com',
      status: "pending",
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    FriendRequest(
      fromUserInfor: FromUserInfor(
        fromUserEmail: 'test@gmail.com',
        fromUserName: 'Test User',
      ),
      toUserEmail: 'recipient3@example.com',
      status: "pending",
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
  ];

  void _acceptFriendRequest(int index) {
    setState(() {
      friendRequests[index].status = "accepted";
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã chấp nhận ${friendRequests[index].fromUserInfor.fromUserEmail}'),
      ),
    );
  }

  void _deleteFriendRequest(int index) {
    final removedEmail = friendRequests[index].fromUserInfor.fromUserEmail; // Lưu lại email đã xóa
    setState(() {
      friendRequests.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã xóa lời mời từ $removedEmail'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: friendRequests.length,
      itemBuilder: (context, index) {
        final friendRequest = friendRequests[index];
        return Card(
          child: ListTile(
            title: Text(friendRequest.fromUserInfor.fromUserEmail), // Sử dụng từ UserInfor
            subtitle: Text('Trạng thái: ${friendRequest.status}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _acceptFriendRequest(index);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: const Text('Chấp nhận'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    _deleteFriendRequest(index);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: const Text('Xóa'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
