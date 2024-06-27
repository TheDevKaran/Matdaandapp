import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:matdaandapp/pages/electioninfo.dart';
import 'package:matdaandapp/services/functions.dart';
import 'package:matdaandapp/utils/constant.dart';
import 'package:web3dart/web3dart.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Client? httpClient;
  Web3Client? ethClient;
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    httpClient = Client();
    ethClient = Web3Client(infura_url, httpClient!);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Start Election'),
      ),
      body: Container(
        padding: EdgeInsets.all(14),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(
                filled: true,
                hintText: "Enter election Name"
              ),
            ),
            SizedBox(height: 20,),
            Container(
              height: 45,
              width: double.infinity,
                child: ElevatedButton(onPressed: () async{
                  if(controller.text.length>0) { await startElection(controller.text, ethClient!);
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>ElectionInfo(ethClient: ethClient!, electionNAme: controller.text)));
                  }
                }, child: Text('Start Election')))
          ],
        ),
      ),
    );
  }
}
