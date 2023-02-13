// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:developer';

import 'package:evoting_ui/models/candidate_get.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/candidate_provider.dart';
import 'admin.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CandidateList extends StatefulWidget {
  // List<CandidateGet> candidates;

  // CandidateList(this.candidates);
  // final List<CandidateView> candidates;
  // final Function deleteCandidate;
  // final Function getDetails;

  // CandidateList(this.candidates, this.deleteCandidate, this.getDetails);

  @override
  State<CandidateList> createState() => _CandidateListState();
}

class _CandidateListState extends State<CandidateList> {
  final isInit = false;

  Future<http.Response> sendID(String id) async {
    return http.post(
        Uri.parse('http://192.168.101.88:1214/api/Candidate/AddCandidate'),
        headers: <String, String>{
          'Content-Type': 'application/josn; charset=utf-8',
        },
        body: jsonEncode(<String, String>{'candidateID': id}));
  }

  void _deleteCandidate(String id) {
    sendID(id);
  }

  // @override
  // void didChangeDependencies() {
  //   Future.delayed(Duration.zero).then((_) {
  //     Provider.of<CandidateProvider>(context).fetchCandidate();
  //   });
  // }

  // Future<void> _refreshCandidate(BuildContext context) async {
  //   await Provider.of<CandidateProvider>(context).fetchCandidate();
  //   super.didChangeDependencies();
  // }

  List<CandidateGet> _candidates = [];

  Future getCandidate() async {
    final response = await http.get(
        Uri.parse('http://192.168.101.88:1214/api/Candidate/GetAllDetails'));

    var jsonDataList = jsonDecode(response.body);
    print(jsonDataList.toString());
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
        // _candidates.add(candidates);
      });

      log(_candidates.length.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    // final candidateData = Provider.of<CandidateProvider>(context);
    // final List<CandidateGet> candidatesGet = candidateData.candidate;
    return RefreshIndicator(
      onRefresh: () => getCandidate(),
      child: SizedBox(
          height: 450,
          child: ListView.builder(
            itemBuilder: (context, index) {
              return GestureDetector(
                  child: Card(
                      elevation: 10,
                      margin: const EdgeInsets.all(5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      child: ListTile(
                        leading: CircleAvatar(
                            radius: 30,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Image.memory(base64Decode(
                                  _candidates[index].candidatePartySymbol)),
                            )),
                        title: Text(_candidates[index].candidateFirstName),
                        subtitle: Text(_candidates[index].candidatePartyName),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deleteCandidate,
                        ),
                      )));
            },
            itemCount: _candidates.length,
          )),
    );
  }
}
