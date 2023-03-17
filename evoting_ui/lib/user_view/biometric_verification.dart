// ignore_for_file: avoid_unnecessary_containers

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:evoting_ui/user_view/voting_list.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BiometricVerification extends StatefulWidget {
  final int voterId;
  String localizationString;
  BiometricVerification(this.voterId, this.localizationString);

  @override
  State<BiometricVerification> createState() => _BiometricVerificationState();
}

class _BiometricVerificationState extends State<BiometricVerification> {
  String url = '100.215';

  late bool isVerified = false;
  int timeLeft = 10;
  int count = 3;
  Future biometricValidation() async {
    while (!isVerified) {
      showTimer();
      var response = await http.post(
          Uri.parse('http://192.168.$url:1214/api/Biometric/VerifyFingerPrint'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=utf-8',
          },
          body: jsonEncode(<String, int>{'VoterId': widget.voterId}));

      log(response.body.toString());
      if (response.statusCode == 200) {
        setState(() {
          isVerified = true;
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => VotingView(
                      response.body.toString(), widget.localizationString)));
        });
      }
      count--;
      setState(() {
        timeLeft = 10;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white12,
        appBar: AppBar(
            title: Text(
              'bio_title'.tr,
              style: const TextStyle(fontSize: 20),
            ),
            automaticallyImplyLeading: false,
            centerTitle: true),
        body: Container(
          alignment: Alignment.center,
          child: Column(children: <Widget>[
            const SizedBox(height: 50),
            // Text(
            //   'bio_title'.tr,
            //   style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            //   textAlign: TextAlign.center,
            // ),
            const SizedBox(height: 50),
            Text(
              'press'.tr,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 40,
            ),
            const Image(image: AssetImage('assets/th.webp')),
            const SizedBox(height: 40),
            ElevatedButton(
                onPressed: biometricValidation, child: Text('auth'.tr)),
            const SizedBox(height: 20),
            Column(children: [
              Text(
                'time_left'.tr,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(timeLeft == 0 ? 'press_again'.tr : timeLeft.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold))
            ])
          ]),
        ));
  }
}
