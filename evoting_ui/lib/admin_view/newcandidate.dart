import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class NewCandidate extends StatefulWidget {
  final Function addCandidate;

  NewCandidate(this.addCandidate);

  @override
  _NewCandidateState createState() => _NewCandidateState();
}

class _NewCandidateState extends State<NewCandidate> {
  final candidateID = TextEditingController();
  final candidateName = TextEditingController();
  File? candidatePhoto;
  final partyName = TextEditingController();
  File? partySymbol;
  String b64 = '';

  void _showDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              backgroundColor: Colors.grey,
              title: const Text('Alert!'),
              content: const Text('A new Candidate has been added'),
              actions: [
                MaterialButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('OK'))
              ]);
        });
  }

  Future<void> pickPartyImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);

      if (image == null) return;

      final imageTemp = File(image.path);

      setState(() {
        this.partySymbol = imageTemp;
      });

      // return imageTemp;
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<void> pickCandidateImage() async {
    try {
      final img = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (img == null) {
        return;
      }

      final image = File(img.path);

      final imageBytes = await image.readAsBytes();

      final base64 = base64Encode(imageBytes);

      // print("base 64: ____$base64");

      setState(() {
        this.candidatePhoto = image;
        this.b64 = base64;
      });
      // return image;
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<http.Response> sendJson() async {
    return http.post(
        Uri.parse('http://192.168.101.180:1214/api/Candidate/AddCandidate'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=utf-8',
        },
        body: jsonEncode(<String, String>{
          'CandidateFirstName': candidateName.text,
          'CandidateLastName': 'kupondole',
          'CandidatePhoto': b64,
          'CandidatePartyName': partyName.text,
          'CandidatePartySymbol': b64
        }));
  }

  void submitData() {
    final CandidateID = candidateID.text;
    final CandidateName = candidateName.text;
    final PartyName = partyName.text;

    if (CandidateID.isEmpty || CandidateName.isEmpty || PartyName.isEmpty) {
      return;
    }
    widget.addCandidate(CandidateID, CandidateName, candidatePhoto, PartyName,
        partySymbol, b64);
    sendJson();
    _showDialog();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 10,
        child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                TextField(
                    decoration:
                        InputDecoration(labelText: 'Enter Candidate ID'),
                    controller: candidateID,
                    onSubmitted: (_) => submitData()),
                const SizedBox(height: 10),
                TextField(
                    decoration:
                        InputDecoration(labelText: 'Enter Candidate Name'),
                    controller: candidateName,
                    onSubmitted: (_) => submitData()),
                const SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(labelText: 'Enter Party Name'),
                  controller: partyName,
                  onSubmitted: (_) => submitData(),
                ),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(width: 5),
                    CustomButton(
                        title: 'Candidate Image', onClick: pickCandidateImage),
                    const SizedBox(width: 15),
                    CustomButton(
                        title: 'Party Symbol', onClick: pickPartyImage),
                  ],
                ),
                ElevatedButton(
                    onPressed: submitData, child: const Text('Submit'))
              ],
            )));
  }
}

Widget CustomButton({required String title, required VoidCallback onClick}) {
  return Container(
      width: 180,
      child: ElevatedButton(
          onPressed: onClick,
          child: Row(
            children: [
              const Icon(Icons.image_outlined),
              Text(
                title,
                textAlign: TextAlign.left,
              ),
            ],
          )));
}
