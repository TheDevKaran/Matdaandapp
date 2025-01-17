import 'package:flutter/material.dart';
import 'package:matdaandapp/services/functions.dart';
import 'package:web3dart/web3dart.dart';

class ElectionInfo extends StatefulWidget {
  final Web3Client ethClient;
  final String electionNAme;
  const ElectionInfo(
      {super.key, required this.ethClient, required this.electionNAme});

  @override
  State<ElectionInfo> createState() => _ElectionInfoState();
}

class _ElectionInfoState extends State<ElectionInfo> {
  TextEditingController addCandidateController = TextEditingController();
  TextEditingController authorizeVoterController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.electionNAme),
      ),
      body: Container(
        padding: EdgeInsets.all(14),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    FutureBuilder(
                        future: getCandidatesNum(widget.ethClient),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return Text(
                            snapshot.data![0].toString(),
                            style: TextStyle(
                                fontSize: 50, fontWeight: FontWeight.bold),
                          );
                        }),
                    Text('Total Candidates')
                  ],
                ),
                Column(
                  children: [
                    FutureBuilder(
                        future: getTotalVotes(widget.ethClient),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return Text(
                            snapshot.data![0].toString(),
                            style: TextStyle(
                                fontSize: 50, fontWeight: FontWeight.bold),
                          );
                        }),
                    Text('Total Votes')
                  ],
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                    child: TextField(
                  controller: addCandidateController,
                  decoration: InputDecoration(hintText: "Enter Candidate Name"),
                )),
                ElevatedButton(
                    onPressed: () {
                      addCandidate(
                          addCandidateController.text, widget.ethClient);
                    },
                    child: Text('Add Candidate'))
              ],
            ),
            Row(
              children: [
                Expanded(
                    child: TextField(
                  controller: authorizeVoterController,
                  decoration: InputDecoration(hintText: "Enter Voter address"),
                )),
                ElevatedButton(
                    onPressed: () {
                      authorizeVoter(
                          authorizeVoterController.text, widget.ethClient);
                    },
                    child: Text('Add Voter'))
              ],
            ),
            Divider(),
            FutureBuilder(
                future: getCandidatesNum(widget.ethClient),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return Column(
                      children: [
                        for (int i = 0; i < snapshot.data![0].toInt(); i++)
                          FutureBuilder(
                              future: candidateInfo(i, widget.ethClient!),
                              builder: (context, candidatesnapshot) {
                                if (candidatesnapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else {
                                  return ListTile(
                                    title:  Text('Name: '+ candidatesnapshot.data![0][0].toString()),
                                    subtitle: Text('Votes: '+candidatesnapshot.data![0][1].toString()),
                                    trailing: ElevatedButton(onPressed: (){
                                      vote(i, widget.ethClient);
                                    }, child: Text('Vote')),
                                  );
                                }
                              })
                      ],
                    );
                  }
                })
          ],
        ),
      ),
    );
  }
}
