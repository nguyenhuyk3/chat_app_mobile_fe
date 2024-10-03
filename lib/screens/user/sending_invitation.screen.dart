import 'package:chat_app_mobile_fe/models/friend_request.dart';
import 'package:chat_app_mobile_fe/services/user_service.dart';
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
    return FutureBuilder<List<FriendRequest>>(
      future: UserService.getAllInvitations("sending_invitation_box"),
      builder:
          (BuildContext context, AsyncSnapshot<List<FriendRequest>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          List<FriendRequest> invitations = snapshot.data!;

          return Align(
            child: ListView.builder(
              itemCount: invitations.length,
              itemBuilder: (context, index) {
                FriendRequest invitation = invitations[index];

                return ListTile(
                  leading: const Icon(Icons.person_add_alt_1),
                  title: Text(invitation.toUserEmail),
                  subtitle: Text(invitation.fromUserInfor.fromUserEmail),
                  trailing: ElevatedButton(
                    onPressed: () {
                      _cancelFriendRequest(index);
                    },
                    child: const Text('Hủy'),
                  ),
                  onTap: () {
                    print('Đã chọn ${invitation.toUserEmail}');
                  },
                );
              },
            ),
          );
        } else {
          return Text("No invitations found.");
        }
      },
    );
  }

  void _cancelFriendRequest(int index) {
    // Xử lý hủy lời mời
    // Có thể cập nhật giao diện ở đây nếu cần
    print('Đã hủy lời mời tới ${index}'); // Hoặc hiển thị thông tin cụ thể
  }
}
