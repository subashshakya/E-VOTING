// ignore_for_file: library_private_types_in_public_api, non_constant_identifier_names

import 'dart:convert';
import 'dart:developer';
import 'package:evoting_ui/admin_view/customs/drop_down_option.dart';
import 'package:evoting_ui/admin_view/super_admin/admin.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../models/candidate_post.dart';
import '../customs/button.dart';

class NewCandidate extends StatefulWidget {
  String token;
  NewCandidate(this.token);

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
  final candidateFirstNameRomanized = TextEditingController();
  final candidateLastNameRomanized = TextEditingController();
  final candidatePartyNameRomanized = TextEditingController();
  final nominatedYearRomanized = TextEditingController();
  final nominatedYear = TextEditingController();

  String url = '101.45';

  List<CandidatePost> _candidatePosts = [];

  @override
  void initState() {
    // getCandidatePostInfo();
    super.initState();
  }

  List posts = [
    {"postId": 1, "electionTypeId": 1, "postName": "Mayor"},
    {"postId": 2, "electionTypeId": 1, "postName": "Deputy Mayor"},
  ];
  String post = 'Mayor';
  int postId = 0;
  // Future getCandidatePostInfo() async {
  //   final response = await http.post(
  //       Uri.parse('http://192.168.$url:1214/api/Election/GetNominationPost'),
  //       headers: <String, String>{
  //         'Content-Type': 'application/json; charset=utf-8',
  //         'Authorization': 'Bearer ${widget.token}',
  //       },
  //       body: jsonEncode(
  //           <String, dynamic>{"ElectionTypeId": 1, "ElectionName": "0"}));

  //   final jsonBody = jsonDecode(response.body);

  //   for (Map<String, dynamic> post in jsonBody) {
  //     final candidates = CandidatePost(
  //         post["postId"], post["electionTypeId"], post["postName"]);

  //     log(candidates.postName);

  //     setState(() {
  //       _candidatePosts.add(candidates);
  //     });
  //   }
  // }

  void _showDialog(String msg) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              backgroundColor: Colors.blueGrey,
              title: const Text('Alert!'),
              content: Text(msg),
              actions: [
                MaterialButton(
                    onPressed: () {
                      if (msg == "NEW CANDIDATE IS ADDED") {
                        push();
                      } else {
                        Navigator.pop(context);
                      }
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

  void submitData() async {
    setState(() {
      isSubmitting = true;
    });

    // log(candidateImage_b64);

    final response = await http.post(
        Uri.parse('http://192.168.$url:1214/api/Candidate/AddCandidate'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=utf-8',
          "Authorization": 'Bearer ${widget.token}'
        },
        body: jsonEncode(<String, dynamic>{
          'candidateFirstName': candidateFirstName.text,
          'candidateLastName': candidateLastName.text,
          'candidatePhoto': candidateImage_b64,
          'candidatePartyName': partyName.text,
          'candidatePartySymbol': partySymbol_b64,
          'RomanizedCandidateFirstName': candidateFirstNameRomanized.text,
          'RomanizedCandidateLastName': candidateLastNameRomanized.text,
          'RomanizedCandidatePartyName': candidatePartyNameRomanized.text,
          'RomanizedNominatedYear': nominatedYearRomanized.text,
          'NominatedYear': nominatedYear.text,
          'NominatedPostId': postId,
          'PostId': postId
        }));

    log(response.body.toString());
    setState(() {
      isSubmitting = false;
    });

    if (response.body.toString() == "true") {
      _showDialog("NEW CANDIDATE IS ADDED");
    } else {
      _showDialog("$response.body");
    }

    // Navigator.pop(context);
  }

  void push() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: ((context) => Admin(widget.token))));
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white12,
        appBar: AppBar(
          title: const Text("CANDIDATE REGISTRATION"),
          centerTitle: true,
          // automaticallyImplyLeading: false,
        ),
        body: Container(
            color: Colors.black26,
            height: 700,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(1),
            width: MediaQuery.of(context).size.width,
            child: Padding(
                padding: const EdgeInsets.all(5),
                child: Card(
                    elevation: 10,
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            const SizedBox(
                              height: 30,
                            ),
                            const Text("Enter Candidate Details",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 20),
                            const Text(
                              "Candidate First Name",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            const SizedBox(height: 5),
                            TextFormField(
                              decoration: const InputDecoration(
                                  labelText: 'Enter Candidate First Name'),
                              controller: candidateFirstName,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "PLEASE ENTER A FIRST NAME";
                                }
                                if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
                                  return "ENTERED VALUE HAS INVALID CHARACTERS";
                                }
                              },
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                  labelText:
                                      'उम्मेदवारको पहिलो नाम प्रविष्ट गर्नुहोस्'),
                              controller: candidateFirstNameRomanized,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "उम्मेदवारको पहिलो नाम प्रविष्ट गर्नुहोस्";
                                }
                                if (!RegExp(r'^[\u0900-\u097F]+$')
                                    .hasMatch(value)) {
                                  return "ENTERED VALUE HAS INVALID CHARACTERS";
                                }
                              },
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              "Candidate Last Name",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            const SizedBox(height: 5),
                            TextFormField(
                                decoration: const InputDecoration(
                                    labelText: 'Enter Candidate Last Name'),
                                controller: candidateLastName,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "PLEASE ENTER A LAST NAME";
                                  }
                                  if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
                                    return "ENTERED VALUE HAS INVALID CHARACTERS";
                                  }
                                }),
                            const SizedBox(height: 5),
                            TextFormField(
                              decoration: const InputDecoration(
                                  labelText:
                                      'उम्मेदवारको अन्तिम नाम प्रविष्ट गर्नुहोस्'),
                              controller: candidateLastNameRomanized,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "उम्मेदवारको अन्तिम नाम प्रविष्ट गर्नुहोस्";
                                }
                                if (!RegExp(r'^[\u0900-\u097F]+$')
                                    .hasMatch(value)) {
                                  return "ENTERED VALUE HAS INVALID CHARACTERS";
                                }
                              },
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              "Candidate Party Name Details",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            const SizedBox(height: 5),
                            TextFormField(
                              decoration: const InputDecoration(
                                  labelText: 'Enter Party Name'),
                              controller: partyName,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "PLEASE ENTER A PARTY NAME";
                                }
                                if (!RegExp(r'^[a-zA-Z\s\p{P}]+$')
                                    .hasMatch(value)) {
                                  return "ENTERED VALUE HAS INVALID CHARACTERS";
                                }
                              },
                            ),
                            const SizedBox(height: 5),
                            TextFormField(
                                decoration: const InputDecoration(
                                    labelText:
                                        'पार्टीको नाम प्रविष्ट गर्नुहोस्'),
                                controller: candidatePartyNameRomanized,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "PLEASE ENTER A PARTY NAME IN NEPALI";
                                  }
                                  if (!RegExp(r'^[\u0900-\u097F]+$')
                                      .hasMatch(value)) {
                                    return "ENTERED VALUE HAS INVALID CHARACTERS";
                                  }
                                }),
                            const SizedBox(height: 10),
                            const Text(
                              "Candidate Image Details",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            const SizedBox(height: 5),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(width: 5),
                                CustomButton(
                                    title: 'Candidate Image',
                                    func: pickCandidateImage),
                                const SizedBox(width: 15),
                                CustomButton(
                                    title: 'Party Symbol',
                                    func: pickPartyImage),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              "Candidate Nominated Year Details",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            const SizedBox(height: 5),
                            TextFormField(
                              decoration: const InputDecoration(
                                  labelText: 'Enter Nominated Year'),
                              controller: nominatedYear,
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "PLEASE ENTER NOMINATED YEAR";
                                }
                                if (!RegExp(r'^\d{4}$').hasMatch(value)) {
                                  return "ENTERED ONLY FOUR DIGITS";
                                }
                              },
                            ),
                            const SizedBox(height: 5),
                            TextFormField(
                              decoration: const InputDecoration(
                                  labelText: 'मनोनित वर्ष प्रविष्ट गर्नुहोस्'),
                              controller: nominatedYearRomanized,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "PLEASE ENTER NOMINATED YEAR IN NEPALI";
                                }
                                if (!RegExp(r'^[०१२३४५६७८९]{4}$')
                                    .hasMatch(value)) {
                                  return "ENTERED VALUE VALUE IN NEPALI";
                                }
                              },
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              "Select Candidate Post:",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            const SizedBox(height: 5),
                            Container(
                                height: 50,
                                padding: const EdgeInsets.all(0),
                                child: ListView(
                                  children: [
                                    InputDecorator(
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                          ),
                                          contentPadding:
                                              const EdgeInsets.all(10)),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                            isDense: true,
                                            isExpanded: true,
                                            menuMaxHeight: 200,
                                            items: posts
                                                .map<DropdownMenuItem<String>>(
                                                    (post) {
                                              return DropdownMenuItem<String>(
                                                  value: post["postId"]
                                                      .toString(), //use post if bugs arrive
                                                  child: Text(post["postName"]
                                                      .toString()));
                                            }).toList(),
                                            onChanged: (value) {
                                              log(value!);

                                              if (value.toString() == 'Mayor') {
                                                setState(() {
                                                  postId = int.parse(value);
                                                  log(postId.toString());
                                                });
                                              } else {
                                                setState(() {
                                                  postId = int.parse(value);
                                                  // log(postId.toString());
                                                });
                                              }
                                            }),
                                      ),
                                    )
                                  ],
                                )),
                            const SizedBox(height: 10),
                            ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    submitData();
                                  }
                                },
                                child: const Text('Submit'))
                          ],
                        ),
                      ),
                    )))));
  }
}
