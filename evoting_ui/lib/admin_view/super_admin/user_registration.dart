import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'admin.dart';

class UserRegistration extends StatefulWidget {
  String token;
  UserRegistration(this.token);

  @override
  State<UserRegistration> createState() => _UserRegistrationState();
}

class _UserRegistrationState extends State<UserRegistration> {
  String url = '101.45';

  final voterId = TextEditingController();
  final citizenShipId = TextEditingController();
  final firstName = TextEditingController();
  final middleName = TextEditingController();
  final lastName = TextEditingController();
  DateTime dob = DateTime.now();
  final gender = TextEditingController();
  final address = TextEditingController();
  final state = TextEditingController();
  final district = TextEditingController();
  final wardNo = TextEditingController();
  final municipality = TextEditingController();
  bool isSubmitting = false;

  Future _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime(2000),
        firstDate: DateTime(1950),
        lastDate: DateTime(2004));
    if (picked != null && picked != dob) {
      setState(() {
        dob = picked;
      });
    }
    if (picked == DateTime.now()) {
      _showDialog("YOU ARE NOT QUALIFIED TO VOTE");
    }
  }

  void _showDialog(String dialog) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              backgroundColor: Colors.blueGrey,
              title: const Text("ALERT!",
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
              content: Text(dialog),
              actions: [
                MaterialButton(
                    onPressed: () {
                      if (dialog == "NEW USER IS ADDED") {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => Admin(widget.token))));
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('OK'))
              ]);
        });
  }

  void submitData() async {
    setState(() {
      isSubmitting = true;
    });

    // log(candidateImage_b64);

    final response = await http.post(
        Uri.parse('http://192.168.$url:1214/api/Voter/RegisterVoter'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=utf-8',
          "Authorization": 'Bearer ${widget.token}'
        },
        body: jsonEncode(<String, dynamic>{
          "VoterId": int.parse(voterId.text),
          "CitizenshipId": citizenShipId.text,
          "FirstName": firstName.text,
          "MiddleName": middleName.text,
          "LastName": lastName.text,
          "DateOfBirth": dob.toString(),
          "Gender": gender.text,
          "Address": address.text,
          "State": state.text,
          "District": district.text,
          "WardNo": wardNo.text,
          "Municipality": municipality.text
        }));

    // log(response.body.toString());
    setState(() {
      isSubmitting = false;
    });

    log(response.body);
    if (response.statusCode == 200) {
      _showDialog("NEW USER IS ADDED");
    } else {
      _showDialog("$response.body");
    }
    // Navigator.pop(context);
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        backgroundColor: Colors.white12,
        appBar: AppBar(title: const Text("ENTER VOTER DETAILS")),
        body: Container(
          color: Colors.black26,
          height: MediaQuery.of(context).size.height,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(1),
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Card(
              elevation: 10,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 50),
                    const Text(
                      "Enter Your VoterID",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 5),
                    TextFormField(
                        keyboardType: TextInputType.number,
                        decoration:
                            const InputDecoration(labelText: 'REQUIRED'),
                        controller: voterId,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "PLEASE ENTER VOTER ID";
                          }
                          if (!RegExp(r'^\d{6}$').hasMatch(value)) {
                            return "ENTERED CONTAINS MORE THAN 6 NUMBERS";
                          }
                        }),
                    const SizedBox(height: 20),
                    const Text(
                      "Enter Your Citizenship Number",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 5),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'REQUIRED'),
                      controller: citizenShipId,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "ENTER CITIZENSHIP NUMBER";
                        }
                        if (!RegExp(r'^\d{2}-\d{2}-\d{5}$').hasMatch(value)) {
                          return "INVALID FORMAT";
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Enter Your First Name",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 5),
                    TextFormField(
                        decoration:
                            const InputDecoration(labelText: 'REQUIRED'),
                        controller: firstName,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "PLEASE ENTER NAME";
                          }
                          if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
                            return "ENTERED VALUE HAS A NUMBER";
                          }
                        }),
                    const SizedBox(height: 20),
                    const Text(
                      "Enter Your Middle Name",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 5),
                    TextFormField(
                      decoration: const InputDecoration(labelText: ''),
                      controller: middleName,
                      // validator: (value) {
                      //   if (value == null || value.isEmpty) {
                      //     return "PLEASE ENTER MIDDLE NAME";
                      //   }
                      //   if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
                      //     return "ENTERED VALUE HAS A NUMBER";
                      //   }
                      // }),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Enter Your Last Name",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 5),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'REQUIRED'),
                      controller: lastName,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "PLEASE ENTER LAST NAME";
                        }
                        if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
                          return "ENTERED VALUE HAS A NUMBER";
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Enter Your Date Of Birth",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 5),
                    ElevatedButton(
                        onPressed: () => _selectDate(context),
                        child: const Text("Enter Your DoB",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 13))),
                    const SizedBox(height: 20),
                    const Text(
                      "Enter Your Gender",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 5),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'REQUIRED'),
                      controller: gender,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "PLEASE ENTER GENDER";
                        }
                        if (!RegExp(r'^(male|female)$').hasMatch(value)) {
                          return "ENTERED VALUE CONTAINS UNWANTED CHARACTERS";
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Enter Your Address",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 5),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'REQUIRED'),
                      controller: address,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "PLEASE ENTER AN ADDRESS";
                        }
                        if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
                          return "ENTERED VALUE HAS INVALID CHARACTERS";
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Enter Your State",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 5),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'REQUIRED'),
                      controller: state,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "PLEASE ENTER A STATE";
                        }
                        if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
                          return "ENTERED VALUE HAS INVALID CHARACTERS";
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Enter Your District",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 5),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'REQUIRED'),
                      controller: district,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "PLEASE ENTER A DISTRICT";
                        }
                        if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
                          return "ENTERED VALUE HAS INVALID CHARACTERS";
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Enter Your Ward Number",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 5),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'REQUIRED'),
                      controller: wardNo,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "PLEASE ENTER A WARD NUMBER";
                        }
                        if (!RegExp(r'^([1-9]|1[0-9]|22)$').hasMatch(value)) {
                          return "ENTER A VALUE WITHIN 1-22";
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Enter Your Municipality",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 5),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'REQUIRED'),
                      controller: municipality,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "PLEASE ENTER A MUNICIPALITTY";
                        }
                        if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
                          return "ENTERED VALUE HAS INVALID CHARACTERS";
                        }
                      },
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            submitData();
                          }
                        },
                        child: const Text("Submit")),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
