import 'package:flutter/services.dart';

import '../models/voter.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:local_auth/local_auth.dart';

class UserAuthentication extends StatefulWidget {
  // const UserAuthentication({super.key});

  @override
  State<UserAuthentication> createState() => _UserAuthenticationState();
}

class _UserAuthenticationState extends State<UserAuthentication> {
  LocalAuthentication auth = LocalAuthentication();
  final CitizenshipNumber = TextEditingController();
  final VoterID = TextEditingController();
  bool isAuthenticated = false;

  List<Voter> voters = [];

  Future isAuthenticatedBool() async {
    bool authenticate = false;
    try {
      authenticate = await auth.authenticate(
          localizedReason: 'Choose Biometric Options',
          options: const AuthenticationOptions(biometricOnly: true));
    } on PlatformException catch (e) {
      print(e);
    }

    if (!mounted) return;
    setState(() {
      isAuthenticated = authenticate;
    });

    // return isAuthenticated;
  }

  Future sendVoter() async {
    return http.post(
        Uri.parse(
            'http://192.168.101.51:1214/api/VoterVerification/VerifyVoterId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=utf-8'
        },
        body: jsonEncode(<String, dynamic>{
          'VoterID': VoterID,
          'CitizenShipNumber': CitizenshipNumber.text,
        }));
  }

  Future sendData() async {
    final String citizenShipNumber;
    final String voterID;

    citizenShipNumber = CitizenshipNumber.text;
    voterID = VoterID.text;

    if (citizenShipNumber.isEmpty || voterID.isEmpty) return;
    return http.post(
        Uri.parse(
            'http://192.168.101.51:1214/api/VoterVerification/VerifyVoterId'),
        headers: <String, String>{
          'Content-Type': 'application/json ;charset = utf8'
        },
        body: jsonEncode(<String, String>{
          'VoterID': voterID,
          'CitizenShipNumber': citizenShipNumber
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Authentication')),
      body: Card(
          elevation: 10,
          child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 50),
                  TextField(
                    decoration: const InputDecoration(
                        labelText: 'Enter Your Citizenship Number'),
                    controller: CitizenshipNumber,
                    onSubmitted: (_) => sendData(),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    decoration:
                        const InputDecoration(labelText: 'Enter Your Voter-ID'),
                    controller: VoterID,
                    onSubmitted: (_) => sendData(),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: <Widget>[
                      const Text('Press Biometric Button',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20)),
                      const SizedBox(width: 20),
                      ElevatedButton(
                          onPressed: isAuthenticatedBool,
                          child: const Text('Biometrics'))
                    ],
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                      onPressed: sendData, child: const Text('Authenticate'))
                ],
              ))),
    );
  }
}
