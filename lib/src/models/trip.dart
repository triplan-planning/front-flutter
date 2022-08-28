class Trip {
  const Trip({required this.id, required this.name, required this.userIds});

  final String id;
  final String name;
  final List<String> userIds;

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      id: json['id'],
      name: json['name'],
      userIds: (json['users'] as List<dynamic>).cast<String>(),
    );
  }
}
