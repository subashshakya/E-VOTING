import 'dart:developer';
import 'package:evoting_ui/user_view/biometric_verification.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:local_auth/local_auth.dart';
import 'package:get/get.dart';

class UserAuthentication extends StatefulWidget {
  String localizationLetter;
  UserAuthentication(this.localizationLetter);
  @override
  State<UserAuthentication> createState() => _UserAuthenticationState();
}

class _UserAuthenticationState extends State<UserAuthentication> {
  LocalAuthentication auth = LocalAuthentication();
  final citizenshipNumber = TextEditingController();
  final voterID = TextEditingController();
  bool isAuthenticated = true;
  late bool isVerified = false;
  String url = '101.45';

  void navigationToBiometric(int voterId) {
    if (isVerified) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  BiometricVerification(voterId, widget.localizationLetter)));
    }
  }

  Future sendData() async {
    final String citizenShipNumber;
    final String voterId;

    citizenShipNumber = citizenshipNumber.text;
    voterId = voterID.text;

    final response = await http.post(
        Uri.parse('http://192.168.$url:1214/api/Voter/VerifyVoterId'),
        headers: <String, String>{
          'Content-Type': 'application/json ;charset=utf-8',
        },
        body: jsonEncode(<String, dynamic>{
          'voterID': int.parse(voterId),
          'citizenShipId': citizenShipNumber
        }));

    log(response.body.toString());
    log(response.statusCode.toString());

    if (response.body.toString() == "Verified") {
      setState(() {
        isVerified = true;
      });
      if (isVerified) {
        navigationToBiometric(int.parse(voterId));
      } else {
        _showDialog("VOTER AUTHENTICATION FAILED");
      }
    }
    if (response.body.toString() == "Not Verified") {
      _showDialog('Voter doesnot exist');
    }
    if (response.body.toString() == "Voter already Voted") {
      _showDialog("Voter has already voted");
    }
  }

  Future biometricValidation() async {
    var response = await http.post(
        Uri.parse('http://192.168.$url:1214/api/Biometric/VerifyFingerPrint'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=utf-8',
        },
        body: jsonEncode(<String, int>{'VoterId': int.parse(voterID.text)}));
    var res = response.body.toString();

    log(res.toString());
    if (res == "Verified") {
      setState(() {
        isVerified = true;
      });
    }
  }

  void _showDialog(String dialog) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              backgroundColor: Colors.blueGrey,
              title: Text('alert'.tr),
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

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      appBar: AppBar(
        title: Text('auth_title'.tr),
        automaticallyImplyLeading: false,
        centerTitle: true,
        titleTextStyle:
            const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      body: Card(
          elevation: 10,
          child: Container(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 30),
                      const SizedBox(
                          height: 100,
                          width: 100,
                          child: Image(
                            image: AssetImage('assets/casted.webp'),
                            color: Colors.white70,
                          )),
                      const SizedBox(height: 25),
                      Card(
                          elevation: 5,
                          child: Text(
                            'citizenship'.tr,
                            style: const TextStyle(fontSize: 20),
                            textAlign: TextAlign.left,
                          )),
                      TextFormField(
                        decoration: const InputDecoration(
                            labelStyle: TextStyle(fontWeight: FontWeight.bold),
                            labelText: 'XX-XX-XXXXX'),
                        controller: citizenshipNumber,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "ENTER CITIZENSHIP NUMBER";
                          }
                          if (!RegExp(r'^\d{2}-\d{2}-\d{5}$').hasMatch(value)) {
                            return "INVALID FORMAT";
                          }
                        },
                      ),
                      const SizedBox(height: 40),
                      Text(
                        'voterId'.tr,
                        style: const TextStyle(fontSize: 20),
                        textAlign: TextAlign.left,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                            labelStyle: TextStyle(fontWeight: FontWeight.bold),
                            labelText: 'XXXXXX'),
                        controller: voterID,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          log(voterID.toString());
                          if (value == null || value.isEmpty) {
                            return "ENTER VOTER ID";
                          }
                          if (!RegExp(r'^\d{6}$').hasMatch(value)) {
                            return "PLEASE ENTER 6 DIGITS";
                          }
                        },
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              sendData();
                            }
                          },
                          child: Text('auth'.tr))
                    ],
                  ),
                ),
              ))),
    );
  }
}
