import 'package:triplan/src/utils/serializable.dart';

class Group implements Serializable {
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

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['users'] = userIds.map((e) => e.toString()).toList();

    return data;
  }
}
