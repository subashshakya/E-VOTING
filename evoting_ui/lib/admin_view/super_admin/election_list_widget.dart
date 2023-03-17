import 'package:flutter/material.dart';
import './result.dart';
import 'dart:developer';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/election_list.dart';

class ElectionListWidget extends StatefulWidget {
  String token;
  ElectionListWidget(this.token);
  @override
  State<ElectionListWidget> createState() => _ElectionListWidgetState();
}

class _ElectionListWidgetState extends State<ElectionListWidget> {
  List<ElectionList> _electionList = [
    // ElectionList("2079", "General"),
    // ElectionList("2079", "Local")
  ];

  List<ElectionList> _fetchedData = [];
  String url = '100.215';
  Future getElectionList() async {
    var response = await http.get(
        Uri.parse('http://192.168.$url:1214/api/Election/GetElection'),
        headers: <String, String>{"Authorization": 'Bearer ${widget.token}'});
    final jsonBody = jsonDecode(response.body);

    for (Map<String, dynamic> election in jsonBody) {
      final ele =
          ElectionList(election["electionYear"], election["electionName"]);

      // log(ele.electionName.toString());
      setState(() {
        _fetchedData.add(ele);
      });

      if (_electionList.length != _fetchedData.length) {
        setState(() {
          _electionList = _fetchedData;
        });
      } else {
        setState(() {
          _electionList = _electionList;
        });
      }
      // _electionList.length;
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: getElectionList,
      child: SizedBox(
        height: 200,
        child: ListView.builder(
            itemCount: _electionList.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 10,
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                Result(widget.token, _electionList)));
                  },
                  style: ListTileStyle.list,
                  title: Text(_electionList[index].electionName!),
                  trailing: Text(_electionList[index].electionYear!),
                ),
              );
            }),
      ),
    );
  }
}
