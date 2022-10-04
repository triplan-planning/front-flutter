import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';
import 'package:triplan/src/models/group.dart';
import 'package:triplan/src/utils/api_tools.dart';

class CreateGroupForm extends StatefulWidget {
  static const routeName = '/groups/new';

  const CreateGroupForm({super.key});

  @override
  CreateGroupFormState createState() {
    return CreateGroupFormState();
  }
}

class CreateGroupFormState extends State<CreateGroupForm> {
  final _formKey = GlobalKey<FormState>();

  final nameFieldController = TextEditingController();
  final usersFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Group'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          // Validate returns true if the form is valid, or false otherwise.
          if (_formKey.currentState!.validate()) {
            Group group = Group(
                id: "N/A",
                name: nameFieldController.text,
                userIds: [usersFieldController.text]);
            await createGroup(group);
          }
          if (!mounted) return;
          Routemaster.of(context).pop();
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
                decoration: const InputDecoration(hintText: 'name'),
                controller: nameFieldController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              TextFormField(
                autofocus: true,
                decoration: const InputDecoration(hintText: 'users'),
                controller: usersFieldController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<Group> createGroup(Group group) async {
  return createNew("/groups", group, Group.fromJson);
}
