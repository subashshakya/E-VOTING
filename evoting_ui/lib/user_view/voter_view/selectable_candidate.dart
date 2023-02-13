import 'dart:developer';
import 'package:evoting_ui/user_view/voter_view/end_voting.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SelectableCandidate extends StatefulWidget {
  final int candidateId;
  final String candidateFirstName;
  final String candidateLastName;
  final Uint8List candidatePhoto;
  final Uint8List partySymbolBytes;
  final bool selected;

  SelectableCandidate(
      this.candidateId,
      this.candidateFirstName,
      this.candidateLastName,
      this.candidatePhoto,
      this.partySymbolBytes,
      this.selected);

  @override
  State<SelectableCandidate> createState() => _SelectableCandidateState();
}

class _SelectableCandidateState extends State<SelectableCandidate> {
  bool confirmation = false;
  Future sendVote() async {
    checkConfirmation();
    if (confirmation) {
      var response = await http.post(Uri.parse(''),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=utf-8',
          },
          body: jsonEncode(<String, int>{"voterId": widget.candidateId}));

      log(response.toString());

      push();
    } else {
      Navigator.pop(context);
    }
  }

  checkConfirmation() {
    return showDialog(
        context: context,
        builder: (context) {
          return Card(
            elevation: 10,
            child: Column(children: <Widget>[
              const Text("Confirm Vote?"),
              const SizedBox(height: 20),
              Row(children: [
                MaterialButton(
                    onPressed: () {
                      setState(() {
                        confirmation = true;
                      });
                    },
                    child: const Icon(Icons.check_circle_outline)),
                MaterialButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons.cancel_outlined))
              ])
            ]),
          );
        });
  }

  void push() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SuccessVoting()));
  }

  showCandidateDetails(
      BuildContext context,
      String candidateFirstName,
      String candidateLastName,
      Uint8List candidatePhoto,
      Uint8List partySymbol) {
    return showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: Material(
                type: MaterialType.transparency,
                child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white38),
                    padding: const EdgeInsets.all(15),
                    width: 400,
                    height: 320,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(candidateFirstName),
                            const SizedBox(
                              width: 3,
                            ),
                            Text(candidateLastName),
                            const SizedBox(width: 50),
                            MaterialButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Icon(Icons.cancel_outlined))
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: <Widget>[
                            const Text("Photo Of Candidate: "),
                            const SizedBox(width: 10),
                            Image.memory(candidatePhoto)
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: <Widget>[
                            const Text("Party Symbol Of Candidate: "),
                            const SizedBox(
                              width: 10,
                            ),
                            Image.memory(partySymbol)
                          ],
                        ),
                        ElevatedButton(
                            onPressed: checkConfirmation,
                            child: const Text("VOTE"))
                      ],
                    ))),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(top: 19.0, bottom: 19.0),
        child: GestureDetector(
            onTap: () => showCandidateDetails(
                context,
                widget.candidateFirstName,
                widget.candidateLastName,
                widget.candidatePhoto,
                widget.partySymbolBytes),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.memory(widget.partySymbolBytes, fit: BoxFit.fill),
                Row(children: <Widget>[
                  Text(widget.candidateFirstName),
                  Text(widget.candidateLastName)
                ])
              ],
            )));
  }
}
