// ignore_for_file: avoid_unnecessary_containers

import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:evoting_ui/user_view/voter_view/voting_list.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BiometricVerification extends StatefulWidget {
  final int voterId;
  BiometricVerification(this.voterId);

  @override
  State<BiometricVerification> createState() => _BiometricVerificationState();
}

class _BiometricVerificationState extends State<BiometricVerification> {
  late bool isVerified = false;
  int timeLeft = 10;
  Future biometricValidation() async {
    showTimer();
    var response = await http.post(
        Uri.parse('http://192.168.1.91:1214/api/Biometric/VerifyFingerPrint'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=utf-8',
        },
        body: jsonEncode(<String, int>{'VoterId': 789456}));
    // var res = response.toString();

    log(response.body.toString());
    if (response.body.toString() == "Verified") {
      setState(() {
        isVerified = true;
      });
    }
  }

  void showTimer() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeLeft > 0) {
        setState(() {
          timeLeft--;
        });
      } else {
        timer.cancel();
      }
    });
  }
  // void navigatonToVotingScreen() {
  //   biometricValidation();
  //   if (isVerified) {
  //     Navigator.push(
  //         context, MaterialPageRoute(builder: (context) => VotingView()));
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text(
          'Biometric Verification Phase',
          style: TextStyle(fontSize: 20),
        )),
        body: Container(
          alignment: Alignment.center,
          child: Column(children: <Widget>[
            const SizedBox(height: 50),
            const Text('Please press the biometric sensor'),
            const SizedBox(
              height: 40,
            ),
            const Image(image: AssetImage('assets/th.webp')),
            const SizedBox(height: 40),
            ElevatedButton(
                onPressed: biometricValidation,
                child: const Text('Authenticate')),
            const SizedBox(height: 20),
            Column(children: [
              const Text("Time left to press biometric Sensor"),
              const SizedBox(height: 10),
              Text(
                  timeLeft == 0
                      ? 'Please press the sensor again'
                      : timeLeft.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 20))
            ])
          ]),
        ));
  }
}
