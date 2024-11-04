import 'package:chat_app_mobile_fe/models/friend_request.dart';
import 'package:chat_app_mobile_fe/services/user.service.dart';
import 'package:flutter/material.dart';

class ReceivingInvitationScreen extends StatefulWidget {
  const ReceivingInvitationScreen({super.key});

  @override
  State<ReceivingInvitationScreen> createState() =>
      _ReceivingInvitationScreenState();
}

class _ReceivingInvitationScreenState extends State<ReceivingInvitationScreen> {
  void onDeletePressed(
      String fromUserEmail, int index, List<FriendRequest> invitations) async {
    try {
      await UserService.deleteReceivingInvitation(fromUserEmail);

      setState(
        () {
          invitations.removeAt(index);
        },
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã xóa lời mời kết bạn')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: $error')),
      );
    }
  }

  void onAcceptPressed(
      String fromUserEmail, int index, List<FriendRequest> invitations) async {
    try {
      await UserService.acceptInvitation(fromUserEmail);

      setState(() {
        invitations.removeAt(index);
      });

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã chấp nhận lời mời kết bạn')),
      );
    } catch (error) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF222831),
      child: FutureBuilder<List<FriendRequest>>(
        future: UserService.getAllInvitations("receiving_invitation_box"),
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

                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.teal,
                              child: Text(
                                invitation.fromUserInfor.fromUserName[0]
                                    .toUpperCase(),
                                style: const TextStyle(
                                    fontSize: 24, color: Colors.white),
                              ),
                            ),
                            const SizedBox(width: 13),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    invitation.fromUserInfor.fromUserName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    invitation.fromUserInfor.fromUserEmail,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.grey[400],
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Gửi lúc: ${invitation.createdAt}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                            Row(
                              children: [
                                ElevatedButton(
                                  onPressed: () => onAcceptPressed(
                                    invitation.fromUserInfor.fromUserEmail,
                                    index,
                                    invitations,
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF1F8A70),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  child: const Text(
                                    'Chấp nhận',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                OutlinedButton(
                                  onPressed: () => onDeletePressed(
                                    invitation.fromUserInfor.fromUserEmail,
                                    index,
                                    invitations,
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  child: const Text(
                                    'Xóa',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                });
          } else {
            return const Center(
              child: Text(
                'Bạn không nhận được lời mời kết bạn nào',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
