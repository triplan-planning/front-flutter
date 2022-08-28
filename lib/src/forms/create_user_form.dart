import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:triplan/src/models/user.dart';

// Define a custom Form widget.
class CreateUserForm extends StatefulWidget {
  const CreateUserForm({super.key});

  static const routeName = '/user/new';

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
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(hintText: 'name'),
              controller: nameFieldController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  // Validate returns true if the form is valid, or false otherwise.
                  if (_formKey.currentState!.validate()) {
                    User user = User(id: "N/A", name: nameFieldController.text);
                    var createdUser = createUser(user);
                    log("submitted form");
                  }
                },
                child: const Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<User> createUser(User user) async {
  final response = await http.post(
    Uri.parse('https://api-go-triplan.up.railway.app/users'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(user.toJson()),
  );

  if (response.statusCode == 200) {
    User createdUser =
        User.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    log("user created");
    return createdUser;
  } else {
    log("user not created: ${response.body}");
    throw Exception('Failed to load user');
  }
}
