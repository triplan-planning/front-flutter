import 'package:triplan/src/utils/serializable.dart';

class User implements Serializable {
  const User({required this.id, required this.name});

  final String id;
  final String name;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;

    return data;
  }

  @override
  String toString() {
    return 'User($name,$id)';
  }

  @override
  bool operator ==(Object other) {
    return other is User && other.id == id && other.name == name;
  }
}
