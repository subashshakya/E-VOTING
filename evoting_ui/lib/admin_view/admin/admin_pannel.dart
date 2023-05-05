import 'package:flutter/material.dart';
import 'dart:developer';
import './view_only_candidate_list.dart';
import '../../real_time_votecount/rt_vote_count.dart';
// import './piechart.dart';

class AdminPannel extends StatefulWidget {
  String token;
  AdminPannel(this.token);
  @override
  State<AdminPannel> createState() => _AdminPannelState();
}

class _AdminPannelState extends State<AdminPannel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white12,
      appBar: AppBar(
        title: const Text("ADMIN PANNEL"),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        height: 700,
        child: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
                elevation: 12,
                child: Column(children: [
                  const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      child: Text("Candidate List: ",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold))),
                  const Divider(
                    thickness: 3,
                    color: Colors.black38,
                  ),
                  CandidateList(widget.token)
                ])),
            Card(
                elevation: 10,
                child: Column(
                  children: [
                    const Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        child: Text("Real Time Vote Count: ",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold))),
                    const Divider(thickness: 2, color: Colors.black38),
                    Container(
                        height: 200,
                        width: 200,
                        padding: const EdgeInsets.all(10),
                        color: Colors.black12,
                        child: RealTimeVoteCount(widget.token)),
                  ],
                )),
            // ElevatedButton(
            //     onPressed: () {
            //       Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //               builder: (context) => PieChartPage(widget.token)));
            //     },
            //     child: const Text("View Voting Details"))
          ],
        )),
      ),
    );
  }
}
