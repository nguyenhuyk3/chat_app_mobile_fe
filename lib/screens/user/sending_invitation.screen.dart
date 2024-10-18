import 'package:chat_app_mobile_fe/models/friend_request.dart';
import 'package:chat_app_mobile_fe/services/user.service.dart';
import 'package:flutter/material.dart';

class SendingInvitationScreen extends StatefulWidget {
  const SendingInvitationScreen({super.key});

  @override
  State<SendingInvitationScreen> createState() =>
      _SendingInvitationScreenState();
}

class _SendingInvitationScreenState extends State<SendingInvitationScreen> {
  void onDeletePressed(
      String toUserEmail, int index, List<FriendRequest> invitations) async {
    try {
      await UserService.deleteSendingInvitation(toUserEmail);

      setState(
        () {
          invitations.removeAt(index);
        },
      );

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đã xóa lời mời kết bạn'),
        ),
      );
    } catch (error) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi: $error'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF222831),
      child: FutureBuilder<List<FriendRequest>>(
        future: UserService.getAllInvitations("sending_invitation_box"),
        builder: (BuildContext context,
            AsyncSnapshot<List<FriendRequest>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            List<FriendRequest> invitations = snapshot.data!;

            return ListView.builder(
              itemCount: invitations.length,
              itemBuilder: (context, index) {
                FriendRequest invitation = invitations[index];

                return ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.grey,
                    radius: 20,
                    child: Icon(
                      Icons.account_circle_sharp,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  title: Text(
                    invitation.fromUserInfor.fromUserName,
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    invitation.toUserEmail,
                    style: const TextStyle(color: Colors.white),
                  ),
                  trailing: ElevatedButton(
                    onPressed: () {
                      onDeletePressed(
                          invitation.toUserEmail, index, invitations);
                    },
                    child: const Text(
                      'Xóa',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  onTap: () {
                    print('Đã chọn ${invitation.toUserEmail}');
                  },
                );
              },
            );
          } else {
            return const Center(
              child: Text(
                'Bạn chưa thực hiện lời gửi kết bạn nào',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.white),
              ),
            );
          }
        },
      ),
    );
  }
}
