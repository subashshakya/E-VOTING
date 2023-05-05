import 'dart:developer';
import 'dart:typed_data';
import './customs/show_candidate.dart';
import 'package:evoting_ui/models/candidate_get.dart';
import 'package:evoting_ui/models/candidate_post.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/candidate_provider.dart';
import 'admin.dart';
import 'dart:convert';
import 'prediction.dart';
import 'package:http/http.dart' as http;

class CandidateList extends StatefulWidget {
  // List<CandidateGet> candidates;

  // CandidateList(this.candidates);
  // final List<CandidateView> candidates;
  // final Function deleteCandidate;
  // final Function getDetails;

  // CandidateList(this.candidates, this.deleteCandidate, this.getDetails);
  String token;
  CandidateList(this.token);

  @override
  State<CandidateList> createState() => _CandidateListState();
}

class _CandidateListState extends State<CandidateList> {
  final isInit = false;
  String url = '101.45';
  List<CandidatePost> _candidatePosts = [];

  Future sendID(String id) async {
    final response = await http.post(
        Uri.parse('http://192.168.$url:1214/api/Candidate/Delete'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=utf-8',
          'Authorization': 'Bearer ${widget.token}'
        },
        body: jsonEncode(<String, String>{'candidateId': id}));

    log(response.body.toString());
  }

  void _deleteCandidate(String id) {
    sendID(id);
  }

  Future getCandidatePostInfo() async {
    final response = await http.post(
        Uri.parse('http://192.168.$url:1214/api/Election/GetNominationPost'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=utf-8',
          'Authorization': 'Bearer ${widget.token}',
        },
        body: jsonEncode(
            <String, dynamic>{"ElectionTypeId": 1, "ElectionName": "0"}));

    final jsonBody = jsonDecode(response.body);

    for (Map<String, dynamic> post in jsonBody) {
      final candidates = CandidatePost(
          post["postId"], post["electionTypeId"], post["postName"]);

      log(candidates.postName);

      setState(() {
        _candidatePosts.add(candidates);
      });
    }
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

  List<CandidateGet> _candidates = [
    // CandidateGet(
    //     candidateFirstName: "Subash",
    //     candidateId: 1,
    //     candidateLastName: "shakya",
    //     candidatePartyName: "UML",
    //     candidatePartySymbol:
    //         "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",
    //     candidatePhoto:
    //         "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",
    //     nominatedYear: "2079"),
    // CandidateGet(
    //     candidateFirstName: "NItish",
    //     candidateId: 2,
    //     candidateLastName: "sharma",
    //     candidatePartyName: "Congress",
    //     candidatePartySymbol:
    //         "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",
    //     candidatePhoto:
    //         "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",
    //     nominatedYear: "2079"),
    // CandidateGet(
    //     candidateFirstName: "Pravas",
    //     candidateId: 1,
    //     candidateLastName: "pandey",
    //     candidatePartyName: "Independent",
    //     candidatePartySymbol:
    //         "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",
    //     candidatePhoto:
    //         "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",
    //     nominatedYear: "2079"),
  ];

  List<CandidateGet> _fetchList = [];
  Future getCandidate() async {
    // log(widget.token);
    final response = await http.get(
        Uri.parse('http://192.168.$url:1214/api/Candidate/GetAllDetails'),
        headers: <String, String>{"Authorization": 'Bearer ${widget.token}'});

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
      // log(candidates.candidateFirstName);
      // setState(() {
      //   _candidates.add(candidates);
      // });

      // log(_candidates.length.toString());

      getCandidatePostInfo();
      log(_candidates.length.toString());

      setState(() {
        _fetchList.add(candidates);
      });
    }
    if (_candidates.length != _fetchList.length) {
      setState(() {
        _candidates = _fetchList;
      });
    } else {
      setState(() {
        _candidates = _candidates;
      });
    }
  }

  // showCandidate(
  //     int index,
  //     String candidateFirstName,
  //     String candidateLastName,
  //     Uint8List candidatephoto,
  //     String candidatePartyName,
  //     Uint8List candidatePartySymbol,
  //     String nominatedYear) {
  //   return showDialog(
  //       context: context,
  //       builder: (context) {
  //         return Center(
  //           child: Material(
  //               type: MaterialType.transparency,
  //               child: Container(
  //                   decoration: BoxDecoration(
  //                       borderRadius: BorderRadius.circular(10),
  //                       color: Colors.white38),
  //                   padding: const EdgeInsets.all(15),
  //                   width: 400,
  //                   height: 320,
  //                   child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.center,
  //                     children: <Widget>[
  //                       Row(
  //                         children: <Widget>[
  //                           Text(candidateFirstName),
  //                           const SizedBox(
  //                             width: 3,
  //                           ),
  //                           Text(candidateLastName),
  //                           const SizedBox(width: 50),
  //                           MaterialButton(
  //                               onPressed: () {
  //                                 Navigator.pop(context);
  //                               },
  //                               child: const Icon(Icons.cancel_outlined))
  //                         ],
  //                       ),
  //                       const SizedBox(height: 20),
  //                       Row(
  //                         children: <Widget>[
  //                           const Text("Photo Of Candidate: "),
  //                           const SizedBox(width: 10),
  //                           Image.memory(candidatephoto,
  //                               fit: BoxFit.cover, height: 75, width: 75)
  //                         ],
  //                       ),
  //                       const SizedBox(height: 20),
  //                       Row(
  //                         children: <Widget>[
  //                           const Text("Party Symbol Of Candidate: "),
  //                           const SizedBox(
  //                             width: 10,
  //                           ),
  //                           Image.memory(candidatePartySymbol,
  //                               fit: BoxFit.cover, height: 75, width: 75)
  //                         ],
  //                       ),
  //                       const SizedBox(height: 20),
  //                       ElevatedButton(
  //                           onPressed: () {
  //                             Navigator.push(
  //                                 context,
  //                                 MaterialPageRoute(
  //                                     builder: (context) =>
  //                                         const Prediction()));
  //                           },
  //                           child: const Text("Predict Vote"))
  //                     ],
  //                   ))),
  //         );
  //       });
  // }

  void showCandidate(int index) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: ((context) => ShowCandidate(
                _candidates[index].candidateId,
                _candidates[index].candidateFirstName,
                _candidates[index].candidateLastName,
                base64Decode(_candidates[index].candidatePhoto),
                _candidates[index].candidatePartyName,
                base64Decode(_candidates[index].candidatePartySymbol),
                _candidates[index].nominatedYear,
                widget.token))));
  }

  @override
  Widget build(BuildContext context) {
    // final candidateData = Provider.of<CandidateProvider>(context);
    // final List<CandidateGet> candidatesGet = candidateData.candidate;
    return RefreshIndicator(
      onRefresh: () => getCandidate(),
      child: SizedBox(
          height: 250,
          child: ListView.builder(
            itemBuilder: (context, index) {
              return GestureDetector(
                  child: Card(
                      elevation: 10,
                      margin: const EdgeInsets.all(5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      child: ListTile(
                        onTap: () => showCandidate(index),
                        leading: CircleAvatar(
                            radius: 30,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Image.memory(
                                  base64Decode(
                                      _candidates[index].candidatePartySymbol),
                                  fit: BoxFit.cover),
                            )),
                        title: Text(_candidates[index].candidateFirstName),
                        subtitle: Text(_candidates[index].candidatePartyName),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deleteCandidate(
                              _candidates[index].candidateId.toString()),
                        ),
                      )));
            },
            itemCount: _candidates.length,
          )),
    );
  }
}
