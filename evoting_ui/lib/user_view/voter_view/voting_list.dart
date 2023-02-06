// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'dart:developer';
import 'package:evoting_ui/user_view/voter_view/end_voting.dart';
import 'package:provider/provider.dart';
import '../../providers/candidate_provider.dart';
// import 'package:evoting_ui/models/candidate.dart';
import 'package:evoting_ui/user_view/voter_view/selectable_candidate.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../models/candidate_get.dart';
// import '../../models/candidate_view.dart';
import 'package:http/http.dart' as http;

class VotingView extends StatefulWidget {
  const VotingView({super.key});

  @override
  State<VotingView> createState() => _VotingViewState();
}

class _VotingViewState extends State<VotingView> {
  int optionSelected = 0;
  bool isSubmitted = false;

  void checkOption(int index) {
    setState(() {
      optionSelected = index;
    });
  }

  Future submitId() async {
    var response = await http.post(Uri.parse(''),
        headers: <String, String>{
          'Content-Type': 'application/json ; charset=utf-8'
        },
        body: jsonEncode(<String, dynamic>{"candidateId": optionSelected}));

    log(response.toString());

    setState(() {
      isSubmitted = true;
    });

    navigationToSuccess(isSubmitted, response.toString());
  }

  void navigationToSuccess(bool isSubmitted, String res) {
    if (isSubmitted) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => SuccessVoting()));
    } else {
      Container(
          child: Center(
        child: Text(res),
      ));
    }
  }

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) {
      Provider.of<CandidateProvider>(context).fetchCandidate();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final candidateData =
        Provider.of<CandidateProvider>(context, listen: false);
    final List<CandidateGet> candidatesGet = candidateData.candidate;
    return Scaffold(
        appBar: AppBar(
            title: const Text('Voting Screen', style: TextStyle(fontSize: 19))),
        body: Container(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                SizedBox(
                  height: 400,
                  child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              childAspectRatio: 2 / 3,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10),
                      itemCount: candidatesGet.length,
                      itemBuilder: (context, index) {
                        return SelectableCandidate(
                            candidatesGet[index].candidateFirstName,
                            () => checkOption(index),
                            base64Decode(
                                candidatesGet[index].candidatePartySymbol),
                            false);
                      }),
                ),
                const SizedBox(height: 20),
                ElevatedButton(onPressed: () {}, child: const Text("Submit"))
              ],
            )));
  }
}
