import 'package:flutter/foundation.dart';

class CandidateView {
  final int candidateId;
  final String candidateFirstName;
  final String candidateLastName;
  final Uint8List candidatePhoto;
  final String candidatePartyName;
  final Uint8List candidatePartySymbol;
  final String nominatedYear;

  CandidateView(
      this.candidateId,
      this.candidateFirstName,
      this.candidateLastName,
      this.candidatePhoto,
      this.candidatePartyName,
      this.candidatePartySymbol,
      this.nominatedYear);
}
