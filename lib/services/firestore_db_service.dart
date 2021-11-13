// ignore_for_file: avoid_print

import 'package:ags_ims/core/models/images.dart';
import 'package:ags_ims/core/models/item_details.dart';
import 'package:ags_ims/core/models/history.dart';
import 'package:ags_ims/core/models/user_details.dart';
import 'package:ags_ims/services/auth_service.dart';
import 'package:ags_ims/services/firestore_db.dart';
import 'package:ags_ims/services/service_locator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FireStoreDBService extends FireStoreDB {
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
  Future<void> updateUserDetails({@required UserDetails userDetails}) async {
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

  @override
  Future<void> setProfilePhoto({@required Images profilePhoto}) async {
    final docRef = _fireStoreDB
        .collection("users")
        .doc(profilePhoto.userID)
        .collection("profile_images")
        .doc(profilePhoto.imageID);

    final userInfoRef =
        _fireStoreDB.collection("users").doc(profilePhoto.userID);

    _fireStoreDB.runTransaction<void>((transaction) async {
      var snapshot = await transaction.get<Map<String, dynamic>>(
        userInfoRef,
      );

      snapshot.exists
          ? userInfoRef.update({
              "profileUrl": profilePhoto.url,
            })
          : print('User Info not Exists');
    }).whenComplete(() {
      print("FireStore Status: Success");
    });

    _fireStoreDB.runTransaction<void>((transaction) async {
      var snapshot = await transaction.get<Map<String, dynamic>>(
        docRef,
      );

      snapshot.exists
          ? print('Profile Photo Exists')
          : transaction.set(
              docRef,
              profilePhoto.toJson(),
            );
    }).whenComplete(() {
      print("FireStore Status: Success");
    });
  }

  @override
  Future<void> setStocksItem({@required ItemDetails itemDetails}) async {
    final docRef = _fireStoreDB.collection("items").doc(itemDetails.itemID);

    _fireStoreDB.runTransaction<void>((transaction) async {
      var snapshot = await transaction.get<Map<String, dynamic>>(
        docRef,
      );

      snapshot.exists
          ? print('Item Exists')
          : transaction.set(
              docRef,
              itemDetails.toJson(),
            );
    }).whenComplete(() {
      print("FireStore Status: Success");
    });
  }

  @override
  Future<ItemDetails> getStocksItem({@required String itemID}) {
    final DocumentReference docRef =
        _fireStoreDB.collection("items").doc(itemID);
    return docRef.get().then((DocumentSnapshot documentSnapshot) {
      return documentSnapshot.exists
          ? ItemDetails.fromJson(documentSnapshot.data())
          : null;
    });
  }

  @override
  Future<List<ItemDetails>> getStocks() async {
    CollectionReference collection =
    _fireStoreDB.collection("items");

    QuerySnapshot doc =
        await collection.get();
    //print(doc.docs.length);
    return doc.docs
        .map((snapshot) => ItemDetails.fromJson(snapshot.data()))
        .toList();
  }

  @override
  Future<void> updateStocksItem({@required ItemDetails itemDetails}) async {
    final docRef = _fireStoreDB.collection("items").doc(itemDetails.itemID);

    _fireStoreDB.runTransaction<void>((transaction) async {
      var snapshot = await transaction.get<Map<String, dynamic>>(
        docRef,
      );

      snapshot.exists
          ? transaction.update(
              docRef,
              itemDetails.toJson(),
            )
          : print('Item not existing');
    }).whenComplete(() {
      print("FireStore Status: Success");
    });
  }

  @override
  Future<void> deleteStocksItem({@required ItemDetails itemDetails}) async {
    final docRef = _fireStoreDB.collection("items").doc(itemDetails.itemID);

    _fireStoreDB.runTransaction<void>((transaction) async {
      var snapshot = await transaction.get<Map<String, dynamic>>(
        docRef,
      );

      snapshot.exists
          ? transaction.delete(
              docRef,
            )
          : print('Item not existing');
    }).whenComplete(() {
      print("FireStore Status: Success");
    });
  }

  @override
  Future<List<History>> getHistories() async {
    CollectionReference notifications =
    _fireStoreDB.collection("history");

    QuerySnapshot doc =
    await notifications.get();
    //print(doc.docs.length);
    return doc.docs
        .map((snapshot) => History.fromJson(snapshot.data()))
        .toList();
  }

  @override
  Future<History> getHistory({@required String historyID}) {
    final DocumentReference docRef =
    _fireStoreDB.collection("history").doc(historyID);
    return docRef.get().then((DocumentSnapshot documentSnapshot) {
      return documentSnapshot.exists
          ? History.fromJson(documentSnapshot.data())
          : null;
    });
  }

  @override
  Future<void> setHistory({@required History history}) async {
    final docRef = _fireStoreDB
        .collection("history")
        .doc(history.historyInfo['historyID']);

    _fireStoreDB.runTransaction<void>((transaction) async {
      var snapshot = await transaction.get<Map<String, dynamic>>(
        docRef,
      );

      snapshot.exists
          ? print('History Exists')
          : transaction.set(
        docRef,
        history.toJson(),
      );
    }).whenComplete(() {
      print("FireStore Status: Success");
    });
  }

  @override
  Future<List<ItemDetails>> getOnHand() async {
    CollectionReference collection =
    _fireStoreDB.collection("items");

    QuerySnapshot doc =
    await collection.where("isOnHand", isEqualTo: true).get();
    //print(doc.docs.length);
    return doc.docs
        .map((snapshot) => ItemDetails.fromJson(snapshot.data()))
        .toList();
  }
  
  @override
  Future<List<ItemDetails>> getStockOut() async {
    CollectionReference collection =
    _fireStoreDB.collection("items");

    QuerySnapshot doc =
    await collection.where("isOnHand", isEqualTo: false).get();
    //print(doc.docs.length);
    return doc.docs
        .map((snapshot) => ItemDetails.fromJson(snapshot.data()))
        .toList();
  }
}
