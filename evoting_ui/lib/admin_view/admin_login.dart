import 'dart:developer';

import 'package:evoting_ui/admin_view/admin.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AdminLogin extends StatefulWidget {
  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  final adminUserName = TextEditingController();

  final adminPassWord = TextEditingController();

  bool isAuthenticated = false;

  Future authenticate() async {
    var response = http.post(Uri.parse(''),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=utf-8'
        },
        body: jsonEncode(<String, dynamic>{
          "adminUserName": adminUserName.text,
          "adminPassword": adminPassWord.text
        }));

    log(response.toString());

    if (response.toString() == "Verified") {
      setState(() {
        isAuthenticated = true;
      });
      navigationToAdminDashBoard();
    } else {
      const Card(
          elevation: 10,
          child: Text(
            "The username or password is invalid",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
          ));
    }
  }

  void navigationToAdminDashBoard() {
    if (isAuthenticated) {
      Navigator.push(
          context, MaterialPageRoute(builder: ((context) => const Admin())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text(
          "Admin Authentication",
          textAlign: TextAlign.center,
        )),
        body: Card(
            elevation: 10,
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(children: <Widget>[
                const SizedBox(height: 50),
                TextField(
                  decoration: const InputDecoration(
                      labelText: 'Enter Your Citizenship Number'),
                  controller: adminUserName,
                  onSubmitted: (_) => authenticate(),
                ),
                const SizedBox(height: 20),
                TextField(
                  decoration: const InputDecoration(
                      labelText: 'Enter Your Citizenship Number'),
                  controller: adminPassWord,
                  onSubmitted: (_) => authenticate(),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                    onPressed: authenticate, child: const Text("Authenticate"))
              ]),
            )));
  }
}
