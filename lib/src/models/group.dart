class Group {
  const Group({required this.id, required this.name, required this.userIds});

  final String id;
  final String name;
  final List<String> userIds;

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['id'],
      name: json['name'],
      userIds: (json['users'] as List<dynamic>).cast<String>(),
    );
  }
}
