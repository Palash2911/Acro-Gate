import 'package:flutter/material.dart';
import 'package:acrogate/models/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/flats.dart';

class UserProvider extends ChangeNotifier {
  Future registerUser(Users user) async {
    final prefs = await SharedPreferences.getInstance();
    try {
      var storage = FirebaseStorage.instance;
      TaskSnapshot taskSnapshot = await storage
          .ref()
          .child('Profile/${user.id}')
          .putFile(user.localUrl!);
      user.firebaseUrl = await taskSnapshot.ref.getDownloadURL();
      CollectionReference users =
          FirebaseFirestore.instance.collection('Users');
      await users.doc(user.id).set({
        "Name": user.name,
        "PhoneNo": user.phone,
        "UID": user.id,
        "Email": user.email,
        "FlatNo": user.flatNo,
        "Wing" : user.wing,
        "ProfilePic": user.firebaseUrl,
      });

      prefs.setBool('Profile', true);
      prefs.setString('ProfilePic', user.firebaseUrl);
      prefs.setString("UserName", user.name);

      await registerFlat(Flats(flatId: "", flatNo: user.flatNo, oname: user.name, phone: user.phone, wing: user.wing));

      notifyListeners();
    } catch (e) {
      prefs.setBool('Profile', false);
      prefs.setString('ProfilePic', "");
      prefs.setString("UserName", "");
      notifyListeners();
      rethrow;
    }
  }


  Future registerFlat(Flats flats) async {
    try {
      CollectionReference flat = FirebaseFirestore.instance.collection('Flats');

      var flatData = {
        "Name": flats.oname,
        "PhoneNo": flats.phone,
        "FID": "",
        "FlatNo": flats.flatNo,
        "Wing": flats.wing,
      };

      var docRef = await flat.add(flatData);
      flats.flatId = docRef.id;
      await docRef.update({ "FID": docRef.id });

      notifyListeners();
    } catch (e) {
      notifyListeners();
      rethrow;
    }
  }

  Future updateFlat(Flats flats, String oldFlatno, String oldWing) async {
    try {
      CollectionReference flat = FirebaseFirestore.instance.collection('Flats');

      final querySnapshot = await flat
          .where('FlatNo', isEqualTo: oldFlatno)
          .where('Wing', isEqualTo: oldWing)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        flats.flatId = querySnapshot.docs[0].id;
      }

      await flat.doc(flats.flatId).update({
        "Name": flats.oname,
        "PhoneNo": flats.phone,
        "FID": flats.flatId,
        "FlatNo": flats.flatNo,
        "Wing": flats.wing,
      });

      notifyListeners();
    } catch (e) {
      notifyListeners();
      rethrow;
    }
  }

  Future<Users?> getUserDetails(String uid) async {
    try {
      CollectionReference users =
      FirebaseFirestore.instance.collection('Users');
      Users? user;
      if (uid.isNotEmpty) {
        uid = uid;
      }
      await users.doc(uid.toString()).get().then((DocumentSnapshot query) {
        Map<String, dynamic> data = query.data() as Map<String, dynamic>;
        user = Users(
          id: data["UID"],
          flatNo: data["FlatNo"],
          name: data["Name"],
          email: data["Email"],
          phone: data["PhoneNo"],
          wing: data["Wing"],
          localUrl: null,
          firebaseUrl: data['ProfilePic'],
        );
      });
      notifyListeners();
      return user;
    } catch (e) {
      rethrow;
    }
  }

  Future updateUser(Users user, String oldFlatno, String oldWing) async {
      final prefs = await SharedPreferences.getInstance();
    try {
      if (user.localUrl != null) {
        var storage = FirebaseStorage.instance;
        TaskSnapshot taskSnapshot = await storage
            .ref()
            .child('Profile/${user.id}')
            .putFile(user.localUrl!);
        user.firebaseUrl = await taskSnapshot.ref.getDownloadURL();
      }
      CollectionReference users =
          FirebaseFirestore.instance.collection('Users');
      await users.doc(user.id).update({
        "Name": user.name,
        "PhoneNo": user.phone,
        "UID": user.id,
        "Email": user.email,
        "FlatNo": user.flatNo,
        "Wing" : user.wing,
        "ProfilePic": user.firebaseUrl,
      });
      prefs.setString('ProfilePic', user.firebaseUrl);
      prefs.setString("UserName", user.name);
      updateFlat(Flats(flatId: "", flatNo: user.flatNo, oname: user.name, phone: user.phone, wing: user.wing), oldFlatno, oldWing);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}
