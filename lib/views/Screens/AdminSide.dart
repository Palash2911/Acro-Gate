import 'package:acrogate/views/Screens/Cards/AdminCard.dart';
import 'package:acrogate/views/Screens/Cards/AdminListCard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class AdminSide extends StatefulWidget {
  static var routeName = "/admin";
  const AdminSide({Key? key}) : super(key: key);

  @override
  State<AdminSide> createState() => _AdminSideState();
}

class _AdminSideState extends State<AdminSide> {
  CollectionReference entryRef =
      FirebaseFirestore.instance.collection('Entries');

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: const EdgeInsets.fromLTRB(12.0, 2.0, 0.0, 0.0),
          child: Text(
            'Acro Gate',
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.8,
            child: Column(
              children: [
                const SizedBox(height: 8.0),
                const AdminCard(),
                const SizedBox(height: 8.0),
                const Text(
                  "Approval Requests:",
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream:
                        entryRef.snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        if (snapshot.data!.docs.isEmpty) {
                          return Center(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 130.0,
                                  child: Image.asset(
                                    'assets/images/noPost.png',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                Text(
                                  "No Entries Yet !",
                                  style: kTextPopM16,
                                ),
                              ],
                            ),
                          );
                        } else {
                          return ListView(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            children: snapshot.data!.docs.map((document) {
                              return AdminListCard(
                                dname: document['DName'],
                                flatNo: document['FlatNo'],
                                wing: document['Wing'],
                                approve: document['Approve'],
                              );
                            }).toList(),
                          );
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
