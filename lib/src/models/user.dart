class User {
  const User({required this.id, required this.name});

  final String id;
  final String name;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
    );
  }
}
