
// ignore_for_file: avoid_print

import 'package:ags_ims/core/models/user_details.dart';
import 'package:ags_ims/services/auth_service.dart';
import 'package:ags_ims/services/firestore_db.dart';
import 'package:ags_ims/services/service_locator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FireStoreDBService extends FireStoreDB{

  final _fireStoreDB = FirebaseFirestore.instance;
  final _auth = locator<Auth>();

  @override
  Future<UserDetails> getUserDetails({@required String userID}) {
    final DocumentReference docRef =
    _fireStoreDB.collection("users").doc(userID);
    return docRef.get().then((DocumentSnapshot documentSnapshot) {
      return documentSnapshot.exists
          ? UserDetails.fromJson(documentSnapshot.data())
          : null;
    });
  }

  @override
  Future<void> setUserDetails({@required UserDetails userDetails}) async {
    final docRef = _fireStoreDB.collection("users").doc(userDetails.userID);

    _fireStoreDB.runTransaction<void>((transaction) async {
      var snapshot = await transaction.get<Map<String, dynamic>>(
        docRef,
      );

      snapshot.exists
          ? transaction.update(
        docRef,
        userDetails.toJson(),
      )
          : transaction.set(
        docRef,
        userDetails.toJson(),
      );
    }).whenComplete(() {
      print("FireStore Status: Success");
    });
  }

  @override
  Future<void> deleteUserDetails({@required userID}) {
    final DocumentReference docRef =
    _fireStoreDB.collection("users").doc(userID);
    return _auth.getCurrentUser() != null
        ? docRef.get().then((DocumentSnapshot documentSnapshot) {
      return documentSnapshot.exists
          ? docRef.delete().whenComplete(() {
        print("USER DATA DELETED");
      })
          : print("USER DATA DOESN'T EXISTS");
    })
        : null;
  }
}