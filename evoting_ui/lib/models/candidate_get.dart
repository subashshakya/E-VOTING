import 'dart:convert';

CandidateGet candidateGetFromJson(String str) =>
    CandidateGet.fromJson(json.decode(str));

class CandidateGet {
  CandidateGet({
    required this.candidateId,
    required this.candidateFirstName,
    required this.candidateLastName,
    required this.candidatePhoto,
    required this.candidatePartyName,
    required this.candidatePartySymbol,
    required this.nominatedYear,
  });

  final int candidateId;
  final String candidateFirstName;
  final String candidateLastName;
  final String candidatePhoto;
  final String candidatePartyName;
  final String candidatePartySymbol;
  final String nominatedYear;

  factory CandidateGet.fromJson(Map<String, dynamic> json) => CandidateGet(
        candidateId: json["candidateId"],
        candidateFirstName: json["candidateFirstName"],
        candidateLastName: json["candidateLastName"],
        candidatePhoto: json["candidatePhoto"],
        candidatePartyName: json["candidatePartyName"],
        candidatePartySymbol: json["candidatePartySymbol"],
        nominatedYear: json["nominatedYear"],
      );
}
