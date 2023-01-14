import 'package:flutter/material.dart';
import '../models/candidate.dart';

class CandidateList extends StatelessWidget {
  final List<Candidate> candidates;
  final Function deleteCandidate;

  CandidateList(this.candidates, this.deleteCandidate);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 450,
        child: candidates.isEmpty
            ? Container(
                margin: const EdgeInsets.all(100.0),
                child: const Text(
                  'NO CANDIDATES HAVE BEEN ADDED YET!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              )
            : ListView.builder(
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 5,
                    margin: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 5.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: ListTile(
                        leading: CircleAvatar(
                            radius: 30,
                            child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Image.file(
                                    candidates[index].candidatePartySymbol!))),
                        title: Text(candidates[index].candidateFirstName),
                        subtitle: Text(candidates[index].candidatePartyName),
                        trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => deleteCandidate(
                                candidates[index].candidateFirstName))),
                  );
                },
                itemCount: candidates.length,
              ));
  }
}
