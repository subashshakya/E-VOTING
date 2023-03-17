import 'dart:typed_data';

import 'package:flutter/material.dart';

class Prediction extends StatefulWidget {
  int votePrediction;
  String candidateFirstName;
  String candidateLastName;
  Uint8List candidatePhoto;
  String candidatePartyName;
  Uint8List partySymbol;

  Prediction(
      this.votePrediction,
      this.candidateFirstName,
      this.candidateLastName,
      this.candidatePhoto,
      this.candidatePartyName,
      this.partySymbol);
  @override
  State<Prediction> createState() => _PredictionState();
}

class _PredictionState extends State<Prediction> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white12,
      body: Container(
          child: Column(
        children: [
          const SizedBox(height: 80),
          const Text(
            "VOTE PREDICTION OF CANDIDATE:",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 30,
          ),
          const Divider(
            thickness: 4,
          ),
          Card(
            elevation: 10,
            child: Container(
              alignment: Alignment.center,
              height: 100,
              child: Column(children: [
                const SizedBox(height: 10),
                const Text("Candidate Name: ",
                    style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(widget.candidateFirstName,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 8),
                    Text(widget.candidateLastName,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold))
                  ],
                ),
              ]),
            ),
          ),
          const SizedBox(height: 20),
          const Text("Candidate Photo:",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          Container(
            height: 80,
            width: 80,
            alignment: Alignment.center,
            child: Image.memory(
              widget.candidatePhoto,
              fit: BoxFit.cover,
            ),
          ),
          const Divider(
            thickness: 4,
          ),
          const Text("Party Information: ",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(widget.candidatePartyName,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(width: 20),
              SizedBox(
                  height: 80,
                  width: 80,
                  child: Image.memory(widget.partySymbol))
            ],
          ),
          const Divider(
            thickness: 4,
          ),
          const SizedBox(height: 20),
          Card(
            elevation: 10,
            child: Column(
              children: [
                const Text("Prediction: ",
                    style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Text(widget.votePrediction.toString(),
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold))
              ],
            ),
          )
        ],
      )),
    );
  }
}
