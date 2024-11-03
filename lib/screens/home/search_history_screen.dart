import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchHistoryScreen extends StatefulWidget {
  const SearchHistoryScreen({super.key});

  @override
  State<SearchHistoryScreen> createState() => _SearchHistoryScreenState();
}

class _SearchHistoryScreenState extends State<SearchHistoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<Map<String, dynamic>> _searchResults = [];
  List<String> _friends = [];
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = _auth.currentUser;
    _loadFriends();
  }

  Future<void> _loadFriends() async {
    final currentUserEmail = _currentUser?.email ?? '';
    if (currentUserEmail.isEmpty) return;

    final userDoc = await _firestore
        .collection('users')
        .where('email', isEqualTo: currentUserEmail)
        .limit(1)
        .get();
    if (userDoc.docs.isNotEmpty) {
      setState(() {
        _friends =
            List<String>.from(userDoc.docs.first.data()?['friends'] ?? []);
      });
      print("Danh sách bạn bè của người dùng: $_friends");
    }
  }

  Future<void> _searchUserByEmail(String email) async {
    try {
      await _loadFriends();

      final querySnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      setState(() {
        _searchResults = querySnapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id;

          // Check if the email is huy1@gmail.com to show "Kết bạn"
          data['showKetBan'] = data['email'] == 'huy1@gmail.com';

          // Check friend status
          data['isFriend'] = _friends.contains(data['email']);
          return data;
        }).toList();
      });
    } catch (e) {
      print("Lỗi khi tìm kiếm người dùng: $e");
    }
  }

  Future<void> _addFriend(String userEmail) async {
    try {
      if (_currentUser == null) return;
      final currentUserEmail = _currentUser!.email!;
      final userDoc = await _firestore
          .collection('users')
          .where('email', isEqualTo: currentUserEmail)
          .limit(1)
          .get();

      if (userDoc.docs.isNotEmpty) {
        final currentUserName = userDoc.docs.first.data()?['information']
                ?['fullName'] ??
            'Người dùng không có tên';

        final url = Uri.parse('http://10.0.2.2:8080/users/make_friend');
        final requestBody = {
          "fromUserInfor": {
            "fromUserEmail": currentUserEmail,
            "fromUserName": currentUserName,
          },
          "toUserEmail": userEmail,
          "status": "pending"
        };

        final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(requestBody),
        );

        if (response.statusCode == 200) {
          setState(() {
            _friends.add(userEmail);
          });
          print("Đã gửi yêu cầu kết bạn thành công.");
        } else {
          print("Không thể gửi yêu cầu kết bạn: ${response.body}");
        }
      }
    } catch (e) {
      print("Lỗi khi gửi yêu cầu kết bạn: $e");
    }
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
        title: const Text('Tìm kiếm'),
        backgroundColor: const Color.fromARGB(255, 237, 244, 247),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Nhập email để tìm kiếm',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
              onSubmitted: (value) {
                _searchUserByEmail(value);
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _searchResults.isEmpty
                  ? const Center(child: Text('Không tìm thấy người dùng.'))
                  : ListView.builder(
                      itemCount: _searchResults.length,
                      itemBuilder: (context, index) {
                        final user = _searchResults[index];
                        final fullName =
                            user['information']?['fullName'] as String? ??
                                'Không có tên';
                        final email =
                            user['email'] as String? ?? 'Không có email';
                        final avatarUrl = user['avatar'] as String?;
                        final isFriend = user['isFriend'] ?? false;

                        return ListTile(
                          leading: avatarUrl != null
                              ? CircleAvatar(
                                  backgroundImage: NetworkImage(avatarUrl),
                                  radius: 20,
                                )
                              : const CircleAvatar(
                                  child: Icon(Icons.person),
                                  radius: 20,
                                ),
                          title: Text(fullName),
                          subtitle: Text(email),
                          trailing: isFriend
                              ? const Text(
                                  'Bạn bè',
                                  style: TextStyle(color: Colors.green),
                                )
                              : user['showKetBan'] == true
                                  ? const Text(
                                      'Bạn bè',
                                      style: TextStyle(color: Colors.green),
                                    )
                                  : IconButton(
                                      icon: const Icon(Icons.person_add),
                                      color: Colors.green,
                                      onPressed: () => _addFriend(email),
                                    ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
