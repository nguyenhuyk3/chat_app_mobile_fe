class ChatRoom {
  final String _id;
  final bool isGroups;
  final List<String> _members;
  final String _createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  ChatRoom({
    required String id,
    required this.isGroups,
    required List<String> members,
    required String createdBy,
    required this.createdAt,
    required this.updatedAt,
  })  : _id = id,
        _members = members,
        _createdBy = createdBy;

  String get id => _id;
  List<String> get members => _members;
  String get createdBy => _createdBy;

  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'isGroups': isGroups,
      'members': _members,
      'createdBy': _createdBy,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
