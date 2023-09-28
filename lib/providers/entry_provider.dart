import 'dart:io';

import 'package:acrogate/models/entries.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EntryProvider extends ChangeNotifier {
  Future<String> newEntry(Entry entry, File localUrl) async {
    try {
      CollectionReference entries =
          FirebaseFirestore.instance.collection('Entries');
      CollectionReference user = FirebaseFirestore.instance.collection('Users');

      var flatId = "";
      var entryData = {
        "DName": entry.dname,
        "Approve": entry.status,
        "FID": flatId,
        "FlatNo": entry.flatNo,
        "Wing": entry.wing,
        "FirebaseUrl": entry.firebaseUrl,
        "PhoneNo": entry.phone,
        "Date": entry.date,
      };

      final querySnapshot = await user
          .where('FlatNo', isEqualTo: entry.flatNo)
          .where('Wing', isEqualTo: entry.wing)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        flatId = querySnapshot.docs[0].id;
        entryData['FID'] = flatId;
        if (localUrl != null) {
          var storage = FirebaseStorage.instance;
          TaskSnapshot taskSnapshot = await storage
              .ref()
              .child('Entries/$flatId _${DateTime.now()}')
              .putFile(localUrl);
          entryData['FirebaseUrl'] = await taskSnapshot.ref.getDownloadURL();
        } else {
          entryData['FirebaseUrl'] = "";
        }
        var docref = await entries.add(entryData);
        var eid = docref.id;
        await user.doc(flatId).collection('Entries').doc(eid).set(entryData);
        return eid; // Document found
      } else {
        print('Flat not found');
        return ''; // Document not found
      }
    } catch (e) {
      print('Error: $e');
      return ''; // Document not found (due to error)
    }
  }

  Future<String> getToken(flatNo, wing) async {
    try {
      CollectionReference user = FirebaseFirestore.instance.collection('Users');

      // var flatId = "";

      final querySnapshot = await user
          .where('FlatNo', isEqualTo: flatNo)
          .where('Wing', isEqualTo: wing)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var token = querySnapshot.docs[0]['FcmToken'];
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

  Future<String> getNotification(String flatNo, String wing, String eid) async {
    try {
      CollectionReference user = FirebaseFirestore.instance.collection('Users');
      final querySnapshot = await user
          .where('FlatNo', isEqualTo: flatNo)
          .where('Wing', isEqualTo: wing)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var token = "";
        var res = await user
            .doc(querySnapshot.docs[0]['UID'])
            .collection('Entries')
            .doc(eid)
            .get();
        if (res.exists) {
          token = res['Approve'];
          return token;
        } else {
          return token;
        }
      } else {
        return ''; // Document not found
      }
    } catch (e) {
      print('Error: $e');
      return ''; // Document not found (due to error)
    }
  }
}
