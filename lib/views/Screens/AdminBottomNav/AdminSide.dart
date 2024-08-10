import 'package:acrogate/views/Screens/Cards/AdminCard.dart';
import 'package:acrogate/views/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
                'Acro Gate',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.8,
            child: const Center(
              child: AdminCard(),
            ),
            // child: const Column(
            //   children: [
            //     SizedBox(height: 8.0),
            //     AdminCard(),
            // SizedBox(height: 8.0),
            // Text(
            //   "Approval Requests:",
            //   style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            // ),
            // const SizedBox(height: 8.0),
            // Expanded(
            //   child: StreamBuilder<QuerySnapshot>(
            //     stream:
            //         entryRef.snapshots(),
            //     builder: (context, snapshot) {
            //       if (!snapshot.hasData) {
            //         return const Center(
            //           child: CircularProgressIndicator(),
            //         );
            //       } else {
            //         if (snapshot.data!.docs.isEmpty) {
            //           return Center(
            //             child: Column(
            //               children: [
            //                 SizedBox(
            //                   height: 130.0,
            //                   child: Image.asset(
            //                     'assets/images/noPost.png',
            //                     fit: BoxFit.contain,
            //                   ),
            //                 ),
            //                 Text(
            //                   "No Entries Yet !",
            //                   style: kTextPopM16,
            //                 ),
            //               ],
            //             ),
            //           );
            //         } else {
            //           return ListView(
            //             scrollDirection: Axis.vertical,
            //             shrinkWrap: true,
            //             children: snapshot.data!.docs.map((document) {
            //               return AdminListCard(
            //                 dname: document['DName'],
            //                 flatNo: document['FlatNo'],
            //                 wing: document['Wing'],
            //                 approve: document['Approve'],
            //               );
            //             }).toList(),
            //           );
            //         }
            //       }
            //     },
            //   ),
            // ),
            // ],
            // ),
          ),
        ),
      ),
    );
  }
}
