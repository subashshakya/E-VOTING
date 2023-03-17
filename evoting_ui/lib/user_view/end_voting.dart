import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import './select_language.dart';

class SuccessVoting extends StatefulWidget {
  @override
  State<SuccessVoting> createState() => _SuccessVotingState();
}

class _SuccessVotingState extends State<SuccessVoting> {
  int count = 10;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white12,
      appBar: AppBar(
        title: Text("end_screen".tr),
        automaticallyImplyLeading: false,
      ),
      body: Center(
          child: Column(children: [
        const SizedBox(
          height: 100,
        ),
        Text('voting_end'.tr,
            style: const TextStyle(fontSize: 27, fontWeight: FontWeight.bold)),
        const SizedBox(height: 50),
        TimerCountdown(
          format: CountDownTimerFormat.minutesSeconds,
          timeTextStyle:
              const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          endTime: DateTime.now().add(
            const Duration(
              minutes: 0,
              seconds: 10,
            ),
          ),
          onEnd: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => LanguageSelection()));
          },
        ),
      ])),
    );
  }
}
