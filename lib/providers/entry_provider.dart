import 'package:acrogate/models/entries.dart';
import 'package:flutter/material.dart';
import 'package:acrogate/models/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/flats.dart';

class EntryProvider extends ChangeNotifier {
  Future newEntry(Entry entry) async {
    try {
      CollectionReference entrys = FirebaseFirestore.instance.collection('Entries');

      var entryData = {
        "DName": entry.dname,
        "Approve": entry.status,
        "FID": entry.flatId,
        "FlatNo": entry.flatNo,
        "Wing": entry.wing,
      };

      await entrys.add(entryData);

      notifyListeners();
    } catch (e) {
      notifyListeners();
      rethrow;
    }
  }
}
