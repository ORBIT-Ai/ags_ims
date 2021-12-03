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
    await _fireStoreDB.getEmployeeID().then((value) {
      for (int i = 0; i < value.length; i++) {
        employeeIDs.add(value[i].employeeID);
        isValid = employeeIDs.contains(employeeID);
        //print("VALIDITY: ${employeeIDs.contains(employeeID)}");
      }
    });

    return isValid;
  }

  Future<bool> isEmployeeIDExists({@required String employeeID}) async {
    List<String> employeeIDs = [];
    bool isExist;
    await _fireStoreDB.getUsers().then((value) {
      for (int i = 0; i < value.length; i++) {
        employeeIDs.add(value[i].idNumber);
        isExist = employeeIDs.contains(employeeID);
        //print("EMPLOYEE ID EXIST: ${employeeIDs.contains(employeeID)}");
      }
    });

    return isExist;
  }

  Future<bool> isEmployeeIDAvailable(
      {@required BuildContext context, @required String employeeID}) async {
    bool isAvailable;
    await FirebaseAuth.instance.signInAnonymously().then((value) async {
      print("ANONYMOUS USER: ${value.user.uid}");
    }).whenComplete(() async {
      await isEmployeeIDValid(employeeID: employeeID).then((isValid) async {
        await isEmployeeIDExists(employeeID: employeeID).then((isExist) {
          if (isValid && !isExist) {
            isAvailable = true;
          } else if (!isValid) {
            isAvailable = false;
            _baseUtils.snackBarError(
                context: context, content: "ID Number is not valid");
          } else if (isExist) {
            isAvailable = false;
            _baseUtils.snackBarError(
                context: context, content: "ID Number is not available");
          } else {
            _baseUtils.snackBarError(
                context: context, content: "ID Number is not available");
          }
        });
      }).whenComplete(() {
        if (FirebaseAuth.instance.currentUser != null) {
          FirebaseAuth.instance.currentUser
              .delete()
              .whenComplete(() => FirebaseAuth.instance.signOut());
        }
      });
    });

    return isAvailable;
  }
}
