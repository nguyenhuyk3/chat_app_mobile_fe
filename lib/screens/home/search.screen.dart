// ignore_for_file: avoid_print

import 'package:chat_app_mobile_fe/helpers/shared_preferences_helper.dart';
import 'package:chat_app_mobile_fe/services/user.service.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchHistoryScreenState();
}

class _SearchHistoryScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  late final String? _fromUserEmail;
  late final String? _userId;
  late final String? _sendingInvitationBoxId;
  late final String? _receivingInvitationBoxId;
  List<Map<String, dynamic>> _searchResults = [];
  List<String> _friendEmails = [];
  List<String>? _sendingInvitations = [];
  List<String>? _receivingInvitations = [];

  Future<void> _searchUserByEmail(String email) async {
    if (email.isEmpty) {
      return;
    }

    try {
      final information = await UserService.getInformationByEmail(email);
      if (information != null) {
        final bool isFriend = _friendEmails.contains(information['email']);
        final bool isSendingInvitation =
            _sendingInvitations?.contains(information['email']) ?? false;
        final bool isReceivingInvitation =
            _receivingInvitations?.contains(information['email']) ?? false;

        setState(() {
          _searchResults = [
            {
              'information': {
                'fullName': information['fullName'],
                'email': information['email'],
              },
              'isFriend': isFriend,
              'isSendingInvitation': isSendingInvitation,
              'isReceivingInvitation': isReceivingInvitation,
            }
          ];
        });
      } else {
        setState(() {
          _searchResults = [];
        });
        print("User not found (_searchUserByEmail)");
      }
    } catch (e) {
      print("Error while searching for user (_searchUserByEmail): $e");
    }
  }

  Future<void> _addFriend(String userEmail) async {
    try {
      bool madeFriend = await UserService.addFriend(
        fromUserEmail: _fromUserEmail!,
        toUserEmail: userEmail,
        userId: _userId!,
      );

      if (madeFriend) {
        setState(() {
          _sendingInvitations?.add(userEmail);
          _searchResults = _searchResults.map((user) {
            if (user['information']['email'] == userEmail) {
              return {
                ...user,
                'isSendingInvitation': true,
                'isFriend': false,
              };
            }
            return user;
          }).toList();
        });
      }
    } catch (e) {
      print("Error adding friend (_addFriend): $e");
    }
  }

  Future<void> _initNeededInformation() async {
    final results = await Future.wait([
      SharedPreferencesHelper.getUserId(),
      SharedPreferencesHelper.getUserEmail(),
      SharedPreferencesHelper.getReceivingInvitationBoxId(),
      SharedPreferencesHelper.getSendingInvitationBoxId(),
    ]);

    _userId = results[0];
    _fromUserEmail = results[1];
    _receivingInvitationBoxId = results[2];
    _sendingInvitationBoxId = results[3];
  }

  Future<void> _loadNeededInformation() async {
    _friendEmails = await UserService.loadAllFriendEmails(_userId!);
    _sendingInvitations = await UserService.getEmailsFromInvitationBox(
        "sendingInvitationBoxes", _sendingInvitationBoxId!);
    _receivingInvitations = await UserService.getEmailsFromInvitationBox(
        "receivingInvitationBoxes", _receivingInvitationBoxId!);
    _fromUserEmail = await SharedPreferencesHelper.getUserEmail();
  }

  @override
  void initState() {
    super.initState();

    _initNeededInformation().then((_) => {_loadNeededInformation()});
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tìm kiếm',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF303841),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Container(
        color: const Color(0xFF222831), // Đặt màu nền cho body
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  labelText: 'Nhập email để tìm kiếm',
                  labelStyle: TextStyle(
                    color: Colors.white,
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                  ),
                  suffixIcon: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                ),
                style: const TextStyle(
                  color: Colors.white,
                ),
                onSubmitted: (value) {
                  _searchUserByEmail(value);
                },
              ),
              const SizedBox(height: 20),
              Expanded(
                child: _searchResults.isEmpty
                    ? const Center(
                        child: Text(
                        'Không tìm thấy người dùng',
                        style: TextStyle(color: Colors.white),
                      ))
                    : ListView.builder(
                        itemCount: _searchResults.length,
                        itemBuilder: (context, index) {
                          final user = _searchResults[index];
                          final fullName = user['information']['fullName'];
                          final email = user['information']['email'];
                          final avatarUrl =
                              user['information']['avatar'] as String?;
                          final isFriend = user['isFriend'] ?? false;
                          final isSendingInvitation =
                              user['isSendingInvitation'] ?? false;
                          final isReceivingInvitation =
                              user['isReceivingInvitation'] ?? false;

                          return ListTile(
                            leading: avatarUrl != null
                                ? CircleAvatar(
                                    backgroundImage: NetworkImage(avatarUrl),
                                    radius: 20,
                                  )
                                : const CircleAvatar(
                                    radius: 20,
                                    backgroundColor: Colors.grey,
                                    child: Icon(Icons.person),
                                  ),
                            title: Text(
                              fullName,
                              style: const TextStyle(color: Colors.white),
                            ),
                            subtitle: Text(
                              email,
                              style: const TextStyle(color: Colors.white),
                            ),
                            trailing: isFriend
                                ? const Text(
                                    'Bạn bè',
                                    style: TextStyle(color: Colors.green),
                                  )
                                : isSendingInvitation
                                    ? const Text(
                                        'Đã gửi lời mời',
                                        style: TextStyle(color: Colors.orange),
                                      )
                                    : isReceivingInvitation
                                        ? const Text(
                                            'Đã nhận lời mời',
                                            style:
                                                TextStyle(color: Colors.blue),
                                          )
                                        : IconButton(
                                            icon: const Icon(Icons.person_add),
                                            color: Colors.green,
                                            onPressed: () {
                                              _addFriend(email);
                                            },
                                          ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
