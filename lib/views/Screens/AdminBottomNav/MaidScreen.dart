import 'package:acrogate/providers/entry_provider.dart';
import 'package:acrogate/views/Screens/Cards/HomepageCard.dart';
import 'package:acrogate/views/Screens/Cards/MaidCard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';

class MaidScreen extends StatefulWidget {
  const MaidScreen({Key? key}) : super(key: key);

  @override
  State<MaidScreen> createState() => _MaidScreenState();
}

class _MaidScreenState extends State<MaidScreen> {
  var dataLoaded = true;

  CollectionReference maidRef = FirebaseFirestore.instance.collection('Maids');

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getData();
  }

  Future<void> _getData() async {
    setState(() {
      dataLoaded = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return dataLoaded
        ? Container(
            alignment: Alignment.center,
            height: double.infinity,
            width: double.infinity,
            child: const CircularProgressIndicator(),
          )
        : Scaffold(
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
                      'Maid Entries',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: SafeArea(
                child: Container(
                  height: MediaQuery.of(context).size.height -
                      4 * kBottomNavigationBarHeight,
                  padding: const EdgeInsets.only(bottom: 40, top: 20),
                  child: Column(
                    children: [
                      Expanded(
                        child: StreamBuilder<QuerySnapshot>(
                          stream: maidRef.orderBy('FlatNo').snapshots(),
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
                                        height: 300.0,
                                        child: Image.asset(
                                          'assets/images/noPost.png',
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                      const SizedBox(height: 20.0),
                                      Text(
                                        "No Maids Registered Yet !",
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
                                    return MaidCard(
                                      name: document['MaidName'],
                                      flatNo: document['FlatNo'],
                                      wing: document['Wing'],
                                      number: document['MaidPhoneNo'],
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
