import 'dart:developer';
import '../../models/auth_model.dart';
import 'package:evoting_ui/admin_view/super_admin/admin.dart';
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
  String url = '101.45';
  List<AuthModel> _auth = [];
  String role = '';

  void _showDialog(String dialog) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              backgroundColor: Colors.blueGrey,
              title: const Text('ALERT',
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

    log(response.body);
    log(response.statusCode.toString());

    if (response.body == "USerName not found") {
      _showDialog("User Doesnot exist");
    }

    // log(response.body.toString());
    log(response.statusCode.toString());
    final auth = AuthModel(jsonBody["role"]!, jsonBody["token"]!);
    log(auth.role);
    if (auth.role == "SuperAdmin") {
      setState(() {
        token = auth.token;
        log(token);
        isAuthenticated = true;
      });
      navigationToAdminDashBoard();
    } else {
      _showDialog("Username or password is invalid");
    }
  }

  // if (response.statusCode == 200) {
  //   setState(() {
  //     isAuthenticated = true;
  //     token = response.body.toString();
  //   });

  //   navigationToAdminDashBoard();
  // } else {
  //   const Card(
  //       elevation: 10,
  //       child: Text(
  //         "The username or password is invalid",
  //         textAlign: TextAlign.center,
  //         style: TextStyle(fontSize: 20),
  //       ));
  // }

  void navigationToAdminDashBoard() {
    if (isAuthenticated) {
      Navigator.push(
          context, MaterialPageRoute(builder: ((context) => Admin(token))));
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
                const SizedBox(height: 50),
                const Text("Super Admin Authentication",
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
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
                  decoration: const InputDecoration(labelText: '*********'),
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
