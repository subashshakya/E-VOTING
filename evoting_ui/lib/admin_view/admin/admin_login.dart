import 'dart:developer';
import 'package:evoting_ui/models/auth_model.dart';

import './admin_pannel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AdminLoginPannel extends StatefulWidget {
  @override
  State<AdminLoginPannel> createState() => _AdminLoginPannelState();
}

class _AdminLoginPannelState extends State<AdminLoginPannel> {
  final adminUserName = TextEditingController();

  final adminPassWord = TextEditingController();

  bool isAuthenticated = false;
  String url = '100.215';

  String token = '';
  Future authenticate() async {
    final response = await http.post(
        Uri.parse('http://192.168.$url:1214/api/Login/LoginUser'),
        headers: <String, String>{
          'Content-Type': 'application/json ;charset=utf-8',
        },
        body: jsonEncode(<String, String>{
          'UserName': adminUserName.text,
          'Password': adminPassWord.text
        }));

    var jsonBody = jsonDecode(response.body);
    log(response.body.toString());
    log(response.statusCode.toString());

    final auth = AuthModel(jsonBody["role"], jsonBody["token"]);

    if (auth.role == "Admin") {
      setState(() {
        isAuthenticated = true;

        token = auth.token;
        log(token);
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
      // log(token);
      Navigator.push(context,
          MaterialPageRoute(builder: ((context) => AdminPannel(token))));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white12,
        body: Card(
            elevation: 10,
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(children: <Widget>[
                const SizedBox(height: 100),
                Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(10),
                  color: Colors.grey,
                  width: MediaQuery.of(context).size.width,
                  child: const Text("Admin Authentication",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 30),
                const Text(
                  "Enter Your Username",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 5),
                TextField(
                  decoration: const InputDecoration(labelText: 'Username'),
                  controller: adminUserName,
                  onSubmitted: (_) => authenticate(),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Enter Your Password",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 5),
                TextField(
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Password'),
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
