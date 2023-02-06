import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SelectableCandidate extends StatelessWidget {
  final String candidateName;
  final VoidCallback ontap;
  final Uint8List partySymbolBytes;
  final bool selected;

  SelectableCandidate(
      this.candidateName, this.ontap, this.partySymbolBytes, this.selected);

  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(top: 19.0, bottom: 19.0),
        child: InkWell(
            onTap: ontap,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.memory(partySymbolBytes, fit: BoxFit.fill),
                Text(candidateName),
                selected ? const Icon(Icons.check) : Container(),
              ],
            )));
  }
}
