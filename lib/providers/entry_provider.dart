import 'package:acrogate/models/entries.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EntryProvider extends ChangeNotifier {
  Future<bool> newEntry(Entry entry) async {
    try {
      CollectionReference entries =
          FirebaseFirestore.instance.collection('Entries');
      CollectionReference user =
          FirebaseFirestore.instance.collection('Users');

      var flatId = "";
      var entryData = {
        "DName": entry.dname,
        "Approve": entry.status,
        "FID": flatId,
        "FlatNo": entry.flatNo,
        "Wing": entry.wing,
      };

      final querySnapshot = await user
          .where('FlatNo', isEqualTo: entry.flatNo)
          .where('Wing', isEqualTo: entry.wing)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        flatId = querySnapshot.docs[0].id;
        entryData['FID'] = flatId;
        print('Flat ID: $flatId');
        var docref = await entries.add(entryData);
        var eid = docref.id;
        await user.doc(flatId).collection('Entries').doc(eid).set(entryData);
        return true; // Document found
      } else {
        print('Flat not found');
        return false; // Document not found
      }
    } catch (e) {
      print('Error: $e');
      return false; // Document not found (due to error)
    }
  }

  Future<String> getToken(flatNo, wing) async {
    try {
      CollectionReference user = FirebaseFirestore.instance.collection('Users');

      var flatId = "";

      final querySnapshot = await user
          .where('FlatNo', isEqualTo: flatNo)
          .where('Wing', isEqualTo: wing)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var token= querySnapshot.docs[0]['FcmToken'];
        return token; // Document found
      } else {
        return ''; // Document not found
      }
    } catch (e) {
      print('Error: $e');
      return ''; // Document not found (due to error)
    }
  }

  Future acceptRejectUser(String ar, String eid, String fid) async {
    DocumentReference entry =
        FirebaseFirestore.instance.collection('Entries').doc(eid);
    DocumentReference user = FirebaseFirestore.instance
        .collection('Users')
        .doc(fid)
        .collection('Entries')
        .doc(eid);
    if (ar == "Accept") {
      await entry.update({
        "Approve": "Entry Approved",
      });
      await user.update({
        "Approve": "Entry Approved",
      });
    } else {
      await entry.update({
        "Approve": "Entry Denied",
      });
      await user.update({
        "Approve": "Entry Denied",
      });
    }
  }
}
