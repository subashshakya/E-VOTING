// ignore_for_file: prefer_final_fields

import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
import '../models/candidate_get.dart';
import 'package:http/http.dart' as http;

class CandidateProvider with ChangeNotifier {
  List<CandidateGet> _candidatesGet = [
    CandidateGet(
        candidateId: 1,
        candidateFirstName: 'Subash',
        candidateLastName: 'Shakya',
        candidatePhoto:
            "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",
        candidatePartyName: 'Communist',
        candidatePartySymbol:
            "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",
        nominatedYear: '2079'),
  ];

  List<CandidateGet> get candidate {
    return _candidatesGet;
  }

  void addCandidate(CandidateGet obj) {
    _candidatesGet.add(obj);
    notifyListeners();
  }

  Future fetchCandidate() async {
    const url = 'http://192.168.137.250:1214/api/Candidate/GetAllDetails';
    final response = await http.get(Uri.parse(url));
    final jsonBody = jsonDecode(response.body);

    log(jsonBody);

    for (Map<String, dynamic> candidate in jsonBody) {
      final candidateId = candidate["candidateId"];
      final candidateFirstName = candidate["candidateFirstName"];
      final candidateLastName = candidate["candidateLastName"];
      final candidatePhoto = candidate["candidatePhoto"];
      final candidatePartyName = candidate["candidatePartyName"];
      final candidatePartySymbol = candidate["candidatePartySymbol"];
      final nominatedYear = candidate["nominatedYear"];
      log(candidateId);

      CandidateGet obj = CandidateGet(
          candidateId: candidateId,
          candidateFirstName: candidateFirstName,
          candidateLastName: candidateLastName,
          candidatePhoto: candidatePhoto,
          candidatePartyName: candidatePartyName,
          candidatePartySymbol: candidatePartySymbol,
          nominatedYear: nominatedYear);

      addCandidate(obj);
    }

    jsonBody.forEach((candidate) {
      log(candidate["candidateId"]);
    });
  }
}
