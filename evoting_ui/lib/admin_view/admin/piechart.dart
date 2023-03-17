import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:developer';
import '../../models/election_result.dart';

class PieChartPage extends StatefulWidget {
  String token = '';
  PieChartPage(this.token);

  @override
  State<PieChartPage> createState() => _PieChartState();
}

class _PieChartState extends State<PieChartPage> {
  @override
  void initState() {
    getResult();
    dataMapForPieChart();
    super.initState();
  }

  Map<String, double> dataMap = {};

  String url = '100.215';
  List<ElectionResult> _results = [];
  Future getResult() async {
    log(widget.token);
    var response = await http.post(
        Uri.parse('http://192.168.$url:1214/api/Election/GetResult'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=utf-8',
          "Authorization": 'Bearer ${widget.token}'
        },
        body: jsonEncode(<String, String>{"Year": "2079"}));

    final jsonBody = jsonDecode(response.body);
    for (Map<String, dynamic> res in jsonBody) {
      final result = ElectionResult(
          res["candidateFirstName"],
          res["candidateLastName"],
          res["candidatePartyName"],
          res["year"],
          res["voteReceived"],
          res["postName"]);

      log(result.candidatePartyName);
      setState(() {
        _results.add(result);
      });
    }
  }

  void dataMapForPieChart() {
    Map<String, double> dataMapPie = {};
    for (int i = 0; i < _results.length; i++) {
      Map<String, double> dataMapPie = {
        _results[i].candidatePartyName: _results[i].voteReceived.toDouble()
      };
    }
    setState(() {
      dataMap = dataMapPie;
    });
  }

  final colorList = <Color>[Colors.blueAccent];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            alignment: Alignment.center,
            child: PieChart(
              dataMap: dataMap,
              animationDuration: const Duration(seconds: 1),
              colorList: colorList,
            )));
  }
}
