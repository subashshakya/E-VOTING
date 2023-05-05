import 'dart:convert';
import 'dart:developer';
import 'package:evoting_ui/admin_view/super_admin/election_list_widget.dart';
import 'package:evoting_ui/models/candidate_get.dart';
import 'package:flutter/material.dart';
import 'newcandidate.dart';
import '../../real_time_votecount/rt_vote_count.dart';
import 'candidate_list.dart';
import '../../theme/theme_manager.dart';
import 'package:http/http.dart' as http;
import './navbar.dart';

class Admin extends StatefulWidget {
  String token = '';
  Admin(this.token);

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  ThemeManager _themeManager = ThemeManager();

  String url = '101.45';

  // @override
  // void initState() async {
  //   _themeManager.addListener(themeListener);

  //   super.initState();
  // }

  // @override
  // void dispose() {
  //   _themeManager.removeListener(themeListener);
  //   super.dispose();
  // }

  themeListener() {
    if (mounted) {
      setState(() {});
    }
  }

  // List<CandidateGet> _candidates = [];
  // List<CandidateView> _candidatesView = [];

  // void _addNewCandidate(
  //     String candidateID,
  //     String candidateName,
  //     File candidateImage,
  //     String candidatePartyName,
  //     File partySymbol,
  //     String test) {
  //   final newCandidate = Candidate(candidateID, candidateName, candidateImage,
  //       candidatePartyName, partySymbol);

  //   setState(() {
  //     _candidates.add(newCandidate);
  //   });
  // }

  Future<http.Response> sendID(String id) async {
    return http.post(
        Uri.parse('http://192.168.$url:1214/api/Candidate/AddCandidate'),
        headers: <String, String>{
          'Content-Type': 'application/josn; charset=utf-8',
        },
        body: jsonEncode(<String, String>{'candidateID': id}));
  }

  void _deleteCandidate(String id) {
    // sendID(id);
    // setState(() {
    //   _candidates.removeWhere((candidate) {
    //     return candidate.candidateFirstName == id;
    //   });
    // });
  }

  void _startAddNewCandidate(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (bCtx) {
          return GestureDetector(
            onTap: (() {}),
            behavior: HitTestBehavior.opaque,
            child: NewCandidate(widget.token),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    // getCandidate();
    return Scaffold(
        backgroundColor: Colors.white12,
        drawer: Navbar(widget.token),
        appBar: AppBar(
          title: const Text('SUPER ADMIN DASHBOARD'),
          // automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
                elevation: 12,
                child: Column(children: [
                  const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      child: Text("CANDIDATE LIST: ",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold))),
                  const Divider(
                    thickness: 3,
                    color: Colors.black38,
                  ),
                  CandidateList(widget.token)
                ])),
            Card(
                elevation: 10,
                child: Column(
                  children: [
                    const Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        child: Text("ELECTION LIST: ",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold))),
                    const Divider(thickness: 2, color: Colors.black38),
                    Container(
                        height: 200,
                        padding: const EdgeInsets.all(10),
                        color: Colors.black12,
                        child: ElectionListWidget(widget.token)),
                  ],
                ))
          ],
          // )),
          // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          // floatingActionButton: FloatingActionButton(
          //     child: const Icon(Icons.add),
          //     onPressed: () => _startAddNewCandidate(context)),
        )));
  }
}
