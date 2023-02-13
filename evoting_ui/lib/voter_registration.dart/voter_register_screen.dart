import 'package:flutter/material.dart';

class VoterRegisterScreen extends StatefulWidget {
  @override
  State<VoterRegisterScreen> createState() => _VoterRegisterScreenState();
}

class _VoterRegisterScreenState extends State<VoterRegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                SingleChildScrollView(
                    child: Column(
                  children: [],
                )),
              ],
            )));
  }
}

Widget CustomCard({required String value}) {
  return Container(
      alignment: Alignment.center,
      height: 100,
      padding: const EdgeInsets.all(15),
      child: Card(
          elevation: 10,
          child: Column(
            children: [
              Text(
                "Enter your $value :",
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 10),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some value';
                  } else {}
                },
              )
            ],
          )));
}
