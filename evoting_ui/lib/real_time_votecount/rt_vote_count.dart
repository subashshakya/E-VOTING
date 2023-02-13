import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RealTimeVoteCount extends StatefulWidget {
  @override
  State<RealTimeVoteCount> createState() => _RealTimeVoteCountState();
}

class _RealTimeVoteCountState extends State<RealTimeVoteCount> {
  StreamController _streamController = StreamController();

  @override
  void initState() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      getCount();
    });

    super.initState();
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  Future getCount() async {
    var response = await http.get(Uri.parse(''));

    var jsonRes = jsonDecode(response.body);
    log(jsonRes);
    int count = jsonRes["voteCount"];

    _streamController.sink.add(count);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: StreamBuilder(
        stream: _streamController.stream,
        builder: ((context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());
            default:
              if (snapshot.hasError) {
                return const Text("Please wait...");
              } else {
                return Container(
                    padding: const EdgeInsets.all(10),
                    child: Center(
                        child:
                            Text("Real Time Vote Count: ${snapshot.data!}")));
              }
          }
        }),
      ),
    ));
  }
}
