import 'package:acrogate/views/Screens/Cards/HomepageCard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var dataLoaded = true;

  CollectionReference flatRef = FirebaseFirestore.instance.collection('Flats');

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getData();
  }

  Future<void> _getData() async {
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
            child: SizedBox(
              height: 500.0,
              child: Lottie.asset('assets/animations/loading.json'),
            ),
          )
        : Scaffold(
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
                  height: MediaQuery.of(context).size.height -
                      kBottomNavigationBarHeight,
                  padding: const EdgeInsets.only(bottom: 40, top: 20),
                  child: RefreshIndicator(
                    onRefresh: _getData,
                    child: Column(
                      children: [
                        Expanded(
                          child: StreamBuilder<QuerySnapshot>(
                            stream: flatRef.snapshots(),
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
                                          "No Flats Listed Yet !",
                                          style: kTextPopM16,
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  return ListView(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    children:
                                        snapshot.data!.docs.map((document) {
                                      return HomePageCard(
                                        name: document['Name'],
                                        flatNo: document['FlatNo'],
                                        wing: document['Wing'],
                                        imageUrl: '',
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
            ),
          );
  }
}
