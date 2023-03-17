import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import "package:flutter/material.dart";
import 'package:http/http.dart' as http;
import '../prediction.dart';

class ShowCandidate extends StatefulWidget {
  int index;
  String candidateFirstName;
  String candidateLastName;
  Uint8List candidatephoto;
  String candidatePartyName;
  Uint8List candidatePartySymbol;
  String nominatedYear;
  String token;

  ShowCandidate(
      this.index,
      this.candidateFirstName,
      this.candidateLastName,
      this.candidatephoto,
      this.candidatePartyName,
      this.candidatePartySymbol,
      this.nominatedYear,
      this.token);

  @override
  State<ShowCandidate> createState() => _ShowCandidateState();
}

class _ShowCandidateState extends State<ShowCandidate> {
  int voteprediction = 0;
  String url = '100.215';

  @override
  initState() {
    getPrediction();
    super.initState();
  }

  Future getPrediction() async {
    var response = await http.post(
        Uri.parse('http://192.168.$url:1214/api/Prediction/PredictVote'),
        headers: <String, String>{
          'Content-Type': 'application/json ;charset=utf-8',
          "Authorization": 'Bearer ${widget.token}'
        },
        body: jsonEncode(<String, dynamic>{
          "electoinYear": widget.nominatedYear,
          "state": "KATHMANDU",
          "voteREceived": 0,
          "totalVotes": 15561900,
          "partyname": widget.candidatePartyName,
        }));

    log(response.body);
    int jsonbody = jsonDecode(response.body);

    // int voteReceived = jsonbody;

    setState(() {
      voteprediction = jsonbody;
      log(voteprediction.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("CANDIDATE INFORMATION")),
        body: Padding(
            padding: const EdgeInsets.all(10),
            child: Card(
                elevation: 10,
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    const Text("Candidate Name:",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(widget.candidateFirstName,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        const SizedBox(width: 5),
                        Text(widget.candidateLastName,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold))
                      ],
                    ),
                    const Divider(thickness: 4, color: Colors.black12),
                    const SizedBox(height: 15),
                    const Text("Candidate Photo: ",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Container(
                        height: 100,
                        width: 100,
                        padding: const EdgeInsets.all(8),
                        child: Center(
                            child: Image.memory(widget.candidatephoto,
                                fit: BoxFit.cover))),
                    const Divider(thickness: 4, color: Colors.black12),
                    const SizedBox(height: 15),
                    const Text("Candidate Party Name: ",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(widget.candidatePartyName,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        const SizedBox(width: 10),
                        SizedBox(
                            height: 70,
                            width: 70,
                            child: Image.memory(widget.candidatePartySymbol,
                                fit: BoxFit.cover))
                      ],
                    ),
                    const Divider(thickness: 4, color: Colors.black12),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text("Nominated Year Of Candidate: ",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold)),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(widget.nominatedYear,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    const Divider(thickness: 4, color: Colors.black12),
                    const SizedBox(height: 20),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => Prediction(
                                      voteprediction,
                                      widget.candidateFirstName,
                                      widget.candidateLastName,
                                      widget.candidatephoto,
                                      widget.candidatePartyName,
                                      widget.candidatePartySymbol))));
                        },
                        child: const Text("PREDICT VOTE",
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold)))
                  ],
                ))));
  }
}
