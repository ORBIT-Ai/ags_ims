// ignore_for_file: avoid_print

import 'package:ags_ims/services/auth_service.dart';
import 'package:ags_ims/services/cloud_storage_service.dart';
import 'package:ags_ims/services/firestore_db_service.dart';
import 'package:ags_ims/services/service_locator.dart';
import 'package:ags_ims/utils/base_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class EmployeeIDViewModel {
  final _fireStoreDB = locator<FireStoreDBService>();
  final _auth = locator<Auth>();
  final _baseUtils = locator<BaseUtils>();
  final _cloudStorage = locator<CloudStorageService>();

  Future<bool> isEmployeeIDValid({@required String employeeID}) async {
    List<String> employeeIDs = [];
    bool isValid;
    await FirebaseAuth.instance.signInAnonymously().then((value) async {
      print("ANONYMOUS USER: ${value.user.uid}");
      await _fireStoreDB.getEmployeeID().then((value) {
        for (int i = 0; i < value.length; i++) {
          employeeIDs.add(value[i].employeeID);
          isValid = employeeIDs.contains(employeeID);
          //print("VALIDITY: ${employeeIDs.contains(employeeID)}");
        }
      }).whenComplete(() {
        if(FirebaseAuth.instance.currentUser != null){
          FirebaseAuth.instance.currentUser
              .delete()
              .whenComplete(() => FirebaseAuth.instance.signOut());
        }
      });
    });

    return isValid;
  }

  Future<bool> isEmployeeIDExists({@required String employeeID}) async {
    List<String> employeeIDs = [];
    bool isExist;
    await FirebaseAuth.instance.signInAnonymously().then((value) async {
      print("ANONYMOUS USER: ${value.user.uid}");
      await _fireStoreDB.getUsers().then((value) {
        for (int i = 0; i < value.length; i++) {
          employeeIDs.add(value[i].idNumber);
          isExist = employeeIDs.contains(employeeID);
          //print("EMPLOYEE ID EXIST: ${employeeIDs.contains(employeeID)}");
        }
      }).whenComplete(() {
        if(FirebaseAuth.instance.currentUser != null){
          FirebaseAuth.instance.currentUser
              .delete()
              .whenComplete(() => FirebaseAuth.instance.signOut());
        }
      });
    });

    return isExist;
  }
}
