import 'dart:io';

class Candidate {
  String candidateFirstName;
  String candidateLastName;
  File? candidatePhoto;
  String candidatePartyName;
  File? candidatePartySymbol;
  Candidate(
    this.candidateFirstName,
    this.candidateLastName,
    this.candidatePhoto,
    this.candidatePartyName,
    this.candidatePartySymbol,
  );
}
