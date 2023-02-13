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

  // Future submitId() async {
  //   var response = await http.post(Uri.parse(''),
  //       headers: <String, String>{
  //         'Content-Type': 'application/json ; charset=utf-8'
  //       },
  //       body: jsonEncode(<String, dynamic>{"candidateId": optionSelected}));

  //   log(response.toString());

  //   setState(() {
  //     isSubmitted = true;
  //   });

  //   navigationToSuccess(isSubmitted, response.toString());
  // }

  // void navigationToSuccess(bool isSubmitted, String res) {
  //   if (isSubmitted) {
  //     Navigator.push(
  //         context, MaterialPageRoute(builder: (context) => SuccessVoting()));
  //   } else {
  //     Container(
  //         child: Center(
  //       child: Text(res),
  //     ));
  //   }
  // }

  // void sendSelectedID(int id, bool selected) async {
  //   if (selected) {
  //     var response = await http.post(
  //       Uri.parse(''),
  //       headers: <String, String>{
  //         'Content-Type': 'application/json; charset=utf-8',
  //       },
  //       body: jsonEncode(<String, int>{"voterId": id}),
  //     );
  //   }
  // }

  List<CandidateGet> _candidates = [];

  Future getCandidate() async {
    final response = await http.get(
        Uri.parse('http://192.168.101.88:1214/api/Candidate/GetAllDetails'));

    var jsonDataList = jsonDecode(response.body);
    // print(jsonDataList.toString());
    for (Map<String, dynamic> candidate in jsonDataList) {
      final candidates = CandidateGet(
          candidateId: candidate["candidateId"],
          candidateFirstName: candidate["candidateFirstName"],
          candidateLastName: candidate["candidateLastName"],
          candidatePhoto: candidate["candidatePhoto"],
          candidatePartyName: candidate["candidatePartyName"],
          candidatePartySymbol: candidate["candidatePartySymbol"],
          nominatedYear: candidate["nominatedYear"]);
      setState(() {
        _candidates.add(candidates);
      });
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
    // final candidateData =
    //     Provider.of<CandidateProvider>(context, listen: false);
    // final List<CandidateGet> candidatesGet = candidateData.candidate;
    return RefreshIndicator(
      onRefresh: getCandidate,
      child: Scaffold(
          appBar: AppBar(
              title:
                  const Text('Voting Screen', style: TextStyle(fontSize: 19))),
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
                        itemCount: _candidates.length,
                        itemBuilder: (context, index) {
                          return SelectableCandidate(
                              _candidates[index].candidateId,
                              _candidates[index].candidateFirstName,
                              _candidates[index].candidateLastName,
                              base64Decode(
                                  _candidates[index].candidatePartySymbol),
                              base64Decode(_candidates[index].candidatePhoto),
                              index + 1 == optionSelected);
                        }),
                  ),
                ],
              ))),
    );
  }
}
