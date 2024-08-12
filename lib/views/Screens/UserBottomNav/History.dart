import 'package:acrogate/views/Screens/Cards/NotificationCard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/auth_provider.dart';
import '../../constants.dart';

class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  CollectionReference entryRef = FirebaseFirestore.instance.collection('Users');

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getEntry();
  }

  Future<void> _getEntry() async {
    var authToken = Provider.of<Auth>(context, listen: false).token;
    setState(() {
      entryRef = entryRef.doc(authToken).collection("Entries");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 10),
        child: Container(
          decoration: BoxDecoration(
            color: kprimaryColor,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(18.0),
              bottomRight: Radius.circular(18.0),
            ),
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            toolbarHeight: kToolbarHeight + 70,
            iconTheme: IconThemeData(
              color: Colors.white,
              size: 27,
            ),
            centerTitle: false,
            title: const Padding(
              padding: EdgeInsets.only(left: 15.0),
              child: Text(
                'Entries',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height - kBottomNavigationBarHeight,
        padding: const EdgeInsets.only(left: 18, right: 18, top: 5, bottom: 10),
        child: Column(
          children: [
            const SizedBox(height: 30.0),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: entryRef
                    .orderBy("Date", descending: true)
                    .orderBy("Time", descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return ListView(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      children: snapshot
                              .data!.docs.isNotEmpty // Check if there's data
                          ? snapshot.data!.docs.map((document) {
                              return NotificationCard(
                                DName: document['DName'],
                                nid: document.id,
                                status: document['Approve'],
                                url: document['FirebaseUrl'],
                                phone: document['PhoneNo'],
                                date: document['Date'],
                                time: document['Time'],
                              );
                            }).toList()
                          : [
                              Column(
                                children: [
                                  SizedBox(
                                    height: 300.0,
                                    child: Image.asset(
                                      'assets/images/noPost.png',
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  const SizedBox(height: 20.0),
                                  Text(
                                    "No Entries Yet !",
                                    style: kTextPopM16,
                                  ),
                                ],
                              ),
                            ],
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
