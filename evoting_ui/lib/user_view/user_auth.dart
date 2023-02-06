import 'dart:developer';
import 'package:evoting_ui/user_view/voter_view/biometric_verification.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:local_auth/local_auth.dart';

class UserAuthentication extends StatefulWidget {
  @override
  State<UserAuthentication> createState() => _UserAuthenticationState();
}

class _UserAuthenticationState extends State<UserAuthentication> {
  LocalAuthentication auth = LocalAuthentication();
  final citizenshipNumber = TextEditingController();
  final voterID = TextEditingController();
  bool isAuthenticated = true;
  late bool isVerified = false;

  // // Future isAuthenticatedBool() async {
  // //   bool authenticate = false;
  // //   try {
  // //     authenticate = await auth.authenticate(
  // //         localizedReason: 'Choose Biometric Options',
  // //         options: const AuthenticationOptions(biometricOnly: true));
  // //   } on PlatformException catch (e) {
  // //     print(e);
  // //   }

  // //   if (!mounted) return;
  // //   setState(() {
  // //     isAuthenticated = authenticate;
  // //   });

  //   // return isAuthenticated;
  // }

  void navigationToBiometric(int voterId) {
    if (isVerified) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => BiometricVerification(voterId)));
    }
  }

  Future sendData() async {
    final String citizenShipNumber;
    final String voterId;

    citizenShipNumber = citizenshipNumber.text;
    voterId = voterID.text;

    log('isWorking');

    checkInput();

    // if (citizenShipNumber.isEmpty || voterId.isEmpty) return;
    final response = await http.post(
        Uri.parse(
            'http://192.168.137.250:1214/api/VoterVerification/VerifyVoterId'),
        headers: <String, String>{
          'Content-Type': 'application/json ;charset=utf-8',
        },
        body: jsonEncode(<String, dynamic>{
          'voterID': int.parse(voterId),
          'citizenShipId': citizenShipNumber
        }));

    log(response.body.toString());

    if (response.body.toString() == "Verified") {
      setState(() {
        isVerified = true;
      });
    }
    // navigationToBiometric(int.parse(voterId));\

    if (isVerified) {
      biometricValidation();
    } else {
      Container(child: const Text("Biometric verification is invalid"));
    }
  }

  void checkInput() {
    final ctz = citizenshipNumber.text;
    final vt = voterID.text;

    if (ctz.isEmpty || vt.isEmpty) {
      _showDialog("The Citizenship or VoterID field is empty");
    } else {
      if (ctz.length < 10 || ctz.length > 15) {
        _showDialog("The entered citizenshipID is invalid");
      }

      if (voterID.text.length != 6) {
        _showDialog("VoterID length should be 6 Digits");
      }
    }
  }

  Future biometricValidation() async {
    var response = await http.post(
        Uri.parse('http://192.168.1.91:1214/api/Biometric/VerifyFingerPrint'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=utf-8',
        },
        body: jsonEncode(<String, int>{'VoterId': 23563}));
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
              title: const Text('Alert!'),
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

  void someFunc() async {
    if (isAuthenticated) {
      var res = await http.post(
          Uri.parse('http://192.168.1.91:1214/api/Biometric/VerifyFingerPrint'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=utf-8',
          },
          body: jsonEncode(<String, int>{'VoterId': 234563}));

      log(res.body.toString());
    }
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
                    controller: citizenshipNumber,
                    onSubmitted: (_) => sendData(),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    decoration:
                        const InputDecoration(labelText: 'Enter Your Voter-ID'),
                    controller: voterID,
                    keyboardType: TextInputType.number,
                    onSubmitted: (_) => sendData(),
                  ),
                  // const SizedBox(height: 20),
                  // Row(
                  //   children: <Widget>[
                  //     const Text('Press Biometric Button',
                  //         style: TextStyle(
                  //             fontWeight: FontWeight.bold, fontSize: 20)),
                  //     const SizedBox(width: 20),
                  //     ElevatedButton(
                  //         onPressed: isAuthenticatedBool,
                  //         child: const Text('Biometrics'))
                  //   ],
                  // ),
                  const SizedBox(height: 30),
                  // ElevatedButton(
                  // onPressed: someFunc, child: Text('this is button')),
                  ElevatedButton(
                      onPressed: sendData, child: const Text('Authenticate'))
                ],
              ))),
    );
  }
}
