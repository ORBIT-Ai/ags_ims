
// ignore_for_file: avoid_print, prefer_const_constructors

import 'package:ags_ims/core/models/user_details.dart';
import 'package:ags_ims/services/auth_service.dart';
import 'package:ags_ims/services/firestore_db_service.dart';
import 'package:ags_ims/services/service_locator.dart';
import 'package:ags_ims/views/login_page.dart';
import 'package:flutter/material.dart';

class UserDetailsViewModel {
  final _fireStoreDB = locator<FireStoreDBService>();
  final _auth = locator<Auth>();

  Future<void> setCredentials(
      {@required String userID, @required String email}) async {
    _fireStoreDB.getUserDetails(userID: userID).then((value) {
      final userDetails = UserDetails(
        userID: userID,
        profileUrl: null,
        phoneNumber: null,
        position: null,
        userName: null,
        emailAddress: null,
        idNumber: null,
      );

      _fireStoreDB.setUserDetails(userDetails: userDetails).whenComplete(() {
        print('ADDED USER CREDENTIALS SUCCESSFULLY');
      });
    });
  }

  Future<void> deleteUserData(
      {@required BuildContext context, @required String userID}) async {
    _fireStoreDB.deleteUserDetails(userID: userID).whenComplete(() {
      _auth.deleteAccount().whenComplete(() {
        _auth.signOut().whenComplete(() {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => LoginPage()));
        });
      });
    });
  }
}