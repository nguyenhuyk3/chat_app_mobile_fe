import 'package:chat_app_mobile_fe/models/friend_request.dart';
import 'package:chat_app_mobile_fe/services/user_service.dart';
import 'package:flutter/material.dart';

class ReceivingInvitationScreen extends StatefulWidget {
  const ReceivingInvitationScreen({super.key});

  @override
  State<ReceivingInvitationScreen> createState() =>
      _ReceivingInvitationScreenState();
}

class _ReceivingInvitationScreenState extends State<ReceivingInvitationScreen> {
  // void _acceptFriendRequest(int index) {
  //   setState(() {
  //     friendRequests[index].status = "accepted";
  //   });

  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text(
  //           'Đã chấp nhận ${friendRequests[index].fromUserInfor.fromUserEmail}'),
  //     ),
  //   );
  // }

  // void _deleteFriendRequest(int index) {
  //   final removedEmail = friendRequests[index]
  //       .fromUserInfor
  //       .fromUserEmail; // Lưu lại email đã xóa
  //   setState(() {
  //     friendRequests.removeAt(index);
  //   });

  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text('Đã xóa lời mời từ $removedEmail'),
  //     ),
  //   );
  // }

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

          return ListView.builder(
            itemCount: invitations.length,
            itemBuilder: (context, index) {
              FriendRequest invitation = invitations[index];

              return Card(
                child: ListTile(
                  title: Text(invitation.fromUserInfor.fromUserEmail),
                  subtitle: Text('Trạng thái: ${invitation.status}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // _acceptFriendRequest(index);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        child: const Text('Chấp nhận'),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          // _deleteFriendRequest(index);
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
        } else {
          return const Text("No invitations found.");
        }
      },
    );
  }
}
