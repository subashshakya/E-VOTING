import 'package:evoting_ui/models/candidate_get.dart';
import 'package:evoting_ui/models/candidate_view.dart';
import 'package:flutter/material.dart';
import '../models/candidate.dart';

class CandidateList extends StatefulWidget {
  final List<CandidateView> candidates;
  final Function deleteCandidate;
  final Function getDetails;

  CandidateList(this.candidates, this.deleteCandidate, this.getDetails);

  @override
  State<CandidateList> createState() => _CandidateListState();
}

class _CandidateListState extends State<CandidateList> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 450,
        child: FutureBuilder(
            future: widget.getDetails(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return ListView.builder(
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 5,
                      margin: const EdgeInsets.symmetric(
                          vertical: 5.0, horizontal: 5.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      child: ListTile(
                          leading: CircleAvatar(
                              radius: 30,
                              child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Image.memory(widget.candidates[index]
                                      .candidatePartySymbol))),
                          title:
                              Text(widget.candidates[index].candidateFirstName),
                          subtitle:
                              Text(widget.candidates[index].candidatePartyName),
                          trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => widget.deleteCandidate(widget
                                  .candidates[index].candidateFirstName))),
                    );
                  },
                  itemCount: widget.candidates.length,
                );
              } else {
                return Card(
                    child: Container(
                  padding: const EdgeInsets.all(50),
                  child: Center(
                    child: Column(children: [
                      Text(
                        'Please wait as the candidate is being added',
                        style: TextStyle(fontSize: 20),
                      ),
                      CircularProgressIndicator(),
                    ]),
                  ),
                ));
              }
            }));
  }
}
