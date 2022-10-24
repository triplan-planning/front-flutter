import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:triplan/src/models/user.dart';
import 'package:triplan/src/utils/api_tools.dart';

// Define a custom Form widget.
class CreateUserForm extends StatefulWidget {
  const CreateUserForm({super.key});

  @override
  CreateUserFormState createState() {
    return CreateUserFormState();
  }
}

// Define a corresponding State class.
// This class holds data related to the form.
class CreateUserFormState extends State<CreateUserForm> {
  final _formKey = GlobalKey<FormState>();

  final nameFieldController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New User'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          // Validate returns true if the form is valid, or false otherwise.
          if (_formKey.currentState!.validate()) {
            User user = User(id: "N/A", name: nameFieldController.text);
            await createUser(user);
          }
          if (!mounted) return;
          GoRouter.of(context).pop();
        },
        backgroundColor: Colors.green,
        icon: const Icon(Icons.check),
        label: const Text("Create User"),
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
            ],
          ),
        ),
      ),
    );
  }
}

Future<User> createUser(User user) async {
  return createNew("/users", user, User.fromJson);
}
