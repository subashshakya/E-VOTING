import 'package:flutter/material.dart';
import 'dart:developer';

class DropDown extends StatefulWidget {
  const DropDown({super.key});

  @override
  State<DropDown> createState() => _DropDownState();
}

class _DropDownState extends State<DropDown> {
  List posts = [
    {"postId": 1, "electionTypeId": 1, "postName": "Mayor"},
    {"postId": 2, "electionTypeId": 1, "postName": "Deputy Mayor"},
  ];

  String post = '';

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            InputDecorator(
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  contentPadding: const EdgeInsets.all(10)),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                    isDense: true,
                    isExpanded: true,
                    menuMaxHeight: 200,
                    items: posts.map<DropdownMenuItem<String>>((item) {
                      return DropdownMenuItem<String>(
                          value: post, child: Text(item["postName"]));
                    }).toList(),
                    onChanged: (value) {
                      log(value.toString());
                      setState(() {
                        post = value.toString();
                      });
                    }),
              ),
            )
          ],
        ));
  }
}
