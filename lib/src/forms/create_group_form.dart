import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:triplan/src/models/group.dart';
import 'package:triplan/src/models/user.dart';
import 'package:triplan/src/utils/api_tools.dart';

class CreateGroupForm extends ConsumerStatefulWidget {
  const CreateGroupForm({super.key});

  @override
  CreateGroupFormState createState() {
    return CreateGroupFormState();
  }
}

class CreateGroupFormState extends ConsumerState<CreateGroupForm> {
  final _formKey = GlobalKey<FormState>();

  final nameFieldController = TextEditingController();
  final userSearchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    userSearchController.addListener(() {
      ref.read(searchQueryProvider.notifier).state = userSearchController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    var groupUsers = ref.watch(selectedUsersProvider);
    var query = ref.watch(searchQueryProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('New Group $query'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          // Validate returns true if the form is valid, or false otherwise.
          if (_formKey.currentState!.validate()) {
            Group group = Group(
              id: "",
              name: nameFieldController.text,
              userIds: groupUsers.userIds,
            );

            group = await _createGroup(group);

            if (!mounted) return;
            if (group.id != "") {
              GoRouter.of(context).goNamed(
                "groups_detail",
                params: {"group_id": group.id},
              );
            }
          }
        },
        backgroundColor: Colors.green,
        icon: const Icon(Icons.check),
        label: const Text("Create Group"),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                autofocus: true,
                decoration: const InputDecoration(label: Text("group name")),
                controller: nameFieldController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: groupUsers.count,
                itemBuilder: ((context, index) {
                  final user = groupUsers.items[index];
                  return ListTile(
                    leading: const Icon(Icons.person),
                    title: Text(user.name),
                    trailing: IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () => groupUsers.remove(user),
                    ),
                  );
                }),
              ),
              Expanded(
                child: Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => userSearchController.clear(),
                        ),
                        hintText: "Add members",
                      ),
                      controller: userSearchController,
                    ),
                    Expanded(
                      child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 32.0,
                          ),
                          child: _buildSearchResultList(ref)),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchResultList(WidgetRef ref) {
    List<User> results = ref.watch(searchResultProvider);
    return ListView.builder(
        itemCount: results.length,
        itemBuilder: (BuildContext context, int index) {
          return _buildSearchResultRow(ref, results[index]);
        });
  }

  Widget _buildSearchResultRow(WidgetRef ref, User u) {
    return ListTile(
      title: Text(u.name),
      subtitle: Text(u.id),
      onTap: () {
        ref.read(selectedUsersProvider).add(u);
        userSearchController.clear();
      },
    );
  }

  Future<Group> _createGroup(Group group) async {
    return createNew("/groups", group, Group.fromJson);
  }
}

final searchQueryProvider = StateProvider((ref) => '');

final searchResultProvider =
    StateNotifierProvider<SearchResultNotifier, List<User>>(
        (ref) => SearchResultNotifier(ref.watch(searchQueryProvider)));

class SearchResultNotifier extends StateNotifier<List<User>> {
  SearchResultNotifier(String query) : super([]) {
    if (query == "") {
      return;
    }

    fetchAndDecodeList(
      "/users?name=$query",
      (l) => l.map((e) => User.fromJson(e)).toList(),
    ).then((value) => state = value);
  }
}

final selectedUsersProvider = ChangeNotifierProvider<SelectedUsersNotifier>(
    (ref) => SelectedUsersNotifier());

class SelectedUsersNotifier extends ChangeNotifier {
  List<User> _selectedUsers = [];

  List<User> get items => _selectedUsers;
  int get count => _selectedUsers.length;
  List<String> get userIds => _selectedUsers.map((u) => u.id).toList();

  add(User user) {
    if (_selectedUsers.map((e) => e.id).contains(user.id)) {
      // already present in selected list
      return;
    }
    _selectedUsers = [..._selectedUsers, user];
    notifyListeners();
  }

  remove(User user) {
    removeById(user.id);
  }

  removeById(String userId) {
    _selectedUsers.removeWhere((u) => u.id == userId);
    notifyListeners();
  }
}
