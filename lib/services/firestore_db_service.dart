// ignore_for_file: avoid_print

import 'package:ags_ims/core/models/employee_id.dart';
import 'package:ags_ims/core/models/images.dart';
import 'package:ags_ims/core/models/item_details.dart';
import 'package:ags_ims/core/models/history.dart';
import 'package:ags_ims/core/models/item_records.dart';
import 'package:ags_ims/core/models/item_sold.dart';
import 'package:ags_ims/core/models/user_details.dart';
import 'package:ags_ims/services/auth_service.dart';
import 'package:ags_ims/services/firestore_db.dart';
import 'package:ags_ims/services/service_locator.dart';
import 'package:ags_ims/utils/base_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FireStoreDBService extends FireStoreDB {
  final _fireStoreDB = FirebaseFirestore.instance;
  final _auth = locator<Auth>();

  @override
  Future<List<EmployeeID>> getEmployeeID() async {
    CollectionReference collection = _fireStoreDB.collection("employee_id");

    QuerySnapshot doc =
    await collection.get();
    //print(doc.docs.length);
    return doc.docs
        .map((snapshot) => EmployeeID.fromJson(snapshot.data()))
        .toList();
  }

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
    CollectionReference collection = _fireStoreDB.collection("items");

    QuerySnapshot doc =
        await collection.where("isActive", isEqualTo: true).get();
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
    CollectionReference notifications = _fireStoreDB.collection("history");

    QuerySnapshot doc = await notifications.get();
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
    CollectionReference collection = _fireStoreDB.collection("items");

    QuerySnapshot doc =
        await collection.where("isOnHand", isEqualTo: true).get();
    //print(doc.docs.length);
    return doc.docs
        .map((snapshot) => ItemDetails.fromJson(snapshot.data()))
        .toList();
  }

  @override
  Future<List<ItemDetails>> getStockOut() async {
    CollectionReference collection = _fireStoreDB.collection("items");

    QuerySnapshot doc = await collection
        .where("isOnHand", isEqualTo: false)
        .where("itemCount", isEqualTo: 0)
        .get();
    //print(doc.docs.length);
    return doc.docs
        .map((snapshot) => ItemDetails.fromJson(snapshot.data()))
        .toList();
  }

  @override
  Future<List<ItemRecords>> getItemDetailsRecords(
      {@required String itemID}) async {
    final CollectionReference collection = _fireStoreDB
        .collection("items")
        .doc(itemID)
        .collection("details_records");

    QuerySnapshot doc = await collection
        .orderBy("itemRecordsInfo.recordID", descending: true)
        .get();
    //print(doc.docs.length);
    return doc.docs
        .map((snapshot) => ItemRecords.fromJson(snapshot.data()))
        .toList();
  }

  @override
  Future<void> setItemDetailsRecords(
      {@required ItemRecords itemRecords}) async {
    final docRef = _fireStoreDB
        .collection("items")
        .doc(itemRecords.itemID)
        .collection("details_records")
        .doc(itemRecords.itemRecordsInfo['recordID']);

    _fireStoreDB.runTransaction<void>((transaction) async {
      var snapshot = await transaction.get<Map<String, dynamic>>(
        docRef,
      );

      snapshot.exists
          ? transaction.update(
              docRef,
              itemRecords.toJson(),
            )
          : transaction.set(
              docRef,
              itemRecords.toJson(),
            );
    }).whenComplete(() {
      print("FireStore Status: Success");
    });
  }

  @override
  Future<List<ItemRecords>> getItemStockOutRecords(
      {@required String itemID}) async {
    final CollectionReference collection = _fireStoreDB
        .collection("items")
        .doc(itemID)
        .collection("stock_out_records");

    QuerySnapshot doc = await collection
        .orderBy("itemRecordsInfo.recordID", descending: true)
        .get();
    //print(doc.docs.length);
    return doc.docs
        .map((snapshot) => ItemRecords.fromJson(snapshot.data()))
        .toList();
  }

  @override
  Future<void> setItemStockOutRecords(
      {@required ItemRecords itemRecords}) async {
    final docRef = _fireStoreDB
        .collection("items")
        .doc(itemRecords.itemID)
        .collection("stock_out_records")
        .doc(itemRecords.itemRecordsInfo['recordID']);

    _fireStoreDB.runTransaction<void>((transaction) async {
      var snapshot = await transaction.get<Map<String, dynamic>>(
        docRef,
      );

      snapshot.exists
          ? transaction.update(
              docRef,
              itemRecords.toJson(),
            )
          : transaction.set(
              docRef,
              itemRecords.toJson(),
            );
    }).whenComplete(() {
      print("FireStore Status: Success");
    });
  }

  @override
  Future<List<ItemRecords>> getItemReStockRecords(
      {@required String itemID}) async {
    final CollectionReference collection = _fireStoreDB
        .collection("items")
        .doc(itemID)
        .collection("re_stock_records");

    QuerySnapshot doc = await collection
        .orderBy("itemRecordsInfo.recordID", descending: true)
        .get();
    //print(doc.docs.length);
    return doc.docs
        .map((snapshot) => ItemRecords.fromJson(snapshot.data()))
        .toList();
  }

  @override
  Future<void> setItemReStockRecords(
      {@required ItemRecords itemRecords}) async {
    final docRef = _fireStoreDB
        .collection("items")
        .doc(itemRecords.itemID)
        .collection("re_stock_records")
        .doc(itemRecords.itemRecordsInfo['recordID']);

    _fireStoreDB.runTransaction<void>((transaction) async {
      var snapshot = await transaction.get<Map<String, dynamic>>(
        docRef,
      );

      snapshot.exists
          ? transaction.update(
              docRef,
              itemRecords.toJson(),
            )
          : transaction.set(
              docRef,
              itemRecords.toJson(),
            );
    }).whenComplete(() {
      print("FireStore Status: Success");
    });
  }

  @override
  Future<List<ItemRecords>> getItemSoldRecords(
      {@required String itemID}) async {
    final CollectionReference collection =
        _fireStoreDB.collection("items").doc(itemID).collection("sold_records");

    QuerySnapshot doc = await collection
        .orderBy("itemRecordsInfo.recordID", descending: true)
        .get();
    //print(doc.docs.length);
    return doc.docs
        .map((snapshot) => ItemRecords.fromJson(snapshot.data()))
        .toList();
  }

  @override
  Future<void> setItemSoldRecords({@required ItemRecords itemRecords}) async {
    final docRef = _fireStoreDB
        .collection("items")
        .doc(itemRecords.itemID)
        .collection("sold_records")
        .doc(itemRecords.itemRecordsInfo['recordID']);

    _fireStoreDB.runTransaction<void>((transaction) async {
      var snapshot = await transaction.get<Map<String, dynamic>>(
        docRef,
      );

      snapshot.exists
          ? transaction.update(
              docRef,
              itemRecords.toJson(),
            )
          : transaction.set(
              docRef,
              itemRecords.toJson(),
            );
    }).whenComplete(() {
      print("FireStore Status: Success");
    });
  }

  @override
  Future<List<ItemSold>> getItemSold({@required collectiveTerm}) async {
    final CollectionReference collection = _fireStoreDB.collection("sold");

    QuerySnapshot doc;
    if(collectiveTerm == "daily" || collectiveTerm == "monthly" || collectiveTerm == "yearly"){
      doc = await collection
          .where("itemRecordsInfo.date.month",
          isEqualTo: collectiveTerm == "daily" || collectiveTerm == "monthly"
              ? BaseUtils().currentMonth()
              : null)
          .where("itemRecordsInfo.date.day",
          isEqualTo:
          collectiveTerm == "daily" ? BaseUtils().currentDay() : null)
          .where("itemRecordsInfo.date.year",
          isEqualTo: collectiveTerm == "yearly" || collectiveTerm == "monthly"
              ? BaseUtils().currentYear()
              : null)
          .get();
    } else {
      DateTime now = DateTime.now();
      List<int> weekDays = [];
      for(int i=0; i <= 6 ; i++){
        int start = now.subtract(Duration(days: 6)).day;
        weekDays.add(start + i);
      }
      print("WEEKDAYS: ${weekDays.toString()}");
      doc = await collection
          .where("itemRecordsInfo.date.day",
          whereIn: weekDays)
          .where("itemRecordsInfo.date.month",
          isEqualTo: BaseUtils().currentMonth())
          .where("itemRecordsInfo.date.year",
          isEqualTo: BaseUtils().currentYear())
          .get();
    }

    //print(doc.docs.length);
    return doc.docs
        .map((snapshot) => ItemSold.fromJson(snapshot.data()))
        .toList();
  }

  @override
  Future<void> setItemSold({@required ItemSold itemSold}) async {
    final docRef =
        _fireStoreDB.collection("sold").doc(itemSold.itemRecordsInfo['soldID']);

    _fireStoreDB.runTransaction<void>((transaction) async {
      var snapshot = await transaction.get<Map<String, dynamic>>(
        docRef,
      );

      snapshot.exists
          ? transaction.update(
              docRef,
              itemSold.toJson(),
            )
          : transaction.set(
              docRef,
              itemSold.toJson(),
            );
    }).whenComplete(() {
      print("FireStore Status: Success");
    });
  }
}
