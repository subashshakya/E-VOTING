import 'package:flutter/material.dart';
import 'dart:developer';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/election_result.dart';
import '../../models/election_list.dart';

class Result extends StatefulWidget {
  String token;
  List<ElectionList> _electionList;
  Result(this.token, this._electionList);
  @override
  State<Result> createState() => _ResultState();
}

class _ResultState extends State<Result> {
  List<ElectionResult> _results = [
    // ElectionResult("candidateFirstName", "candidateLastName",
    //     "candidatePartyName", "year", 12345, "postName"),
    // ElectionResult("candidateFirstName", "candidateLastName",
    //     "candidatePartyName", "year", 12345, "postName"),
    // ElectionResult("candidateFirstName", "candidateLastName",
    //     "candidatePartyName", "year", 12345, "postName"),
  ];
  String url = '100.215';

  Future getResult() async {
    log(widget.token);
    var response = await http.post(
        Uri.parse('http://192.168.$url:1214/api/Election/GetResult'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=utf-8',
          "Authorization": 'Bearer ${widget.token}'
        },
        body: jsonEncode(<String, String>{"Year": "2079"}));

    final jsonBody = jsonDecode(response.body);
    for (Map<String, dynamic> res in jsonBody) {
      final result = ElectionResult(
          res["candidateFirstName"],
          res["candidateLastName"],
          res["candidatePartyName"],
          res["year"],
          res["voteReceived"],
          res["postName"]);

      // log(result.candidatePartyName);
      setState(() {
        _results.add(result);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white12,
      appBar: AppBar(title: const Text("RESULT SCREEN")),
      body: RefreshIndicator(
          onRefresh: getResult,
          child: SizedBox(
              height: 700,
              child: ListView.builder(
                  itemCount: _results.length,
                  itemBuilder: (context, index) {
                    return Card(
                        elevation: 10,
                        child: Container(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    const Text("Candidate Name:",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(_results[index].candidateFirstName,
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    const Text("Candidate Party Name:",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(_results[index].candidatePartyName,
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold)),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    const Text("Candidate Nominated year:",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(_results[index].year,
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    const Text("Vote Received By Candidate: ",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                        _results[index].voteReceived.toString(),
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    const Text("Candidate Post:",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(_results[index].postName,
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ],
                            )));
                  }))),
    );
  }
}
