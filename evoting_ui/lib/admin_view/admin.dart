import 'dart:convert';
import 'package:flutter/material.dart';
import './newcandidate.dart';
import '../models/candidate.dart';
import 'dart:io';
import './cadnidate_list.dart';
import '../theme/theme_manager.dart';
import 'package:http/http.dart' as http;

class Admin extends StatefulWidget {
  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  ThemeManager _themeManager = ThemeManager();

  @override
  void dispose() {
    _themeManager.removeListener(themeListener);
    super.dispose();
  }

  @override
  void initState() {
    _themeManager.addListener(themeListener);
    super.initState();
  }

  themeListener() {
    if (mounted) {
      setState(() {});
    }
  }

  List<Candidate> _candidates = [];

  void _addNewCandidate(
      String candidateID,
      String candidateName,
      File candidateImage,
      String candidatePartyName,
      File partySymbol,
      String test) {
    final newCandidate = Candidate(candidateID, candidateName, candidateImage,
        candidatePartyName, partySymbol);

    setState(() {
      _candidates.add(newCandidate);
    });
  }

  Future<http.Response> sendID(String id) async {
    return http.post(
        Uri.parse('http://192.168.101.180:1214/api/Candidate/AddCandidate'),
        headers: <String, String>{
          'Content-Type': 'application/josn; charset=utf-8',
        },
        body: jsonEncode(<String, String>{'candidateID': id}));
  }

  Future<http.Response> getCandidate() async {
    var response = await http.get(
        Uri.parse('http://192.168.101.180:1214/api/Candidate/GetAllDetails'));
    var jsonData = jsonDecode(response.body);

    for (var candidate in jsonData) {
      final canidateInfo = Candidate(
          candidate['CandidateFirstName'],
          candidate['CandidateLastName'],
          candidate['CandidatePhoto'],
          candidate['CandidatePartyName'],
          candidate['CandidatePartySymbol']);
      // _candidates.add(canidateInfo);
    }
    setState(() {
      _candidates = jsonData;
    });
    return response;
  }

  void _deleteCandidate(String id) {
    sendID(id);
    setState(() {
      _candidates.removeWhere((candidate) {
        return candidate.candidateFirstName == id;
      });
    });
  }

  void _startAddNewCandidate(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (bCtx) {
          return GestureDetector(
            onTap: (() {}),
            child: NewCandidate(_addNewCandidate),
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ADMIN DASHBOARD'),
      ),
      body: SingleChildScrollView(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [CandidateList(_candidates, _deleteCandidate)],
      )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () => _startAddNewCandidate(context)),
    );
  }
}
