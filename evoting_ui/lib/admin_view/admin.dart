import 'dart:convert';
import 'dart:developer';
import 'package:evoting_ui/models/candidate_get.dart';
import 'package:flutter/material.dart';
import './newcandidate.dart';

import './cadnidate_list.dart';
import '../theme/theme_manager.dart';
import 'package:http/http.dart' as http;

class Admin extends StatefulWidget {
  const Admin({super.key});

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  ThemeManager _themeManager = ThemeManager();

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
        Uri.parse('http://192.168.101.88:1214/api/Candidate/AddCandidate'),
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
            child: NewCandidate(),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    // getCandidate();
    return Scaffold(
      appBar: AppBar(
        title: const Text('ADMIN DASHBOARD'),
      ),
      body: SingleChildScrollView(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [CandidateList()],
      )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () => _startAddNewCandidate(context)),
    );
  }
}
