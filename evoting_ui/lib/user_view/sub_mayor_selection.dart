import 'dart:developer';
import 'package:evoting_ui/user_view/end_voting.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'dart:convert';

class SubMayorSelectableCandidate extends StatefulWidget {
  final int candidateId;
  final String candidateFirstName;
  final String candidateLastName;
  final Uint8List candidatePhoto;
  final Uint8List partySymbolBytes;
  final bool selected;
  final String token;
  final String encryptedVote;

  SubMayorSelectableCandidate(
      this.candidateId,
      this.candidateFirstName,
      this.candidateLastName,
      this.candidatePhoto,
      this.partySymbolBytes,
      this.selected,
      this.token,
      this.encryptedVote);

  @override
  State<SubMayorSelectableCandidate> createState() =>
      _SelectableCandidateState();
}

class _SelectableCandidateState extends State<SubMayorSelectableCandidate> {
  bool confirmation = false;
  String url = '100.215';
  String encryptedVotingDetails = '';

  Future sendVote() async {
    // checkConfirmation();
    if (confirmation) {
      String encryptedVote = Vencryption(widget.candidateId, "2079");
      log(encryptedVote);

      log(widget.encryptedVote);
      // print(completeEncryptedVote);
      log(encryptedVote);
      var response = await http.post(
          Uri.parse('http://192.168.$url:1214/api/VoteCount/AddVote'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=utf-8',
            'Authorization': 'Bearer ${widget.token}'
          },
          body: jsonEncode([
            <String, dynamic>{"ciphertext": widget.encryptedVote},
            {"ciphertext": encryptedVote}
          ]));

      log(response.body.toString());
      if (response.body == "Vote Added") {
        push();
      }
    }
    // } else {
    //   Navigator.pop(context);
    // }
  }

  String Vencryption(int id, String nominatedYear) {
    // final normalFormat = '1' + ":" + "2079";
    // log(normalFormat);
    final text =
        id.toString() + ":" + nominatedYear + ":" + DateTime.now().toString();
    final key = encrypt.Key.fromUtf8("MySuperSecretKey");
    final iv = encrypt.IV.fromUtf8("MySuperSecretKey");
    final encrypter = encrypt.Encrypter(
        encrypt.AES(key, padding: 'PKCS7', mode: encrypt.AESMode.cbc));

    final encrypted = encrypter.encrypt(text, iv: iv);
    // final decrypted = encrypter.decrypt(encrypted, iv: iv);
    final encryptedString = encrypted.base64;

    log(encryptedString);
    // log(decrypted);
    // log(encryptedString);
    return encryptedString;
  }

  void push() {
    Navigator.pushReplacement(
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
                            Text(candidateFirstName,
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            const SizedBox(
                              width: 3,
                            ),
                            Text(candidateLastName,
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            const SizedBox(width: 125),
                            MaterialButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Icon(Icons.cancel_outlined,
                                    size: 30, color: Colors.red))
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: <Widget>[
                            Text('photo_candidate'.tr,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(width: 57),
                            Image.memory(candidatePhoto,
                                height: 75, width: 75, fit: BoxFit.cover)
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: <Widget>[
                            Text('party_symbol'.tr,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(
                              width: 10,
                            ),
                            Image.memory(partySymbol,
                                height: 75, width: 75, fit: BoxFit.cover)
                          ],
                        ),
                        const SizedBox(height: 4),
                        ElevatedButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Material(
                                        type: MaterialType.transparency,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.white70),
                                          padding: const EdgeInsets.all(15),
                                          height: 100,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Column(
                                            children: [
                                              Container(
                                                  alignment: Alignment.center,
                                                  color: Colors.red,
                                                  height: 60,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  child: Text('confirm_vote'.tr,
                                                      style: const TextStyle(
                                                          fontSize: 22,
                                                          fontWeight: FontWeight
                                                              .bold))),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              Text(
                                                'confirmation'.tr,
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              const SizedBox(height: 40),
                                              SizedBox(
                                                height: 50,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    MaterialButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            confirmation = true;
                                                          });
                                                          sendVote();
                                                        },
                                                        child: const Icon(
                                                            Icons
                                                                .check_circle_outline,
                                                            size: 50,
                                                            color: Colors.red)),
                                                    MaterialButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: const Icon(
                                                            Icons
                                                                .cancel_outlined,
                                                            size: 50,
                                                            color: Colors.red))
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ));
                                  });
                            },
                            child: Text('vote'.tr))
                      ],
                    ))),
          );
        });
  }

  @override
  // encryption(1,'nominatedYear');
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
                  Text(widget.candidateFirstName,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold)),
                  const SizedBox(
                    width: 3,
                  ),
                  Text(widget.candidateLastName,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold))
                ])
              ],
            )));
  }
}
