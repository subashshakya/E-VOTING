import 'dart:io';

// import 'package:image_picker/image_picker.dart';

class Candidate {
  String candidateID;
  String candidateName;
  File? candidateImage;
  String candidatePartyName;
  File? partySymbol;
  String test;
  Candidate(this.candidateID, this.candidateName, this.candidateImage,
      this.candidatePartyName, this.partySymbol, this.test);
}
