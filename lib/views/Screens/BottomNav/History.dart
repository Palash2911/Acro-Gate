import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../constants.dart';

class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {

  Future<void> _getEntry() async {
    // var authToken = Provider.of<Auth>(context, listen: false).token;
    // await Provider.of<UserProvider>(context, listen: false)
    //     .getUserDetails(authToken)
    //     .then((value) {
    //   setState(() {
    //     name = value!.name;
    //     uid = value.id;
    //     flatNo = value.flatNo;
    //     wing = value.wing;
    //     url = value.firebaseUrl;
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: const EdgeInsets.fromLTRB(12.0, 2.0, 0.0, 0.0),
          child: Text(
            'History',
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _getEntry,
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 30.0),
              SizedBox(
                height: 300.0,
                child: Image.asset(
                  'assets/images/noPost.png',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 10.0),
              Text(
                "No Recent Entries Yet !",
                style: kTextPopM16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
