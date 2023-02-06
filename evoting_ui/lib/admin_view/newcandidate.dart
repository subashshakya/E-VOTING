// ignore_for_file: library_private_types_in_public_api, non_constant_identifier_names

import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class NewCandidate extends StatefulWidget {
  // final Function addCandidate;

  // NewCandidate(this.addCandidate);

  @override
  _NewCandidateState createState() => _NewCandidateState();
}

class _NewCandidateState extends State<NewCandidate> {
  final candidateFirstName = TextEditingController();
  final candidateLastName = TextEditingController();
  File? candidatePhoto;
  final partyName = TextEditingController();
  File? partySymbol;
  String candidateImage_b64 = '';
  String partySymbol_b64 = '';
  bool isSubmitting = false;

  void _showDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              backgroundColor: Colors.blueGrey,
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
      // print(imageTemp);
      final imageByte = await imageTemp.readAsBytes();
      final base64 = base64Encode(imageByte);

      setState(() {
        this.partySymbol = imageTemp;
        this.partySymbol_b64 = base64;
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
        this.candidateImage_b64 = base64;
      });
      // return image;
    } on PlatformException catch (e) {
      print(e);
    }
  }

  // Future sendJson() async {
  //   return http.post(
  //       Uri.parse('http://192.168.101.162:1214/api/Candidate/AddCandidate'),
  //       headers: <String, String>{
  //         'Content-Type': 'application/json; charset=utf-8',
  //       },
  //       body: jsonEncode(<String, String>{
  //         'CandidateFirstName': candidateFirstName.text,
  //         'CandidateLastName': candidateLastName.text,
  //         'CandidatePhoto': candidateImage_b64,
  //         'CandidatePartyName': partyName.text,
  //         'CandidatePartySymbol': partySymbol_b64
  //       }));
  // }

  void submitData() async {
    setState(() {
      isSubmitting = true;
    });

    log(candidateImage_b64);

    final response = await http.post(
        Uri.parse('http://192.168.137.250:1214/api/Candidate/AddCandidate'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=utf-8',
        },
        body: jsonEncode(<String, String>{
          'CandidateFirstName': candidateFirstName.text,
          'CandidateLastName': candidateLastName.text,
          'CandidatePhoto': candidateImage_b64,
          'CandidatePartyName': partyName.text,
          'CandidatePartySymbol': partySymbol_b64,
          'nominatedYear': "2079"
        }));

    log(response.body.toString());
    setState(() {
      isSubmitting = false;
    });
    _showDialog();
    // Navigator.pop(context);
  }

  // void submitData() {
  //   final CandidateFirstName = candidateFirstName.text;
  //   final CandidateLastName = candidateLastName.text;
  //   final PartyName = partyName.text;

  //   // if (CandidateFirstName.isEmpty ||
  //   //     CandidateLastName.isEmpty ||
  //   //     PartyName.isEmpty) {
  //   //   return;
  //   // }
  //   sendJson().then(
  //     (value) {
  //       widget.addCandidate(CandidateFirstName, CandidateLastName,
  //           candidatePhoto, PartyName, partySymbol, candidateImage_b64);
  //       Navigator.pop(context);
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 10,
        child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 100,
                ),
                const Text("Enter Candidate Details",
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                TextField(
                    decoration: const InputDecoration(
                        labelText: 'Enter Candidate First Name'),
                    controller: candidateFirstName,
                    onSubmitted: (_) => submitData()),
                const SizedBox(height: 10),
                TextField(
                    decoration: const InputDecoration(
                        labelText: 'Enter Candidate Name'),
                    controller: candidateLastName,
                    onSubmitted: (_) => submitData()),
                const SizedBox(height: 10),
                TextField(
                  decoration:
                      const InputDecoration(labelText: 'Enter Party Name'),
                  controller: partyName,
                  onSubmitted: (_) => submitData(),
                ),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(width: 5),
                    customButton(
                        title: 'Candidate Image', onClick: pickCandidateImage),
                    const SizedBox(width: 15),
                    customButton(
                        title: 'Party Symbol', onClick: pickPartyImage),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    onPressed: submitData, child: const Text('Submit'))
              ],
            )));
  }
}

Widget customButton({required String title, required VoidCallback onClick}) {
  return Container(
      width: 180,
      child: ElevatedButton(
          onPressed: onClick,
          child: Row(
            children: [
              const Icon(Icons.image_outlined),
              const SizedBox(
                width: 10,
              ),
              Text(
                title,
                textAlign: TextAlign.left,
              ),
            ],
          )));
}
