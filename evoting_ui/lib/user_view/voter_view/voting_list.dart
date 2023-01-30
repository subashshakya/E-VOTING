import 'package:flutter/material.dart';

class VotingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('Voting Screen', style: TextStyle(fontSize: 19))),
        body: GridView.count(
          crossAxisCount: 4,
          mainAxisSpacing: 13,
          crossAxisSpacing: 13,
        ));
  }
}
