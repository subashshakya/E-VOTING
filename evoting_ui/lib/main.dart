// import 'package:evoting_ui/admin_widgets/imagepicker.dart';
import 'package:evoting_ui/theme/theme_constants.dart';
import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
import 'dart:io';
import './models/candidate.dart';
import './admin_widgets/newcandidate.dart';
import './theme/theme_manager.dart';

void main() => runApp(App());

ThemeManager _themeManager = ThemeManager();

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-VOTING',
      theme: darkTheme,
      // lightTheme: lightTheme,
      themeMode: _themeManager.themeMode,
      home: Admin(),
    );
  }
}

class Admin extends StatefulWidget {
  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  @override
  void dispose() {
    _themeManager.removeListener(themeListener);
    super.dispose();
  }

  @override
  void initState() {
    _themeManager.addListener(themeListener);
    super.initState();
  }

  themeListener() {
    if (mounted) {
      setState(() {});
    }
  }

  final List<Candidate> _candidates = [];

  void _addNewCandidate(
      String candidateID,
      String candidateName,
      File candidateImage,
      String candidatePartyName,
      File partySymbol,
      String test) {
    final newCandidate = Candidate(candidateID, candidateName, candidateImage,
        candidatePartyName, partySymbol, test);

    setState(() {
      _candidates.add(newCandidate);
    });
  }

  void _deleteCandidate(String Id) {
    setState(() {
      _candidates.removeWhere((candidate) {
        return candidate.candidateID == Id;
      });
    });
  }

  void _startAddNewCandidate(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (bCtx) {
          return GestureDetector(
            onTap: (() {}),
            child: NewCandidate(_addNewCandidate),
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ADMIN DASHBOARD'),
      ),
      body: SingleChildScrollView(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [CandidateList(_candidates, _deleteCandidate)],
      )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => _startAddNewCandidate(context)),
    );
  }
}

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
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              )
            : ListView.builder(
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 5,
                    margin:
                        EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: ListTile(
                        leading: CircleAvatar(
                            radius: 30,
                            child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Image.file(
                                    candidates[index].partySymbol!))),
                        title: Text(candidates[index].candidateName),
                        subtitle: Text(candidates[index].candidatePartyName),
                        trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => deleteCandidate(
                                candidates[index].candidateID))),
                  );
                },
                itemCount: candidates.length,
              ));
  }
}
