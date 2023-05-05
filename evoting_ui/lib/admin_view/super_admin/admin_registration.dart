import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AdminRegistration extends StatefulWidget {
  String token;
  AdminRegistration(this.token);
  @override
  State<AdminRegistration> createState() => _AdminRegistrationState();
}

class _AdminRegistrationState extends State<AdminRegistration> {
  final username = TextEditingController();
  final password = TextEditingController();
  final rePassword = TextEditingController();

  String url = '101.45';

  void _showDialog(String dialog) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              backgroundColor: Colors.blueGrey,
              title: const Text("ALERT!",
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
              content: Text(dialog),
              actions: [
                MaterialButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('OK'))
              ]);
        });
  }

  bool passwordValidation() {
    if (password.text.length < 8) {
      _showDialog("THE PASSWORD IS WEAK PLEASE MAKE IT 8 CHARACTERS OR MORE");
      return false;
    } else if (password.text != rePassword.text) {
      _showDialog("THE PASSWORD DO NOT MATCH");
      return false;
    } else {
      return true;
    }
  }

  bool usernameValidation() {
    if (username.text.isEmpty) {
      _showDialog("Username field is empty");
      return false;
    }
    if (!RegExp(r'^[a-zA-Z]+$').hasMatch(username.text)) {
      _showDialog("Username field contains invalid characters");
      return false;
    } else {
      return true;
    }
  }

  Future sendAdmin() async {
    bool val1 = passwordValidation();
    bool val2 = usernameValidation();
    if (val1 && val2) {
      final response = await http.post(
          Uri.parse('http://192.168.$url:1214/api/Login/RegisterUser'),
          headers: <String, String>{
            'Content-Type': 'application/json ;charset=utf-8',
            "Authorization": 'Bearer ${widget.token}'
          },
          body: jsonEncode(<String, String>{
            "username": username.text,
            "password": password.text,
            "email": "lambe@gmail.com",
            "Roles": "Admin"
          }));

      if (response.body == "UserName already exists") {
        _showDialog("UserName already exists");
      }

      if (response.body == "Admin Created") {
        _showDialog("New Admin Created");
      }
    }
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("ADMIN REGISTRATION")),
        body: Container(
            child: Card(
                elevation: 10,
                child: Form(
                  key: _formKey,
                  child: Column(children: [
                    const SizedBox(height: 20),
                    const Text(
                      "ENTER ADMIN USERNAME: ",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 5),
                    TextFormField(
                      decoration: const InputDecoration(
                          labelText: '---------username----------'),
                      controller: username,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "PLEASE ENTER A DISTRICT";
                        }
                        if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
                          return "ENTERED VALUE HAS INVALID CHARACTERS";
                        }
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      "ENTER PASSWORD: ",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 5),
                    TextField(
                        obscureText: true,
                        decoration: const InputDecoration(
                            labelText: '--------password---------'),
                        controller: password,
                        onSubmitted: (_) => () {}),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      "RE-ENTER PASSWORD",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 5),
                    TextField(
                        obscureText: true,
                        decoration: const InputDecoration(
                            labelText: '--------password---------'),
                        controller: rePassword,
                        onSubmitted: (_) => () {}),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          sendAdmin();
                        },
                        child: const Text("ADD"))
                  ]),
                ))));
  }
}
