import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RealTimeVoteCount extends StatefulWidget {
  String token;
  RealTimeVoteCount(this.token);
  @override
  State<RealTimeVoteCount> createState() => _RealTimeVoteCountState();
}

class _RealTimeVoteCountState extends State<RealTimeVoteCount> {
  final StreamController _streamController = StreamController(
    onCancel: () => log('cancelled'),
  );
  int count = 0;

  String url = '100.215';

  @override
  void initState() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      getCount();
    });
    // print("jashdjahsdjkhaksd");
    // log(widget.token);
    super.initState();
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  Future getCount() async {
    var response = await http.get(
        Uri.parse('http://192.168.$url:1214/api/SuperAdmin/GetCount'),
        headers: <String, String>{
          'Content-Type': 'application/json ;charset=utf-8',
          "Authorization": 'Bearer ${widget.token}',
        });
    log(response.body.toString());
    // var jsonRes = jsonDecode(response.body);
    var jsonRes = response.body;
    log(jsonRes[0]);
    // log(jsonRes[0].toString());
    setState(() {
      count = int.parse(jsonRes[1]) + int.parse(jsonRes[3]);
    });
    log(count.toString());
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
                return const Text(
                  "Please wait...",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                );
              } else {
                return Container(
                    padding: const EdgeInsets.all(10),
                    child: Center(
                        child: Text(
                      "Real Time Vote Count: ${snapshot.data!}",
                      style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    )));
              }
          }
        }),
      ),
    ));
  }
}
