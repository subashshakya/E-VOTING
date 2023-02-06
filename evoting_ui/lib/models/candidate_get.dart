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
}
